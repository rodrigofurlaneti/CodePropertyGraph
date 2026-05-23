using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Directories.Queries;

public sealed record GetAllDirectoriesQuery : IRequest<IReadOnlyList<DirectoryDto>>;
public sealed record DirectoryDto(int Id, string Path);

public sealed class GetAllDirectoriesQueryHandler(IDirectoryRepository repository)
    : IRequestHandler<GetAllDirectoriesQuery, IReadOnlyList<DirectoryDto>>
{
    public async Task<IReadOnlyList<DirectoryDto>> Handle(GetAllDirectoriesQuery request, CancellationToken cancellationToken)
    {
        var items = await repository.GetAllAsync(cancellationToken);
        return items.Select(d => new DirectoryDto(d.Id, d.Path)).ToList();
    }
}
