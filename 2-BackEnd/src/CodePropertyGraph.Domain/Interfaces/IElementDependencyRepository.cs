using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface IElementDependencyRepository
{
    Task<IReadOnlyList<ElementDependency>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<ElementDependency>> GetBySourceAsync(int sourceElementId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<ElementDependency>> GetByTargetAsync(int targetElementId, CancellationToken cancellationToken = default);
    Task<ElementDependency?> GetByCompositeKeyAsync(int sourceId, int targetId, string dependencyType, CancellationToken cancellationToken = default);
    Task<ElementDependency> AddAsync(ElementDependency entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(ElementDependency entity, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(int sourceId, int targetId, string dependencyType, CancellationToken cancellationToken = default);
    /// <summary>Detecta violações de Clean Architecture (ex: Domain dependendo de Infrastructure)</summary>
    Task<IReadOnlyList<ArchitectureViolation>> GetArchitectureViolationsAsync(string sourceLayerName, string targetLayerName, CancellationToken cancellationToken = default);
}

public sealed record ArchitectureViolation(string SourceElementName, string ForbiddenDependencyName);
