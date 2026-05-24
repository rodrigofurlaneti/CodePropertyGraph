using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.ApiEndpoints.Commands;

public sealed record DeleteApiEndpointCommand(int Id) : IRequest<Result>;

public sealed class DeleteApiEndpointCommandValidator : AbstractValidator<DeleteApiEndpointCommand>
{
    public DeleteApiEndpointCommandValidator()
    {
        RuleFor(x => x.Id).GreaterThan(0);
    }
}

public sealed class DeleteApiEndpointCommandHandler(IApiEndpointRepository repository)
    : IRequestHandler<DeleteApiEndpointCommand, Result>
{
    public async Task<Result> Handle(DeleteApiEndpointCommand request, CancellationToken cancellationToken)
    {
        var endpoint = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (endpoint is null) return Result.Failure("Endpoint não encontrado.");

        await repository.DeleteAsync(endpoint, cancellationToken);
        return Result.Success();
    }
}
