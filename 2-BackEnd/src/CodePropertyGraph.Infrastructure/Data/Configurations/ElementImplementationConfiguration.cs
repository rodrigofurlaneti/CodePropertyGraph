using CodePropertyGraph.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class ElementImplementationConfiguration : IEntityTypeConfiguration<ElementImplementation>
{
    public void Configure(EntityTypeBuilder<ElementImplementation> builder)
    {
        builder.ToTable("ElementImplementation");
        builder.HasKey(i => new { i.ClassId, i.InterfaceId });

        builder.HasOne(i => i.Class)
            .WithMany(e => e.Implementations)
            .HasForeignKey(i => i.ClassId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(i => i.Interface)
            .WithMany()
            .HasForeignKey(i => i.InterfaceId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
