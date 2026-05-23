using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class CodeElementRepository(AppDbContext context) : BaseRepository<CodeElement>(context), ICodeElementRepository
{
    public async Task<IReadOnlyList<CodeElement>> GetByLayerAsync(int layerId, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking()
            .Include(e => e.Layer).Include(e => e.Project)
            .Include(e => e.Namespace).Include(e => e.Directory)
            .Where(e => e.LayerId == layerId).ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<CodeElement>> GetByProjectAsync(int projectId, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking()
            .Include(e => e.Layer).Include(e => e.Project)
            .Include(e => e.Namespace).Include(e => e.Directory)
            .Where(e => e.ProjectId == projectId).ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<CodeElement>> GetByElementTypeAsync(string elementType, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking().Where(e => e.ElementType == elementType).ToListAsync(cancellationToken);

    public async Task<CodeElement?> GetWithRelationsAsync(int id, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking()
            .Include(e => e.Layer).Include(e => e.Project)
            .Include(e => e.Namespace).Include(e => e.Directory)
            .FirstOrDefaultAsync(e => e.Id == id, cancellationToken);

    public override async Task<IReadOnlyList<CodeElement>> GetAllAsync(CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking()
            .Include(e => e.Layer).Include(e => e.Project)
            .Include(e => e.Namespace).Include(e => e.Directory)
            .ToListAsync(cancellationToken);
}
