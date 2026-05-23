using CodePropertyGraph.Domain.Common;

namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Representa o escopo lógico (Namespaces)
/// </summary>
public sealed class Namespace : BaseEntity
{
    public string FullName { get; private set; } = default!;

    private readonly List<CodeElement> _codeElements = [];
    public IReadOnlyCollection<CodeElement> CodeElements => _codeElements.AsReadOnly();

    private Namespace() { }

    public static Namespace Create(string fullName)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(fullName);
        return new Namespace { FullName = fullName };
    }

    public void Update(string fullName)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(fullName);
        FullName = fullName;
    }
}
