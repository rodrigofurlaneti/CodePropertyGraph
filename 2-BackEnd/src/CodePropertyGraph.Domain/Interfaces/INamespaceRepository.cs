using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface INamespaceRepository : IRepository<Namespace>
{
    Task<Namespace?> GetByFullNameAsync(string fullName, CancellationToken cancellationToken = default);
}
