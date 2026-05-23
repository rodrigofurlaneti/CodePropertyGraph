using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.ElementDependencies.Commands;

public sealed record DeleteElementDependencyCommand(int SourceElementId, int TargetElementId, string DependencyType) : IRequest<Result>;

public sealed class DeleteElementDependencyCommandHandler(IElementDependencyRepository repository)
    : IRequestHandler<DeleteElementDependencyCommand, Result>
{
    public async Task<Result> Handle(DeleteElementDependencyCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByCompositeKeyAsync(request.SourceElementId, request.TargetElementId, request.DependencyType, cancellationToken);
        if (item is null) return Result.Failure("Dependência não encontrada.");
        await repository.DeleteAsync(item, cancellationToken);
        return Result.Success();
    }
}
