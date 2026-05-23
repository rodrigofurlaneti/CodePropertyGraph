using CodePropertyGraph.Domain.Common;

namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Representa as camadas da Clean Architecture (Domain, Application, Infrastructure, etc.)
/// </summary>
public sealed class Layer : BaseEntity
{
    public string Name { get; private set; } = default!;
    public string? Description { get; private set; }

    private readonly List<CodeElement> _codeElements = [];
    public IReadOnlyCollection<CodeElement> CodeElements => _codeElements.AsReadOnly();

    private Layer() { }

    public static Layer Create(string name, string? description = null)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        return new Layer { Name = name, Description = description };
    }

    public void Update(string name, string? description)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        Name = name;
        Description = description;
    }
}
