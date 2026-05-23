using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Commands;

public sealed record UpdateCodeElementCommand(
    int Id, string Name, string ElementType,
    int LayerId, int ProjectId, int NamespaceId, int DirectoryId,
    bool IsAbstract, bool IsSealed) : IRequest<Result>;

public sealed class UpdateCodeElementCommandHandler(ICodeElementRepository repository)
    : IRequestHandler<UpdateCodeElementCommand, Result>
{
    public async Task<Result> Handle(UpdateCodeElementCommand request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        if (item is null) return Result.Failure($"CodeElement {request.Id} não encontrado.");
        item.Update(request.Name, request.ElementType,
            request.LayerId, request.ProjectId, request.NamespaceId, request.DirectoryId,
            request.IsAbstract, request.IsSealed);
        await repository.UpdateAsync(item, cancellationToken);
        return Result.Success();
    }
}
