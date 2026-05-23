using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Directories.Commands;

public sealed record DeleteDirectoryCommand(int Id) : IRequest<Result>;

public sealed class DeleteDirectoryCommandHandler(IDirectoryRepository repository)
    : IRequestHandler<DeleteDirectoryCommand, Result>
{
    public async Task<Result> Handle(DeleteDirectoryCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"Directory {request.Id} não encontrado.");
        await repository.DeleteAsync(item, cancellationToken);
        return Result.Success();
    }
}
