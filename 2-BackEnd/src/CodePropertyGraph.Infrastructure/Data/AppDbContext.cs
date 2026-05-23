using CodePropertyGraph.Domain.Entities;
using CodePropertyGraph.Infrastructure.Data.Configurations;
using Microsoft.EntityFrameworkCore;
using DomainDirectory = CodePropertyGraph.Domain.Entities.Directory;
using DomainNamespace = CodePropertyGraph.Domain.Entities.Namespace;

namespace CodePropertyGraph.Infrastructure.Data;

public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Layer> Layers => Set<Layer>();
    public DbSet<Project> Projects => Set<Project>();
    public DbSet<DomainNamespace> Namespaces => Set<DomainNamespace>();
    public DbSet<DomainDirectory> Directories => Set<DomainDirectory>();
    public DbSet<CodeElement> CodeElements => Set<CodeElement>();
    public DbSet<ElementImplementation> ElementImplementations => Set<ElementImplementation>();
    public DbSet<ElementDependency> ElementDependencies => Set<ElementDependency>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfiguration(new LayerConfiguration());
        modelBuilder.ApplyConfiguration(new ProjectConfiguration());
        modelBuilder.ApplyConfiguration(new NamespaceConfiguration());
        modelBuilder.ApplyConfiguration(new DirectoryConfiguration());
        modelBuilder.ApplyConfiguration(new CodeElementConfiguration());
        modelBuilder.ApplyConfiguration(new ElementImplementationConfiguration());
        modelBuilder.ApplyConfiguration(new ElementDependencyConfiguration());

        base.OnModelCreating(modelBuilder);
    }
}
