namespace CodePropertyGraph.Domain.ValueObjects;

/// <summary>
/// Value Object que representa o tipo de um elemento de codigo C#.
///
/// Regras de negocio encapsuladas:
///   - Deve ser um dos valores reconhecidos pelo CPG.
///   - Imutavel: nao possui metodo Update. Para mudar o tipo, cria-se um novo ElementType.
///   - Comparacao por valor (nao por identidade).
/// </summary>
public sealed class ElementType : IEquatable<ElementType>
{
    // ── Tipos reconhecidos ────────────────────────────────────────────────────
    public static readonly ElementType Class         = new("Class");
    public static readonly ElementType Interface     = new("Interface");
    public static readonly ElementType Record        = new("Record");
    public static readonly ElementType Enum          = new("Enum");
    public static readonly ElementType AbstractClass = new("AbstractClass");
    public static readonly ElementType Struct        = new("Struct");

    private static readonly HashSet<string> ValidValues =
    [
        "Class", "Interface", "Record", "Enum", "AbstractClass", "Struct"
    ];

    // ── Estado ────────────────────────────────────────────────────────────────
    public string Value { get; }

    // ── Factory — unica forma de criar (regra de insert) ─────────────────────
    private ElementType(string value) => Value = value;

    /// <summary>
    /// Cria um ElementType valido.
    /// Lanca <see cref="ArgumentException"/> se o valor nao for reconhecido.
    /// </summary>
    public static ElementType Create(string value)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(value);

        var normalized = char.ToUpperInvariant(value[0]) + value[1..];

        if (!ValidValues.Contains(normalized))
            throw new ArgumentException(
                $"ElementType invalido: '{value}'. " +
                $"Valores aceitos: {string.Join(", ", ValidValues)}.",
                nameof(value));

        return new ElementType(normalized);
    }

    /// <summary>
    /// Retorna true se o valor fornecido e um ElementType valido.
    /// Util para validators de Application sem lancar excecao.
    /// </summary>
    public static bool IsValid(string? value) =>
        !string.IsNullOrWhiteSpace(value) &&
        ValidValues.Contains(char.ToUpperInvariant(value[0]) + value[1..]);

    /// <summary>
    /// Lista todos os valores validos (usado em validadores e documentacao).
    /// </summary>
    public static IReadOnlySet<string> AllValues => ValidValues;

    // ── Comparacao por valor (Value Object pattern) ───────────────────────────
    public bool Equals(ElementType? other) => other is not null && Value == other.Value;
    public override bool Equals(object? obj) => obj is ElementType et && Equals(et);
    public override int GetHashCode() => Value.GetHashCode(StringComparison.Ordinal);
    public override string ToString() => Value;

    public static bool operator ==(ElementType? a, ElementType? b) =>
        a is null ? b is null : a.Equals(b);
    public static bool operator !=(ElementType? a, ElementType? b) => !(a == b);

    // Conversao implicita para string — facilita uso com EF Core / validators
    public static implicit operator string(ElementType et) => et.Value;
}
