using CodePropertyGraph.Application.Features.Namespaces.Commands;
using CodePropertyGraph.Application.Features.Namespaces.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

public sealed class NamespacesController(IMediator mediator) : BaseApiController
{
    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
        => Ok(await mediator.Send(new GetAllNamespacesQuery(), cancellationToken));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new GetNamespaceByIdQuery(id), cancellationToken));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateNamespaceCommand command, CancellationToken cancellationToken)
    {
        var result = await mediator.Send(command, cancellationToken);
        return result.IsSuccess ? CreatedAtAction(nameof(GetById), new { id = result.Value }, result.Value) : BadRequest(new { error = result.Error });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateNamespaceCommand command, CancellationToken cancellationToken)
    {
        if (id != command.Id) return BadRequest("Id inconsistente.");
        return HandleResult(await mediator.Send(command, cancellationToken));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
        => HandleResult(await mediator.Send(new DeleteNamespaceCommand(id), cancellationToken));
}
