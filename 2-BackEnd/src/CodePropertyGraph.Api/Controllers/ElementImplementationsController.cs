using CodePropertyGraph.Application.Features.ElementImplementations.Commands;
using CodePropertyGraph.Application.Features.ElementImplementations.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

public sealed class ElementImplementationsController(IMediator mediator) : BaseApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetAllElementImplementationsQuery(), cancellationToken));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateElementImplementationCommand command, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(command, cancellationToken));

    [HttpDelete("{classId:int}/{interfaceId:int}")]
    public async Task<IActionResult> Delete(int classId, int interfaceId, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new DeleteElementImplementationCommand(classId, interfaceId), cancellationToken));
}
