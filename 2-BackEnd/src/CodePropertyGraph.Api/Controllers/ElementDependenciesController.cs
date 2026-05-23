using CodePropertyGraph.Application.Features.ElementDependencies.Commands;
using CodePropertyGraph.Application.Features.ElementDependencies.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

public sealed class ElementDependenciesController(IMediator mediator) : BaseApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetAllElementDependenciesQuery(), cancellationToken));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateElementDependencyCommand command, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(command, cancellationToken));

    [HttpDelete("{sourceId:int}/{targetId:int}/{dependencyType}")]
    public async Task<IActionResult> Delete(int sourceId, int targetId, string dependencyType, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new DeleteElementDependencyCommand(sourceId, targetId, dependencyType), cancellationToken));
}
