using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface IApiEndpointRepository
{
    Task<IReadOnlyList<ApiEndpoint>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<ApiEndpoint?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task<ApiEndpoint> AddAsync(ApiEndpoint entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(ApiEndpoint entity, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(int controllerId, string methodName, CancellationToken cancellationToken = default);
}
