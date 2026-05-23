using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.ElementImplementations.Commands;

public sealed record CreateElementImplementationCommand(int ClassId, int InterfaceId) : IRequest<Result>;

public sealed class CreateElementImplementationCommandHandler(IElementImplementationRepository repository)
    : IRequestHandler<CreateElementImplementationCommand, Result>
{
    public async Task<Result> Handle(CreateElementImplementationCommand request, CancellationToken cancellationToken)
    {
        var exists = await repository.ExistsAsync(request.ClassId, request.InterfaceId, cancellationToken);
        if (exists) return Result.Failure("Esta implementação já existe.");
        var item = ElementImplementation.Create(request.ClassId, request.InterfaceId);
        await repository.AddAsync(item, cancellationToken);
        return Result.Success();
    }
}
