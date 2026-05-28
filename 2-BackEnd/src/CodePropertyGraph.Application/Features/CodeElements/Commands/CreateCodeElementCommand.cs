using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Domain.ValueObjects;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Commands;

public sealed record CreateCodeElementCommand(
    string Name, string ElementType,
    int LayerId, int ProjectId, int NamespaceId, int DirectoryId,
    bool IsAbstract = false, bool IsSealed = false) : IRequest<Result<int>>;

public sealed class CreateCodeElementCommandValidator : AbstractValidator<CreateCodeElementCommand>
{
    public CreateCodeElementCommandValidator()
    {
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

public sealed class CreateCodeElementCommandHandler(ICodeElementRepository repository)
    : IRequestHandler<CreateCodeElementCommand, Result<int>>
{
    public async Task<Result<int>> Handle(CreateCodeElementCommand request, CancellationToken cancellationToken)
    {
        var item = CodeElement.Create(
            request.Name, request.ElementType,
            request.LayerId, request.ProjectId, request.NamespaceId, request.DirectoryId,
            request.IsAbstract, request.IsSealed);
        await repository.AddAsync(item, cancellationToken);
        return Result<int>.Success(item.Id);
    }
}
