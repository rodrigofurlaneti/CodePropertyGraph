using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using DomainDirectory = CodePropertyGraph.Domain.Entities.Directory;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class DirectoryRepository(AppDbContext context) : BaseRepository<DomainDirectory>(context), IDirectoryRepository
{
    public async Task<DomainDirectory?> GetByPathAsync(string path, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking().FirstOrDefaultAsync(d => d.Path == path, cancellationToken);
}
