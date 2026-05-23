using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Directories.Commands;

public sealed record UpdateDirectoryCommand(int Id, string Path) : IRequest<Result>;

public sealed class UpdateDirectoryCommandHandler(IDirectoryRepository repository)
    : IRequestHandler<UpdateDirectoryCommand, Result>
{
    public async Task<Result> Handle(UpdateDirectoryCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"Directory {request.Id} não encontrado.");
        item.Update(request.Path);
        await repository.UpdateAsync(item, cancellationToken);
        return Result.Success();
    }
}
