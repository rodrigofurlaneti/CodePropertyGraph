namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Mapeia cada método HTTP de um Controller ao seu DTO de entrada (Input) e saída (Output).
/// </summary>
public sealed class ApiEndpoint
{
    public int Id { get; private set; }
    public int ControllerId { get; private set; }
    public string MethodName { get; private set; } = default!;
    public string HttpVerb { get; private set; } = default!;
    public string Route { get; private set; } = default!;
    public int? InputId { get; private set; }
    public int? OutputId { get; private set; }
    public string? Roles { get; private set; }

    // Navigation properties
    public CodeElement Controller { get; private set; } = default!;
    public CodeElement? Input { get; private set; }
    public CodeElement? Output { get; private set; }

    private ApiEndpoint() { }

    public static ApiEndpoint Create(
        int controllerId,
        string methodName,
        string httpVerb,
        string route,
        int? inputId,
        int? outputId,
        string? roles)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(methodName);
        ArgumentException.ThrowIfNullOrWhiteSpace(httpVerb);
        ArgumentException.ThrowIfNullOrWhiteSpace(route);
        if (controllerId <= 0) throw new ArgumentException("ControllerId inválido.", nameof(controllerId));

        return new ApiEndpoint
        {
            ControllerId = controllerId,
            MethodName = methodName,
            HttpVerb = httpVerb.ToUpperInvariant(),
            Route = route,
            InputId = inputId,
            OutputId = outputId,
            Roles = roles,
        };
    }
}
