using CodePropertyGraph.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class CodeElementConfiguration : IEntityTypeConfiguration<CodeElement>
{
    public void Configure(EntityTypeBuilder<CodeElement> builder)
    {
        builder.ToTable("CodeElement");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).UseIdentityColumn();
        builder.Property(e => e.Name).IsRequired().HasMaxLength(200);
        builder.Property(e => e.ElementType).IsRequired().HasMaxLength(50);
        builder.Property(e => e.IsAbstract).IsRequired().HasDefaultValue(false);
        builder.Property(e => e.IsSealed).IsRequired().HasDefaultValue(false);

        builder.HasOne(e => e.Layer)
            .WithMany(l => l.CodeElements)
            .HasForeignKey(e => e.LayerId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Project)
            .WithMany(p => p.CodeElements)
            .HasForeignKey(e => e.ProjectId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Namespace)
            .WithMany(n => n.CodeElements)
            .HasForeignKey(e => e.NamespaceId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Directory)
            .WithMany(d => d.CodeElements)
            .HasForeignKey(e => e.DirectoryId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
