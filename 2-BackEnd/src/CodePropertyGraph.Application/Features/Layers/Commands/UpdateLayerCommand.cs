using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.Layers.Commands;

public sealed record UpdateLayerCommand(int Id, string Name, string? Description) : IRequest<Result>;

public sealed class UpdateLayerCommandValidator : AbstractValidator<UpdateLayerCommand>
{
    public UpdateLayerCommandValidator()
    {
        RuleFor(x => x.Id).GreaterThan(0);
        RuleFor(x => x.Name).NotEmpty().MaximumLength(100);
        RuleFor(x => x.Description).MaximumLength(255).When(x => x.Description is not null);
    }
}

public sealed class UpdateLayerCommandHandler(ILayerRepository repository)
    : IRequestHandler<UpdateLayerCommand, Result>
{
    public async Task<Result> Handle(UpdateLayerCommand request, CancellationToken cancellationToken)
    {
        var layer = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (layer is null)
            return Result.Failure($"Layer com Id {request.Id} não encontrada.");

        layer.Update(request.Name, request.Description);
        await repository.UpdateAsync(layer, cancellationToken);
        return Result.Success();
    }
}
