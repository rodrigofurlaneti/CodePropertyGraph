using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Layers.Commands;

public sealed record DeleteLayerCommand(int Id) : IRequest<Result>;

public sealed class DeleteLayerCommandHandler(ILayerRepository repository)
    : IRequestHandler<DeleteLayerCommand, Result>
{
    public async Task<Result> Handle(DeleteLayerCommand request, CancellationToken cancellationToken)
    {
        var layer = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (layer is null)
            return Result.Failure($"Layer com Id {request.Id} não encontrada.");

        await repository.DeleteAsync(layer, cancellationToken);
        return Result.Success();
    }
}
