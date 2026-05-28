using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Domain.ValueObjects;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Commands;

public sealed record UpdateCodeElementCommand(
    int Id, string Name, string ElementType,
    int LayerId, int ProjectId, int NamespaceId, int DirectoryId,
    bool IsAbstract, bool IsSealed) : IRequest<Result>;

public sealed class UpdateCodeElementCommandValidator : AbstractValidator<UpdateCodeElementCommand>
{
    public UpdateCodeElementCommandValidator()
    {
        RuleFor(x => x.Id).GreaterThan(0);

        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(ElementName.MaxLength)
            .WithMessage($"Name nao pode exceder {ElementName.MaxLength} caracteres.");

        RuleFor(x => x.ElementType)
            .NotEmpty()
            .Must(Domain.ValueObjects.ElementType.IsValid)
            .WithMessage(
                $"ElementType invalido. Valores aceitos: " +
                $"{string.Join(", ", Domain.ValueObjects.ElementType.AllValues)}.");

        RuleFor(x => x.LayerId).GreaterThan(0);
        RuleFor(x => x.ProjectId).GreaterThan(0);
        RuleFor(x => x.NamespaceId).GreaterThan(0);
        RuleFor(x => x.DirectoryId).GreaterThan(0);
    }
}

public sealed class UpdateCodeElementCommandHandler(ICodeElementRepository repository)
    : IRequestHandler<UpdateCodeElementCommand, Result>
{
    public async Task<Result> Handle(UpdateCodeElementCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"CodeElement {request.Id} nao encontrado.");
        item.Update(request.Name, request.ElementType,
            request.LayerId, request.ProjectId, request.NamespaceId, request.DirectoryId,
            request.IsAbstract, request.IsSealed);
        await repository.UpdateAsync(item, cancellationToken);
        return Result.Success();
    }
}
