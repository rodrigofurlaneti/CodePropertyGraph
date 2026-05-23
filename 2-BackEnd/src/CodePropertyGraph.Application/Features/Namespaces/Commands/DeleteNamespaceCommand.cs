using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Namespaces.Commands;

public sealed record DeleteNamespaceCommand(int Id) : IRequest<Result>;

public sealed class DeleteNamespaceCommandHandler(INamespaceRepository repository)
    : IRequestHandler<DeleteNamespaceCommand, Result>
{
    public async Task<Result> Handle(DeleteNamespaceCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"Namespace {request.Id} não encontrado.");
        await repository.DeleteAsync(item, cancellationToken);
        return Result.Success();
    }
}
