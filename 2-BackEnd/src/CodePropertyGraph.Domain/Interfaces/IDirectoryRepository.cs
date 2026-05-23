using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface IDirectoryRepository : IRepository<Entities.Directory>
{
    Task<Entities.Directory?> GetByPathAsync(string path, CancellationToken cancellationToken = default);
}
