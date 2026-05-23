using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Namespaces.Commands;

public sealed record UpdateNamespaceCommand(int Id, string FullName) : IRequest<Result>;

public sealed class UpdateNamespaceCommandHandler(INamespaceRepository repository)
    : IRequestHandler<UpdateNamespaceCommand, Result>
{
    public async Task<Result> Handle(UpdateNamespaceCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"Namespace {request.Id} não encontrado.");
        item.Update(request.FullName);
        await repository.UpdateAsync(item, cancellationToken);
        return Result.Success();
    }
}
