using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Projects.Queries;

public sealed record GetProjectByIdQuery(int Id) : IRequest<Result<ProjectDto>>;

public sealed class GetProjectByIdQueryHandler(IProjectRepository repository)
    : IRequestHandler<GetProjectByIdQuery, Result<ProjectDto>>
{
    public async Task<Result<ProjectDto>> Handle(GetProjectByIdQuery request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        return item is null
            ? Result<ProjectDto>.Failure($"Project {request.Id} não encontrado.")
            : Result<ProjectDto>.Success(new ProjectDto(item.Id, item.Name, item.ProjectType));
    }
}
