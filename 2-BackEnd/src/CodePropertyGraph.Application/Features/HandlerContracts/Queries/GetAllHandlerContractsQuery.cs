using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.HandlerContracts.Queries;

public sealed record GetAllHandlerContractsQuery : IRequest<IReadOnlyList<HandlerContract>>;

public sealed class GetAllHandlerContractsQueryHandler(IHandlerContractRepository repository)
    : IRequestHandler<GetAllHandlerContractsQuery, IReadOnlyList<HandlerContract>>
{
    public Task<IReadOnlyList<HandlerContract>> Handle(GetAllHandlerContractsQuery request, CancellationToken cancellationToken)
        => repository.GetAllAsync(cancellationToken);
}
