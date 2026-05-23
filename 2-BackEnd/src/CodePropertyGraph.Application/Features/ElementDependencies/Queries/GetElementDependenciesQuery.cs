using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.ElementDependencies.Queries;

public sealed record GetAllElementDependenciesQuery : IRequest<IReadOnlyList<ElementDependencyDto>>;

public sealed record ElementDependencyDto(
    int SourceElementId, string SourceElementName,
    int TargetElementId, string TargetElementName,
    string DependencyType, bool IsDirect);

public sealed class GetAllElementDependenciesQueryHandler(IElementDependencyRepository repository)
    : IRequestHandler<GetAllElementDependenciesQuery, IReadOnlyList<ElementDependencyDto>>
{
    public async Task<IReadOnlyList<ElementDependencyDto>> Handle(GetAllElementDependenciesQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetAllAsync(cancellationToken);
        return items.Select(d => new ElementDependencyDto(
            d.SourceElementId, d.SourceElement?.Name ?? string.Empty,
            d.TargetElementId, d.TargetElement?.Name ?? string.Empty,
            d.DependencyType, d.IsDirect)).ToList();
    }
}
