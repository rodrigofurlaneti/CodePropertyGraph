namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Aresta DEPENDS_ON: O coração do acoplamento entre elementos de código.
/// Chave composta: SourceElementId + TargetElementId + DependencyType
/// </summary>
public sealed class ElementDependency
{
    /// <summary>Quem está dependendo (Ex: UserQueryHandler)</summary>
    public int SourceElementId { get; private set; }
    /// <summary>De quem depende (Ex: IUserRepository)</summary>
    public int TargetElementId { get; private set; }
    /// <summary>Ex: 'ConstructorInjection', 'MethodParameter', 'Inheritance'</summary>
    public string DependencyType { get; private set; } = default!;
    /// <summary>Se false, indica uma dependência transitiva descoberta por IA</summary>
    public bool IsDirect { get; private set; }

    public CodeElement SourceElement { get; private set; } = default!;
    public CodeElement TargetElement { get; private set; } = default!;

    private ElementDependency() { }

    public static ElementDependency Create(
        int sourceElementId,
        int targetElementId,
        string dependencyType,
        bool isDirect = true)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(dependencyType);
        if (sourceElementId <= 0) throw new ArgumentException("SourceElementId inválido", nameof(sourceElementId));
        if (targetElementId <= 0) throw new ArgumentException("TargetElementId inválido", nameof(targetElementId));

        return new ElementDependency
        {
            SourceElementId = sourceElementId,
            TargetElementId = targetElementId,
            DependencyType = dependencyType,
            IsDirect = isDirect
        };
    }
}
