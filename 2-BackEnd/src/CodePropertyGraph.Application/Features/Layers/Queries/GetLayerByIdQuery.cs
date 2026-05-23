using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Layers.Queries;

public sealed record GetLayerByIdQuery(int Id) : IRequest<Result<LayerDto>>;

public sealed class GetLayerByIdQueryHandler(ILayerRepository repository)
    : IRequestHandler<GetLayerByIdQuery, Result<LayerDto>>
{
    public async Task<Result<LayerDto>> Handle(GetLayerByIdQuery request, CancellationToken cancellationToken)
    {
        var layer = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (layer is null)
            return Result<LayerDto>.Failure($"Layer com Id {request.Id} não encontrada.");

        return Result<LayerDto>.Success(new LayerDto(layer.Id, layer.Name, layer.Description));
    }
}
