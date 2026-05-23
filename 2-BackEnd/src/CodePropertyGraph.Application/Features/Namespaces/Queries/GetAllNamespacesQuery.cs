using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Namespaces.Queries;

public sealed record GetAllNamespacesQuery : IRequest<IReadOnlyList<NamespaceDto>>;
public sealed record NamespaceDto(int Id, string FullName);

public sealed class GetAllNamespacesQueryHandler(INamespaceRepository repository)
    : IRequestHandler<GetAllNamespacesQuery, IReadOnlyList<NamespaceDto>>
{
    public async Task<IReadOnlyList<NamespaceDto>> Handle(GetAllNamespacesQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetAllAsync(cancellationToken);
        return items.Select(n => new NamespaceDto(n.Id, n.FullName)).ToList();
    }
}
