using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Commands;

public sealed record DeleteCodeElementCommand(int Id) : IRequest<Result>;

public sealed class DeleteCodeElementCommandHandler(ICodeElementRepository repository)
    : IRequestHandler<DeleteCodeElementCommand, Result>
{
    public async Task<Result> Handle(DeleteCodeElementCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"CodeElement {request.Id} não encontrado.");
        await repository.DeleteAsync(item, cancellationToken);
        return Result.Success();
    }
}
