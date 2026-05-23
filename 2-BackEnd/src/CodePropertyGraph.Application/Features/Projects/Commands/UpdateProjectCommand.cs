using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.Projects.Commands;

public sealed record UpdateProjectCommand(int Id, string Name, string ProjectType) : IRequest<Result>;

public sealed class UpdateProjectCommandValidator : AbstractValidator<UpdateProjectCommand>
{
    public UpdateProjectCommandValidator()
    {
        RuleFor(x => x.Id).GreaterThan(0);
        RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
        RuleFor(x => x.ProjectType).NotEmpty().MaximumLength(50);
    }
}

public sealed class UpdateProjectCommandHandler(IProjectRepository repository)
    : IRequestHandler<UpdateProjectCommand, Result>
{
    public async Task<Result> Handle(UpdateProjectCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"Project {request.Id} não encontrado.");
        item.Update(request.Name, request.ProjectType);
        await repository.UpdateAsync(item, cancellationToken);
        return Result.Success();
    }
}
