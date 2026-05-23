using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.ElementImplementations.Queries;

public sealed record GetAllElementImplementationsQuery : IRequest<IReadOnlyList<ElementImplementationDto>>;
public sealed record ElementImplementationDto(int ClassId, string ClassName, int InterfaceId, string InterfaceName);

public sealed class GetAllElementImplementationsQueryHandler(IElementImplementationRepository repository)
    : IRequestHandler<GetAllElementImplementationsQuery, IReadOnlyList<ElementImplementationDto>>
{
    public async Task<IReadOnlyList<ElementImplementationDto>> Handle(GetAllElementImplementationsQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetAllAsync(cancellationToken);
        return items.Select(i => new ElementImplementationDto(
            i.ClassId, i.Class?.Name ?? string.Empty,
            i.InterfaceId, i.Interface?.Name ?? string.Empty)).ToList();
    }
}
