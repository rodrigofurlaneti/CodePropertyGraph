using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class LayerRepository(AppDbContext context) : BaseRepository<Layer>(context), ILayerRepository
{
    public async Task<Layer?> GetByNameAsync(string name, CancellationToken cancellationToken = default)
        => await DbSet.AsNoTracking().FirstOrDefaultAsync(l => l.Name == name, cancellationToken);
}
