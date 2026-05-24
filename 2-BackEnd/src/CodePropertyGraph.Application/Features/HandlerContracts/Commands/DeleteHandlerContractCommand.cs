using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.HandlerContracts.Commands;

public sealed record DeleteHandlerContractCommand(int HandlerId) : IRequest<Result>;

public sealed class DeleteHandlerContractCommandValidator : AbstractValidator<DeleteHandlerContractCommand>
{
    public DeleteHandlerContractCommandValidator()
    {
        RuleFor(x => x.HandlerId).GreaterThan(0);
    }
}

public sealed class DeleteHandlerContractCommandHandler(IHandlerContractRepository repository)
    : IRequestHandler<DeleteHandlerContractCommand, Result>
{
    public async Task<Result> Handle(DeleteHandlerContractCommand request, CancellationToken cancellationToken)
    {
        var contract = await repository.GetByHandlerIdAsync(request.HandlerId, cancellationToken);
        if (contract is null) return Result.Failure("Contrato de handler não encontrado.");

        await repository.DeleteAsync(contract, cancellationToken);
        return Result.Success();
    }
}
