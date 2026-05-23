using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Queries;

public sealed record GetAllCodeElementsQuery : IRequest<IReadOnlyList<CodeElementDto>>;

public sealed record CodeElementDto(
    int Id, string Name, string ElementType,
    bool IsAbstract, bool IsSealed,
    int LayerId, string LayerName,
    int ProjectId, string ProjectName,
    int NamespaceId, string NamespaceFullName,
    int DirectoryId, string DirectoryPath);

public sealed class GetAllCodeElementsQueryHandler(ICodeElementRepository repository)
    : IRequestHandler<GetAllCodeElementsQuery, IReadOnlyList<CodeElementDto>>
{
    public async Task<IReadOnlyList<CodeElementDto>> Handle(GetAllCodeElementsQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetAllAsync(cancellationToken);
        return items.Select(e => new CodeElementDto(
            e.Id, e.Name, e.ElementType, e.IsAbstract, e.IsSealed,
            e.LayerId, e.Layer?.Name ?? string.Empty,
            e.ProjectId, e.Project?.Name ?? string.Empty,
            e.NamespaceId, e.Namespace?.FullName ?? string.Empty,
            e.DirectoryId, e.Directory?.Path ?? string.Empty)).ToList();
    }
}
