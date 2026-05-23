using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;
using DomainDirectory = CodePropertyGraph.Domain.Entities.Directory;

namespace CodePropertyGraph.Application.Features.Directories.Commands;

public sealed record CreateDirectoryCommand(string Path) : IRequest<Result<int>>;

public sealed class CreateDirectoryCommandValidator : AbstractValidator<CreateDirectoryCommand>
{
    public CreateDirectoryCommandValidator() => RuleFor(x => x.Path).NotEmpty().MaximumLength(1000);
}

public sealed class CreateDirectoryCommandHandler(IDirectoryRepository repository)
    : IRequestHandler<CreateDirectoryCommand, Result<int>>
{
    public async Task<Result<int>> Handle(CreateDirectoryCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(d => d.Path == request.Path, cancellationToken);
        if (exists) return Result<int>.Failure($"Directory '{request.Path}' já existe.");
        var item = DomainDirectory.Create(request.Path);
        await repository.AddAsync(item, cancellationToken);
        return Result<int>.Success(item.Id);
    }
}
