using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Namespaces.Queries;

public sealed record GetNamespaceByIdQuery(int Id) : IRequest<Result<NamespaceDto>>;

public sealed class GetNamespaceByIdQueryHandler(INamespaceRepository repository)
    : IRequestHandler<GetNamespaceByIdQuery, Result<NamespaceDto>>
{
    public async Task<Result<NamespaceDto>> Handle(GetNamespaceByIdQuery request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        return item is null
            ? Result<NamespaceDto>.Failure($"Namespace {request.Id} não encontrado.")
            : Result<NamespaceDto>.Success(new NamespaceDto(item.Id, item.FullName));
    }
}
