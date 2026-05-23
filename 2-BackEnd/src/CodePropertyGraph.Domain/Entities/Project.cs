using CodePropertyGraph.Domain.Common;

namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Representa os projetos físicos (.csproj)
/// </summary>
public sealed class Project : BaseEntity
{
    public string Name { get; private set; } = default!;
    /// <summary>Ex: 'WebApi', 'ClassLibrary', 'Test'</summary>
    public string ProjectType { get; private set; } = default!;

    private readonly List<CodeElement> _codeElements = [];
    public IReadOnlyCollection<CodeElement> CodeElements => _codeElements.AsReadOnly();

    private Project() { }

    public static Project Create(string name, string projectType)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        ArgumentException.ThrowIfNullOrWhiteSpace(projectType);
        return new Project { Name = name, ProjectType = projectType };
    }

    public void Update(string name, string projectType)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        ArgumentException.ThrowIfNullOrWhiteSpace(projectType);
        Name = name;
        ProjectType = projectType;
    }
}
