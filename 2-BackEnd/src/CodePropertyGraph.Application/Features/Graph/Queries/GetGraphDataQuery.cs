using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Graph.Queries;

/// <summary>
/// Query que retorna todos os dados necessários para renderizar o Knowledge Graph no frontend.
/// Retorna nós (CodeElements) e arestas (Implementations + Dependencies).
/// </summary>
public sealed record GetGraphDataQuery(int? ProjectId = null, int? LayerId = null) : IRequest<GraphDataDto>;

public sealed record GraphNodeDto(
    string Id, string Label, string Type,
    string Layer, string Project, string Namespace,
    bool IsAbstract, bool IsSealed);

public sealed record GraphEdgeDto(
    string Id, string Source, string Target,
    string EdgeType, string Label, bool IsDirect);

public sealed record GraphDataDto(
    IReadOnlyList<GraphNodeDto> Nodes,
    IReadOnlyList<GraphEdgeDto> Edges);

public sealed class GetGraphDataQueryHandler(
    ICodeElementRepository codeElementRepository,
    IElementImplementationRepository implementationRepository,
    IElementDependencyRepository dependencyRepository,
    IApiEndpointRepository apiEndpointRepository,
    IHandlerContractRepository handlerContractRepository)
    : IRequestHandler<GetGraphDataQuery, GraphDataDto>
{
    public async Task<GraphDataDto> Handle(GetGraphDataQuery request, CancellationToken cancellationToken)
    {
        var elements = request.ProjectId.HasValue
            ? await codeElementRepository.GetByProjectAsync(request.ProjectId.Value, cancellationToken)
            : request.LayerId.HasValue
                ? await codeElementRepository.GetByLayerAsync(request.LayerId.Value, cancellationToken)
                : await codeElementRepository.GetAllAsync(cancellationToken);

        var elementIds = elements.Select(e => e.Id).ToHashSet();

        var implementations    = await implementationRepository.GetAllAsync(cancellationToken);
        var dependencies       = await dependencyRepository.GetAllAsync(cancellationToken);
        var apiEndpoints       = await apiEndpointRepository.GetAllAsync(cancellationToken);
        var handlerContracts   = await handlerContractRepository.GetAllAsync(cancellationToken);

        var nodes = elements.Select(e => new GraphNodeDto(
            e.Id.ToString(),
            e.Name,
            e.ElementType,
            e.Layer?.Name ?? string.Empty,
            e.Project?.Name ?? string.Empty,
            e.Namespace?.FullName ?? string.Empty,
            e.IsAbstract,
            e.IsSealed)).ToList();

        var edges = new List<GraphEdgeDto>();

        // Arestas IMPLEMENTS
        foreach (var impl in implementations.Where(i => elementIds.Contains(i.ClassId) && elementIds.Contains(i.InterfaceId)))
        {
            edges.Add(new GraphEdgeDto(
                $"impl-{impl.ClassId}-{impl.InterfaceId}",
                impl.ClassId.ToString(), impl.InterfaceId.ToString(),
                "IMPLEMENTS", "implements", true));
        }

        // Arestas DEPENDS_ON
        foreach (var dep in dependencies.Where(d => elementIds.Contains(d.SourceElementId) && elementIds.Contains(d.TargetElementId)))
        {
            edges.Add(new GraphEdgeDto(
                $"dep-{dep.SourceElementId}-{dep.TargetElementId}-{dep.DependencyType}",
                dep.SourceElementId.ToString(), dep.TargetElementId.ToString(),
                "DEPENDS_ON", dep.DependencyType, dep.IsDirect));
        }

        // Arestas HTTP_INPUT / HTTP_OUTPUT (Controller ↔ DTOs via ApiEndpoint)
        foreach (var ep in apiEndpoints)
        {
            if (ep.InputId.HasValue && elementIds.Contains(ep.ControllerId) && elementIds.Contains(ep.InputId.Value))
            {
                edges.Add(new GraphEdgeDto(
                    $"ep-input-{ep.Id}",
                    ep.ControllerId.ToString(), ep.InputId.Value.ToString(),
                    "HTTP_INPUT", $"{ep.HttpVerb} ↓ input", true));
            }

            if (ep.OutputId.HasValue && elementIds.Contains(ep.ControllerId) && elementIds.Contains(ep.OutputId.Value))
            {
                edges.Add(new GraphEdgeDto(
                    $"ep-output-{ep.Id}",
                    ep.ControllerId.ToString(), ep.OutputId.Value.ToString(),
                    "HTTP_OUTPUT", $"{ep.HttpVerb} ↑ output", true));
            }
        }

        // Arestas HANDLER_INPUT / HANDLER_OUTPUT (Handler ↔ Command/Response)
        foreach (var hc in handlerContracts)
        {
            if (elementIds.Contains(hc.HandlerId) && elementIds.Contains(hc.InputId))
            {
                edges.Add(new GraphEdgeDto(
                    $"hc-input-{hc.HandlerId}",
                    hc.HandlerId.ToString(), hc.InputId.ToString(),
                    "HANDLER_INPUT", "handles", true));
            }

            if (elementIds.Contains(hc.HandlerId) && elementIds.Contains(hc.OutputId))
            {
                edges.Add(new GraphEdgeDto(
                    $"hc-output-{hc.HandlerId}",
                    hc.HandlerId.ToString(), hc.OutputId.ToString(),
                    "HANDLER_OUTPUT", "returns", true));
            }
        }

        return new GraphDataDto(nodes, edges);
    }
}
