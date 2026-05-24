using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class HandlerContractRepository(AppDbContext context) : IHandlerContractRepository
{
    private readonly AppDbContext _context = context;

    public async Task<IReadOnlyList<HandlerContract>> GetAllAsync(CancellationToken cancellationToken = default)
        => await _context.HandlerContracts.AsNoTracking()
            .Include(h => h.Handler)
            .Include(h => h.Input)
            .Include(h => h.Output)
            .ToListAsync(cancellationToken);

    public async Task<HandlerContract?> GetByHandlerIdAsync(int handlerId, CancellationToken cancellationToken = default)
        => await _context.HandlerContracts.AsNoTracking()
            .Include(h => h.Handler)
            .Include(h => h.Input)
            .Include(h => h.Output)
            .FirstOrDefaultAsync(h => h.HandlerId == handlerId, cancellationToken);

    public async Task<HandlerContract> AddAsync(HandlerContract entity, CancellationToken cancellationToken = default)
    {
        await _context.HandlerContracts.AddAsync(entity, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
        return entity;
    }

    public async Task DeleteAsync(HandlerContract entity, CancellationToken cancellationToken = default)
    {
        _context.HandlerContracts.Remove(entity);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(int handlerId, CancellationToken cancellationToken = default)
        => await _context.HandlerContracts.AsNoTracking()
            .AnyAsync(h => h.HandlerId == handlerId, cancellationToken);
}
