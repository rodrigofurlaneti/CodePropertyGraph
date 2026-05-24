using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using FluentValidation;
using MediatR;

namespace CodePropertyGraph.Application.Features.ApiEndpoints.Commands;

public sealed record CreateApiEndpointCommand(
    int ControllerId,
    string MethodName,
    string HttpVerb,
    string Route,
    int? InputId,
    int? OutputId,
    string? Roles) : IRequest<Result<int>>;

public sealed class CreateApiEndpointCommandValidator : AbstractValidator<CreateApiEndpointCommand>
{
    public CreateApiEndpointCommandValidator()
    {
        RuleFor(x => x.ControllerId).GreaterThan(0);
        RuleFor(x => x.MethodName).NotEmpty().MaximumLength(100);
        RuleFor(x => x.HttpVerb).NotEmpty().MaximumLength(10);
        RuleFor(x => x.Route).NotEmpty().MaximumLength(300);
    }
}

public sealed class CreateApiEndpointCommandHandler(IApiEndpointRepository repository)
    : IRequestHandler<CreateApiEndpointCommand, Result<int>>
{
    public async Task<Result<int>> Handle(CreateApiEndpointCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(request.ControllerId, request.MethodName, cancellationToken);
        if (exists) return Result<int>.Failure("Este endpoint já está registrado para o controller informado.");

        var endpoint = ApiEndpoint.Create(
            request.ControllerId, request.MethodName, request.HttpVerb,
            request.Route, request.InputId, request.OutputId, request.Roles);

        await repository.AddAsync(endpoint, cancellationToken);
        return Result<int>.Success(endpoint.Id);
    }
}
