using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.ElementImplementations.Commands;

public sealed record DeleteElementImplementationCommand(int ClassId, int InterfaceId) : IRequest<Result>;

public sealed class DeleteElementImplementationCommandHandler(IElementImplementationRepository repository)
    : IRequestHandler<DeleteElementImplementationCommand, Result>
{
    public async Task<Result> Handle(DeleteElementImplementationCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdsAsync(request.ClassId, request.InterfaceId, cancellationToken);
        if (item is null) return Result.Failure("Implementação não encontrada.");
        await repository.DeleteAsync(item, cancellationToken);
        return Result.Success();
    }
}
