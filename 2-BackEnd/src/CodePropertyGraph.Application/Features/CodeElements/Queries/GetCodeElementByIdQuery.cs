using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.CodeElements.Queries;

public sealed record GetCodeElementByIdQuery(int Id) : IRequest<Result<CodeElementDto>>;

public sealed class GetCodeElementByIdQueryHandler(ICodeElementRepository repository)
    : IRequestHandler<GetCodeElementByIdQuery, Result<CodeElementDto>>
{
    public async Task<Result<CodeElementDto>> Handle(GetCodeElementByIdQuery request, CancellationToken cancellationToken)
    {
        var item = await repository.GetWithRelationsAsync(request.Id, cancellationToken);
        if (item is null) return Result<CodeElementDto>.Failure($"CodeElement {request.Id} não encontrado.");

        return Result<CodeElementDto>.Success(new CodeElementDto(
            item.Id, item.Name, item.ElementType, item.IsAbstract, item.IsSealed,
            item.LayerId, item.Layer?.Name ?? string.Empty,
            item.ProjectId, item.Project?.Name ?? string.Empty,
            item.NamespaceId, item.Namespace?.FullName ?? string.Empty,
            item.DirectoryId, item.Directory?.Path ?? string.Empty));
    }
}
