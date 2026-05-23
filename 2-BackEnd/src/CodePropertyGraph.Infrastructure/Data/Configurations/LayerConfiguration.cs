using CodePropertyGraph.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class LayerConfiguration : IEntityTypeConfiguration<Layer>
{
    public void Configure(EntityTypeBuilder<Layer> builder)
    {
        builder.ToTable("Layer");
        builder.HasKey(l => l.Id);
        builder.Property(l => l.Id).UseIdentityColumn();
        builder.Property(l => l.Name).IsRequired().HasMaxLength(100);
        builder.HasIndex(l => l.Name).IsUnique();
        builder.Property(l => l.Description).HasMaxLength(255);
    }
}
