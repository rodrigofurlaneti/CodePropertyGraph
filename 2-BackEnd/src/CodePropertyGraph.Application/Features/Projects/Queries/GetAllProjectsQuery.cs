using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Projects.Queries;

public sealed record GetAllProjectsQuery : IRequest<IReadOnlyList<ProjectDto>>;
public sealed record ProjectDto(int Id, string Name, string ProjectType);

public sealed class GetAllProjectsQueryHandler(IProjectRepository repository)
    : IRequestHandler<GetAllProjectsQuery, IReadOnlyList<ProjectDto>>
{
    public async Task<IReadOnlyList<ProjectDto>> Handle(GetAllProjectsQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetAllAsync(cancellationToken);
        return items.Select(p => new ProjectDto(p.Id, p.Name, p.ProjectType)).ToList();
    }
}
