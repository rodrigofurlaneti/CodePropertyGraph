using CodePropertyGraph.Application.Features.CodeElements.Commands;
using CodePropertyGraph.Application.Features.CodeElements.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

public sealed class CodeElementsController(IMediator mediator) : BaseApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetAllCodeElementsQuery(), cancellationToken));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new GetCodeElementByIdQuery(id), cancellationToken));

    [HttpGet("by-layer/{layerId:int}")]
    public async Task<IActionResult> GetByLayer(int layerId, CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetCodeElementsByLayerQuery(layerId), cancellationToken));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateCodeElementCommand command, CancellationToken cancellationToken)
    {
        var result = await mediator.Send(command, cancellationToken);
        return result.IsSuccess ? CreatedAtAction(nameof(GetById), new { id = result.Value }, result.Value) : BadRequest(new { error = result.Error });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateCodeElementCommand command, CancellationToken cancellationToken)
    {
        if (id != command.Id) return BadRequest("Id inconsistente.");
        return HandleResult(await mediator.Send(command, cancellationToken));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new DeleteCodeElementCommand(id), cancellationToken));
}
