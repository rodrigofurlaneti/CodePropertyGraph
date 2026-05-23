using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface IElementImplementationRepository
{
    Task<IReadOnlyList<ElementImplementation>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<ElementImplementation>> GetByClassIdAsync(int classId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<ElementImplementation>> GetByInterfaceIdAsync(int interfaceId, CancellationToken cancellationToken = default);
    Task<ElementImplementation?> GetByIdsAsync(int classId, int interfaceId, CancellationToken cancellationToken = default);
    Task<ElementImplementation> AddAsync(ElementImplementation entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(ElementImplementation entity, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(int classId, int interfaceId, CancellationToken cancellationToken = default);
}
