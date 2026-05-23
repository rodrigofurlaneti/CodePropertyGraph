using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Queries;

public sealed record GetCodeElementsByLayerQuery(int LayerId) : IRequest<IReadOnlyList<CodeElementDto>>;

public sealed class GetCodeElementsByLayerQueryHandler(ICodeElementRepository repository)
    : IRequestHandler<GetCodeElementsByLayerQuery, IReadOnlyList<CodeElementDto>>
{
    public async Task<IReadOnlyList<CodeElementDto>> Handle(GetCodeElementsByLayerQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetByLayerAsync(request.LayerId, cancellationToken);
        return items.Select(e => new CodeElementDto(
            e.Id, e.Name, e.ElementType, e.IsAbstract, e.IsSealed,
            e.LayerId, e.Layer?.Name ?? string.Empty,
            e.ProjectId, e.Project?.Name ?? string.Empty,
            e.NamespaceId, e.Namespace?.FullName ?? string.Empty,
            e.DirectoryId, e.Directory?.Path ?? string.Empty)).ToList();
    }
}
