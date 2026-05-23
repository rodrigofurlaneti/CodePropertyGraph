using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CodePropertyGraph.Infrastructure.Repositories;

public sealed class ElementImplementationRepository(AppDbContext context) : IElementImplementationRepository
{
    private readonly AppDbContext _context = context;

    public async Task<IReadOnlyList<ElementImplementation>> GetAllAsync(CancellationToken cancellationToken = default)
        => await _context.ElementImplementations.AsNoTracking()
            .Include(i => i.Class).Include(i => i.Interface)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<ElementImplementation>> GetByClassIdAsync(int classId, CancellationToken cancellationToken = default)
        => await _context.ElementImplementations.AsNoTracking()
            .Include(i => i.Class).Include(i => i.Interface)
            .Where(i => i.ClassId == classId).ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<ElementImplementation>> GetByInterfaceIdAsync(int interfaceId, CancellationToken cancellationToken = default)
        => await _context.ElementImplementations.AsNoTracking()
            .Where(i => i.InterfaceId == interfaceId).ToListAsync(cancellationToken);

    public async Task<ElementImplementation?> GetByIdsAsync(int classId, int interfaceId, CancellationToken cancellationToken = default)
        => await _context.ElementImplementations.AsNoTracking()
            .FirstOrDefaultAsync(i => i.ClassId == classId && i.InterfaceId == interfaceId, cancellationToken);

    public async Task<ElementImplementation> AddAsync(ElementImplementation entity, CancellationToken cancellationToken = default)
    {
        await _context.ElementImplementations.AddAsync(entity, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
        return entity;
    }

    public async Task DeleteAsync(ElementImplementation entity, CancellationToken cancellationToken = default)
    {
        _context.ElementImplementations.Remove(entity);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(int classId, int interfaceId, CancellationToken cancellationToken = default)
        => await _context.ElementImplementations.AsNoTracking()
            .AnyAsync(i => i.ClassId == classId && i.InterfaceId == interfaceId, cancellationToken);
}
