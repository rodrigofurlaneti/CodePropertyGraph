using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.ElementDependencies.Commands;

public sealed record CreateElementDependencyCommand(
    int SourceElementId, int TargetElementId,
    string DependencyType, bool IsDirect = true) : IRequest<Result>;

public sealed class CreateElementDependencyCommandValidator : AbstractValidator<CreateElementDependencyCommand>
{
    public CreateElementDependencyCommandValidator()
    {
        RuleFor(x => x.SourceElementId).GreaterThan(0);
        RuleFor(x => x.TargetElementId).GreaterThan(0);
        RuleFor(x => x.DependencyType).NotEmpty().MaximumLength(50);
    }
}

public sealed class CreateElementDependencyCommandHandler(IElementDependencyRepository repository)
    : IRequestHandler<CreateElementDependencyCommand, Result>
{
    public async Task<Result> Handle(CreateElementDependencyCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(request.SourceElementId, request.TargetElementId, request.DependencyType, cancellationToken);
        if (exists) return Result.Failure("Esta dependência já existe.");
        var item = ElementDependency.Create(request.SourceElementId, request.TargetElementId, request.DependencyType, request.IsDirect);
        await repository.AddAsync(item, cancellationToken);
        return Result.Success();
    }
}
