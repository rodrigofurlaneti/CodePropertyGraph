using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Layers.Queries;

public sealed record GetAllLayersQuery : IRequest<IReadOnlyList<LayerDto>>;

public sealed record LayerDto(int Id, string Name, string? Description);

public sealed class GetAllLayersQueryHandler(ILayerRepository repository)
    : IRequestHandler<GetAllLayersQuery, IReadOnlyList<LayerDto>>
{
    public async Task<IReadOnlyList<LayerDto>> Handle(GetAllLayersQuery request, CancellationToken cancellationToken)
    {
        var layers = await repository.GetAllAsync(cancellationToken);
        return layers.Select(l => new LayerDto(l.Id, l.Name, l.Description)).ToList();
    }
}
