using CodePropertyGraph.Application.Features.ApiEndpoints.Commands;
using CodePropertyGraph.Application.Features.ApiEndpoints.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

public sealed class ApiEndpointsController(IMediator mediator) : BaseApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetAllApiEndpointsQuery(), cancellationToken));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateApiEndpointCommand command, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(command, cancellationToken));

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new DeleteApiEndpointCommand(id), cancellationToken));
}
