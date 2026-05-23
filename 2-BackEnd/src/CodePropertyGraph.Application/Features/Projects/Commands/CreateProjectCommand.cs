using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.Projects.Commands;

public sealed record CreateProjectCommand(string Name, string ProjectType) : IRequest<Result<int>>;

public sealed class CreateProjectCommandValidator : AbstractValidator<CreateProjectCommand>
{
    public CreateProjectCommandValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
        RuleFor(x => x.ProjectType).NotEmpty().MaximumLength(50);
    }
}

public sealed class CreateProjectCommandHandler(IProjectRepository repository)
    : IRequestHandler<CreateProjectCommand, Result<int>>
{
    public async Task<Result<int>> Handle(CreateProjectCommand request, CancellationToken cancellationToken)
    {
        var project = Project.Create(request.Name, request.ProjectType);
        await repository.AddAsync(project, cancellationToken);
        return Result<int>.Success(project.Id);
    }
}
