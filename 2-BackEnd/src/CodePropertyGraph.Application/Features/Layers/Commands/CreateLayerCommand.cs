using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.Layers.Commands;

public sealed record CreateLayerCommand(string Name, string? Description) : IRequest<Result<int>>;

public sealed class CreateLayerCommandValidator : AbstractValidator<CreateLayerCommand>
{
    public CreateLayerCommandValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(100);
        RuleFor(x => x.Description).MaximumLength(255).When(x => x.Description is not null);
    }
}

public sealed class CreateLayerCommandHandler(ILayerRepository repository)
    : IRequestHandler<CreateLayerCommand, Result<int>>
{
    public async Task<Result<int>> Handle(CreateLayerCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(l => l.Name == request.Name, cancellationToken);
        if (exists)
            return Result<int>.Failure($"Já existe uma Layer com o nome '{request.Name}'.");

        var layer = Layer.Create(request.Name, request.Description);
        await repository.AddAsync(layer, cancellationToken);
        return Result<int>.Success(layer.Id);
    }
}
