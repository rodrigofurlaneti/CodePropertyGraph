namespace CodePropertyGraph.Domain.Entities;

/// <summary>
/// Contrato de entrada/saída de um Command ou Query Handler.
/// PK = HandlerId (FK para CodeElement — o handler em si).
/// </summary>
public sealed class HandlerContract
{
    public int HandlerId { get; private set; }
    public int InputId { get; private set; }
    public int OutputId { get; private set; }

    // Navigation properties
    public CodeElement Handler { get; private set; } = default!;
    public CodeElement Input { get; private set; } = default!;
    public CodeElement Output { get; private set; } = default!;

    private HandlerContract() { }

    public static HandlerContract Create(int handlerId, int inputId, int outputId)
    {
        if (handlerId <= 0) throw new ArgumentException("HandlerId inválido.", nameof(handlerId));
        if (inputId <= 0)   throw new ArgumentException("InputId inválido.",   nameof(inputId));
        if (outputId <= 0)  throw new ArgumentException("OutputId inválido.",  nameof(outputId));

        return new HandlerContract
        {
            HandlerId = handlerId,
            InputId   = inputId,
            OutputId  = outputId,
        };
    }
}
