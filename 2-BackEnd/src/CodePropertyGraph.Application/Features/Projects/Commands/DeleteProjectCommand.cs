using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Projects.Commands;

public sealed record DeleteProjectCommand(int Id) : IRequest<Result>;

public sealed class DeleteProjectCommandHandler(IProjectRepository repository)
    : IRequestHandler<DeleteProjectCommand, Result>
{
    public async Task<Result> Handle(DeleteProjectCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"Project {request.Id} não encontrado.");
        await repository.DeleteAsync(item, cancellationToken);
        return Result.Success();
    }
}
