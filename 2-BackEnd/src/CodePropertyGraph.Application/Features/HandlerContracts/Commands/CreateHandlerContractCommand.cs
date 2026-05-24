using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.HandlerContracts.Commands;

public sealed record CreateHandlerContractCommand(
    int HandlerId,
    int InputId,
    int OutputId) : IRequest<Result>;

public sealed class CreateHandlerContractCommandValidator : AbstractValidator<CreateHandlerContractCommand>
{
    public CreateHandlerContractCommandValidator()
    {
        RuleFor(x => x.HandlerId).GreaterThan(0);
        RuleFor(x => x.InputId).GreaterThan(0);
        RuleFor(x => x.OutputId).GreaterThan(0);
    }
}

public sealed class CreateHandlerContractCommandHandler(IHandlerContractRepository repository)
    : IRequestHandler<CreateHandlerContractCommand, Result>
{
    public async Task<Result> Handle(CreateHandlerContractCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(request.HandlerId, cancellationToken);
        if (exists) return Result.Failure("Já existe um contrato para este handler.");

        var contract = HandlerContract.Create(request.HandlerId, request.InputId, request.OutputId);
        await repository.AddAsync(contract, cancellationToken);
        return Result.Success();
    }
}
