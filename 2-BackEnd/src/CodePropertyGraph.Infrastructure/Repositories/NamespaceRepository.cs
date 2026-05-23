using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using DomainNamespace = CodePropertyGraph.Domain.Entities.Namespace;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class NamespaceRepository(AppDbContext context) : BaseRepository<DomainNamespace>(context), INamespaceRepository
{
    public async Task<DomainNamespace?> GetByFullNameAsync(string fullName, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking().FirstOrDefaultAsync(n => n.FullName == fullName, cancellationToken);
}
