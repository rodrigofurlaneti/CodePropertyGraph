using CodePropertyGraph.Application.Features.HandlerContracts.Commands;
using CodePropertyGraph.Application.Features.HandlerContracts.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

public sealed class HandlerContractsController(IMediator mediator) : BaseApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetAllHandlerContractsQuery(), cancellationToken));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateHandlerContractCommand command, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(command, cancellationToken));

    [HttpDelete("{handlerId:int}")]
    public async Task<IActionResult> Delete(int handlerId, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new DeleteHandlerContractCommand(handlerId), cancellationToken));
}
