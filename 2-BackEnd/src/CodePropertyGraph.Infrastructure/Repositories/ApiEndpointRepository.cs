using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class ApiEndpointRepository(AppDbContext context) : IApiEndpointRepository
{
    private readonly AppDbContext _context = context;

    public async Task<IReadOnlyList<ApiEndpoint>> GetAllAsync(CancellationToken cancellationToken = default)
        => await _context.ApiEndpoints.AsNoTracking()
            .Include(e => e.Controller)
            .Include(e => e.Input)
            .Include(e => e.Output)
            .ToListAsync(cancellationToken);

    public async Task<ApiEndpoint?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        => await _context.ApiEndpoints.AsNoTracking()
            .Include(e => e.Controller)
            .Include(e => e.Input)
            .Include(e => e.Output)
            .FirstOrDefaultAsync(e => e.Id == id, cancellationToken);

    public async Task<ApiEndpoint> AddAsync(ApiEndpoint entity, CancellationToken cancellationToken = default)
    {
        await _context.ApiEndpoints.AddAsync(entity, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
        return entity;
    }

    public async Task DeleteAsync(ApiEndpoint entity, CancellationToken cancellationToken = default)
    {
        _context.ApiEndpoints.Remove(entity);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(int controllerId, string methodName, CancellationToken cancellationToken = default)
        => await _context.ApiEndpoints.AsNoTracking()
            .AnyAsync(e => e.ControllerId == controllerId && e.MethodName == methodName, cancellationToken);
}
