using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface ILayerRepository : IRepository<Layer>
{
    Task<Layer?> GetByNameAsync(string name, CancellationToken cancellationToken = default);
}
