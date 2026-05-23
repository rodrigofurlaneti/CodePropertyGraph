using CodePropertyGraph.Application.Common;
using Microsoft.AspNetCore.Mvc;

namespace CodePropertyGraph.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public abstract class BaseApiController : ControllerBase
{
    protected IActionResult HandleResult<T>(Result<T> result)
        => result.IsSuccess ? Ok(result.Value) : NotFound(new { error = result.Error });

    protected IActionResult HandleResult(Result result)
        => result.IsSuccess ? NoContent() : NotFound(new { error = result.Error });
}
