using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.ApiEndpoints.Queries;

public sealed record GetAllApiEndpointsQuery : IRequest<IReadOnlyList<ApiEndpoint>>;

public sealed class GetAllApiEndpointsQueryHandler(IApiEndpointRepository repository)
    : IRequestHandler<GetAllApiEndpointsQuery, IReadOnlyList<ApiEndpoint>>
{
    public Task<IReadOnlyList<ApiEndpoint>> Handle(GetAllApiEndpointsQuery request, CancellationToken cancellationToken)
        => repository.GetAllAsync(cancellationToken);
}
