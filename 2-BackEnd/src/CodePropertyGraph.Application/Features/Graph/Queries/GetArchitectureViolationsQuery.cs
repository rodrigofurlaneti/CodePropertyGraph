using CodePropertyGraph.Domain.Interfaces;
using MediatR;

namespace CodePropertyGraph.Application.Features.Graph.Queries;

public sealed record GetArchitectureViolationsQuery(
    string SourceLayer = "Domain",
    string TargetLayer = "Infrastructure") : IRequest<IReadOnlyList<ViolationDto>>;

public sealed record ViolationDto(string SourceElementName, string ForbiddenDependencyName);

public sealed class GetArchitectureViolationsQueryHandler(IElementDependencyRepository repository)
    : IRequestHandler<GetArchitectureViolationsQuery, IReadOnlyList<ViolationDto>>
{
    public async Task<IReadOnlyList<ViolationDto>> Handle(GetArchitectureViolationsQuery request, CancellationToken cancellationToken)
    {
        var violations = await repository.GetArchitectureViolationsAsync(request.SourceLayer, request.TargetLayer, cancellationToken);
        return violations.Select(v => new ViolationDto(v.SourceElementName, v.ForbiddenDependencyName)).ToList();
    }
}
