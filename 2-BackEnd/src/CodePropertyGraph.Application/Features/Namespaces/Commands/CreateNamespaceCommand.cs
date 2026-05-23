using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.Namespaces.Commands;

public sealed record CreateNamespaceCommand(string FullName) : IRequest<Result<int>>;

public sealed class CreateNamespaceCommandValidator : AbstractValidator<CreateNamespaceCommand>
{
    public CreateNamespaceCommandValidator() => RuleFor(x => x.FullName).NotEmpty().MaximumLength(500);
}

public sealed class CreateNamespaceCommandHandler(INamespaceRepository repository)
    : IRequestHandler<CreateNamespaceCommand, Result<int>>
{
    public async Task<Result<int>> Handle(CreateNamespaceCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(n => n.FullName == request.FullName, cancellationToken);
        if (exists) return Result<int>.Failure($"Namespace '{request.FullName}' já existe.");
        var item = Domain.Entities.Namespace.Create(request.FullName);
        await repository.AddAsync(item, cancellationToken);
        return Result<int>.Success(item.Id);
    }
}
