using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface ICodeElementRepository : IRepository<CodeElement>
{
    Task<IReadOnlyList<CodeElement>> GetByLayerAsync(int layerId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<CodeElement>> GetByProjectAsync(int projectId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<CodeElement>> GetByElementTypeAsync(string elementType, CancellationToken cancellationToken = default);
    Task<CodeElement?> GetWithRelationsAsync(int id, CancellationToken cancellationToken = default);
}
