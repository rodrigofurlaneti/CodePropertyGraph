using CodePropertyGraph.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class ElementDependencyConfiguration : IEntityTypeConfiguration<ElementDependency>
{
    public void Configure(EntityTypeBuilder<ElementDependency> builder)
    {
        builder.ToTable("ElementDependency");
        builder.HasKey(d => new { d.SourceElementId, d.TargetElementId, d.DependencyType });

        builder.Property(d => d.DependencyType).IsRequired().HasMaxLength(50);
        builder.Property(d => d.IsDirect).IsRequired().HasDefaultValue(true);

        builder.HasOne(d => d.SourceElement)
            .WithMany(e => e.OutboundDependencies)
            .HasForeignKey(d => d.SourceElementId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(d => d.TargetElement)
            .WithMany(e => e.InboundDependencies)
            .HasForeignKey(d => d.TargetElementId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
