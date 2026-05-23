using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Directories.Queries;

public sealed record GetDirectoryByIdQuery(int Id) : IRequest<Result<DirectoryDto>>;

public sealed class GetDirectoryByIdQueryHandler(IDirectoryRepository repository)
    : IRequestHandler<GetDirectoryByIdQuery, Result<DirectoryDto>>
{
    public async Task<Result<DirectoryDto>> Handle(GetDirectoryByIdQuery request, CancellationToken cancellationToken)
    {
        var item = await repository.GetByIdAsync(request.Id, cancellationToken);
        return item is null
            ? Result<DirectoryDto>.Failure($"Directory {request.Id} não encontrado.")
            : Result<DirectoryDto>.Success(new DirectoryDto(item.Id, item.Path));
    }
}
