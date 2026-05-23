using CodePropertyGraph.Domain.Entities;

namespace CodePropertyGraph.Domain.Interfaces;

public interface IProjectRepository : IRepository<Project>
{
    Task<IReadOnlyList<Project>> GetByTypeAsync(string projectType, CancellationToken cancellationToken = default);
}
