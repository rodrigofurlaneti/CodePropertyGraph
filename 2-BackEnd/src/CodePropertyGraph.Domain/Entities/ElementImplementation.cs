namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Aresta IMPLEMENTS: Ex: UserService implementa IUserService
/// Chave composta: ClassId + InterfaceId
/// </summary>
public sealed class ElementImplementation
{
    public int ClassId { get; private set; }
    public int InterfaceId { get; private set; }

    public CodeElement Class { get; private set; } = default!;
    public CodeElement Interface { get; private set; } = default!;

    private ElementImplementation() { }

    public static ElementImplementation Create(int classId, int interfaceId)
    {
        if (classId <= 0) throw new ArgumentException("ClassId inválido", nameof(classId));
        if (interfaceId <= 0) throw new ArgumentException("InterfaceId inválido", nameof(interfaceId));
        if (classId == interfaceId) throw new ArgumentException("Um elemento não pode implementar a si mesmo.");

        return new ElementImplementation { ClassId = classId, InterfaceId = interfaceId };
    }
}
