using CodePropertyGraph.Domain.Common;

namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Representa qualquer elemento de código (Classe, Interface, Record, Enum)
/// Nó central do Knowledge Graph
/// </summary>
public sealed class CodeElement : BaseEntity
{
    public string Name { get; private set; } = default!;
    /// <summary>Discriminador: 'Class', 'Interface', 'Record', 'Enum'</summary>
    public string ElementType { get; private set; } = default!;
    public bool IsAbstract { get; private set; }
    public bool IsSealed { get; private set; }

    public int LayerId { get; private set; }
    public int ProjectId { get; private set; }
    public int NamespaceId { get; private set; }
    public int DirectoryId { get; private set; }

    // Navigation properties
    public Layer Layer { get; private set; } = default!;
    public Project Project { get; private set; } = default!;
    public Namespace Namespace { get; private set; } = default!;
    public Directory Directory { get; private set; } = default!;

    // Arestas de saída: quais interfaces este elemento implementa
    private readonly List<ElementImplementation> _implementations = [];
    public IReadOnlyCollection<ElementImplementation> Implementations => _implementations.AsReadOnly();

    // Arestas de dependência: quais dependências este elemento possui
    private readonly List<ElementDependency> _outboundDependencies = [];
    public IReadOnlyCollection<ElementDependency> OutboundDependencies => _outboundDependencies.AsReadOnly();

    private readonly List<ElementDependency> _inboundDependencies = [];
    public IReadOnlyCollection<ElementDependency> InboundDependencies => _inboundDependencies.AsReadOnly();

    private CodeElement() { }

    public static CodeElement Create(
        string name,
        string elementType,
        int layerId,
        int projectId,
        int namespaceId,
        int directoryId,
        bool isAbstract = false,
        bool isSealed = false)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        ArgumentException.ThrowIfNullOrWhiteSpace(elementType);

        return new CodeElement
        {
            Name = name,
            ElementType = elementType,
            LayerId = layerId,
            ProjectId = projectId,
            NamespaceId = namespaceId,
            DirectoryId = directoryId,
            IsAbstract = isAbstract,
            IsSealed = isSealed
        };
    }

    public void Update(
        string name,
        string elementType,
        int layerId,
        int projectId,
        int namespaceId,
        int directoryId,
        bool isAbstract,
        bool isSealed)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        ArgumentException.ThrowIfNullOrWhiteSpace(elementType);
        Name = name;
        ElementType = elementType;
        LayerId = layerId;
        ProjectId = projectId;
        NamespaceId = namespaceId;
        DirectoryId = directoryId;
        IsAbstract = isAbstract;
        IsSealed = isSealed;
    }
}
