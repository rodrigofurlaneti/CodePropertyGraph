using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class ProjectRepository(AppDbContext context) : BaseRepository<Project>(context), IProjectRepository
{
    public async Task<IReadOnlyList<Project>> GetByTypeAsync(string projectType, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking().Where(p => p.ProjectType == projectType).ToListAsync(cancellationToken);
}
