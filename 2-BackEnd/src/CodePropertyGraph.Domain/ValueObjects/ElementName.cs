namespace CodePropertyGraph.Domain.ValueObjects;

/// <summary>
/// Value Object que representa o nome de um elemento de codigo.
///
/// Regras de negocio:
///   - Nao pode ser nulo ou vazio.
///   - Maximo de 200 caracteres (limite do banco de dados).
///   - Sem espacos em branco no inicio ou fim.
///   - Imutavel: substitua o objeto em vez de modificar.
/// </summary>
public sealed class ElementName : IEquatable<ElementName>
{
    public const int MaxLength = 200;

    public string Value { get; }

    private ElementName(string value) => Value = value;

    /// <summary>
    /// Cria um ElementName valido.
    /// Lanca <see cref="ArgumentException"/> em caso de violacao das regras.
    /// </summary>
    public static ElementName Create(string value)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(value);

        var trimmed = value.Trim();

        if (trimmed.Length > MaxLength)
            throw new ArgumentException(
                $"ElementName nao pode exceder {MaxLength} caracteres. Recebido: {trimmed.Length}.",
                nameof(value));

        return new ElementName(trimmed);
    }

    /// <summary>
    /// Retorna true se o valor e um ElementName valido (sem lancar excecao).
    /// </summary>
    public static bool IsValid(string? value) =>
        !string.IsNullOrWhiteSpace(value) && value.Trim().Length <= MaxLength;

    // ── Comparacao por valor ──────────────────────────────────────────────────
    public bool Equals(ElementName? other) =>
        other is not null && string.Equals(Value, other.Value, StringComparison.Ordinal);

    public override bool Equals(object? obj) => obj is ElementName en && Equals(en);
    public override int GetHashCode() => Value.GetHashCode(StringComparison.Ordinal);
    public override string ToString() => Value;

    public static bool operator ==(ElementName? a, ElementName? b) =>
        a is null ? b is null : a.Equals(b);
    public static bool operator !=(ElementName? a, ElementName? b) => !(a == b);

    public static implicit operator string(ElementName en) => en.Value;
}
