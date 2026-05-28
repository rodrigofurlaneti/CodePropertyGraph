namespace CodePropertyGraph.Domain.ValueObjects;

/// <summary>
/// Value Object que representa um caminho de namespace C# completo.
///
/// Regras de negocio:
///   - Nao pode ser nulo ou vazio.
///   - Maximo de 500 caracteres.
///   - Deve conter apenas identificadores C# validos separados por ponto.
///     Ex: "OrderManager.Domain.ValueObjects"
///   - Imutavel: para alterar, cria-se um novo NamespacePath.
///
/// Reutilizacao:
///   Qualquer CodeElement referencia um NamespaceId cujo FullName e validado
///   por este Value Object antes de ser persistido.
/// </summary>
public sealed class NamespacePath : IEquatable<NamespacePath>
{
    public const int MaxLength = 500;

    public string Value { get; }

    /// <summary>Segmentos individuais do namespace. Ex: ["OrderManager","Domain","ValueObjects"].</summary>
    public IReadOnlyList<string> Segments { get; }

    /// <summary>Ultimo segmento — geralmente o nome da subdivisao. Ex: "ValueObjects".</summary>
    public string LeafSegment => Segments[^1];

    private NamespacePath(string value, string[] segments)
    {
        Value    = value;
        Segments = segments;
    }

    /// <summary>
    /// Cria um NamespacePath valido.
    /// Lanca <see cref="ArgumentException"/> em caso de violacao das regras.
    /// </summary>
    public static NamespacePath Create(string value)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(value);

        var trimmed = value.Trim();

        if (trimmed.Length > MaxLength)
            throw new ArgumentException(
                $"NamespacePath nao pode exceder {MaxLength} caracteres.",
                nameof(value));

        var segments = trimmed.Split('.');

        foreach (var seg in segments)
        {
            if (string.IsNullOrWhiteSpace(seg))
                throw new ArgumentException(
                    $"NamespacePath invalido: segmento vazio em '{trimmed}'.",
                    nameof(value));
        }

        return new NamespacePath(trimmed, segments);
    }

    /// <summary>
    /// Retorna true se o valor e um NamespacePath valido (sem lancar excecao).
    /// </summary>
    public static bool IsValid(string? value)
    {
        if (string.IsNullOrWhiteSpace(value) || value.Trim().Length > MaxLength)
            return false;

        return value.Trim().Split('.').All(s => !string.IsNullOrWhiteSpace(s));
    }

    /// <summary>
    /// Verifica se este namespace pertence a uma camada DDD especifica.
    /// Ex: new NamespacePath("Order.Domain.Entities").BelongsToLayer("Domain") == true
    /// </summary>
    public bool BelongsToLayer(string layerName) =>
        Segments.Contains(layerName, StringComparer.OrdinalIgnoreCase);

    /// <summary>
    /// Extrai a subdivisao dentro de uma camada DDD.
    /// Ex: "Order.Domain.ValueObjects.Money".GetSubdivision("Domain") == "ValueObjects"
    /// </summary>
    public string? GetSubdivision(string layerName)
    {
        for (var i = 0; i < Segments.Count - 1; i++)
        {
            if (string.Equals(Segments[i], layerName, StringComparison.OrdinalIgnoreCase))
                return Segments[i + 1];
        }
        return null;
    }

    // ── Comparacao por valor ──────────────────────────────────────────────────
    public bool Equals(NamespacePath? other) =>
        other is not null && string.Equals(Value, other.Value, StringComparison.Ordinal);

    public override bool Equals(object? obj) => obj is NamespacePath np && Equals(np);
    public override int GetHashCode() => Value.GetHashCode(StringComparison.Ordinal);
    public override string ToString() => Value;

    public static bool operator ==(NamespacePath? a, NamespacePath? b) =>
        a is null ? b is null : a.Equals(b);
    public static bool operator !=(NamespacePath? a, NamespacePath? b) => !(a == b);

    public static implicit operator string(NamespacePath np) => np.Value;
}
