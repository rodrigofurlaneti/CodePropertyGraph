using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface IHandlerContractRepository
{
    Task<IReadOnlyList<HandlerContract>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<HandlerContract?> GetByHandlerIdAsync(int handlerId, CancellationToken cancellationToken = default);
    Task<HandlerContract> AddAsync(HandlerContract entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(HandlerContract entity, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(int handlerId, CancellationToken cancellationToken = default);
}
