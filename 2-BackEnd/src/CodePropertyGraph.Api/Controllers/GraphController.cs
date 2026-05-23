using CodePropertyGraph.Application.Features.Graph.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

/// <summary>
/// Endpoint principal do Knowledge Graph — alimenta o frontend de visualização
/// </summary>
public sealed class GraphController(IMediator mediator) : BaseApiController
{
    /// <summary>
    /// Retorna todos os nós e arestas para renderização do grafo.
    /// Filtrável por projectId ou layerId.
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetGraphData(
        [FromQuery] int? projectId,
        [FromQuery] int? layerId,
        CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetGraphDataQuery(projectId, layerId), cancellationToken));

    /// <summary>
    /// Detecta violações de Clean Architecture entre camadas.
    /// </summary>
    [HttpGet("violations")]
    public async Task<IActionResult> GetViolations(
        [FromQuery] string sourceLayer = "Domain",
        [FromQuery] string targetLayer = "Infrastructure",
        CancellationToken cancellationToken = default)
        => Ok(await mediator.Send(new GetArchitectureViolationsQuery(sourceLayer, targetLayer), cancellationToken));
}
