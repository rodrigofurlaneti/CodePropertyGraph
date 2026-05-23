using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class ElementDependencyRepository(AppDbContext context) : IElementDependencyRepository
{
    private readonly AppDbContext _context = context;

    public async Task<IReadOnlyList<ElementDependency>> GetAllAsync(CancellationToken cancellationToken = default)
        => await _context.ElementDependencies.AsNoTracking()
            .Include(d => d.SourceElement).Include(d => d.TargetElement)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<ElementDependency>> GetBySourceAsync(int sourceElementId, CancellationToken cancellationToken = default)
        => await _context.ElementDependencies.AsNoTracking()
            .Include(d => d.TargetElement)
            .Where(d => d.SourceElementId == sourceElementId).ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<ElementDependency>> GetByTargetAsync(int targetElementId, CancellationToken cancellationToken = default)
        => await _context.ElementDependencies.AsNoTracking()
            .Include(d => d.SourceElement)
            .Where(d => d.TargetElementId == targetElementId).ToListAsync(cancellationToken);

    public async Task<ElementDependency?> GetByCompositeKeyAsync(int sourceId, int targetId, string dependencyType, CancellationToken cancellationToken = default)
        => await _context.ElementDependencies.AsNoTracking()
            .FirstOrDefaultAsync(d => d.SourceElementId == sourceId && d.TargetElementId == targetId && d.DependencyType == dependencyType, cancellationToken);

    public async Task<ElementDependency> AddAsync(ElementDependency entity, CancellationToken cancellationToken = default)
    {
        await _context.ElementDependencies.AddAsync(entity, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
        return entity;
    }

    public async Task DeleteAsync(ElementDependency entity, CancellationToken cancellationToken = default)
    {
        _context.ElementDependencies.Remove(entity);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(int sourceId, int targetId, string dependencyType, CancellationToken cancellationToken = default)
        => await _context.ElementDependencies.AsNoTracking()
            .AnyAsync(d => d.SourceElementId == sourceId && d.TargetElementId == targetId && d.DependencyType == dependencyType, cancellationToken);

    public async Task<IReadOnlyList<ArchitectureViolation>> GetArchitectureViolationsAsync(
        string sourceLayerName, string targetLayerName, CancellationToken cancellationToken = default)
    {
        var violations = await _context.ElementDependencies.AsNoTracking()
            .Include(d => d.SourceElement).ThenInclude(e => e.Layer)
            .Include(d => d.TargetElement).ThenInclude(e => e.Layer)
            .Where(d =>
                d.SourceElement.Layer.Name == sourceLayerName &&
                d.TargetElement.Layer.Name == targetLayerName)
            .Select(d => new ArchitectureViolation(d.SourceElement.Name, d.TargetElement.Name))
            .ToListAsync(cancellationToken);

        return violations;
    }
}
