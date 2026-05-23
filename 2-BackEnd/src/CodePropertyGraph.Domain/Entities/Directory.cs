using CodePropertyGraph.Domain.Common;

namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Representa o caminho físico no disco
/// </summary>
public sealed class Directory : BaseEntity
{
    public string Path { get; private set; } = default!;

    private readonly List<CodeElement> _codeElements = [];
    public IReadOnlyCollection<CodeElement> CodeElements => _codeElements.AsReadOnly();

    private Directory() { }

    public static Directory Create(string path)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(path);
        return new Directory { Path = path };
    }

    public void Update(string path)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(path);
        Path = path;
    }
}
