using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using DomainNamespace = CodePropertyGraph.Domain.Entities.Namespace;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class NamespaceConfiguration : IEntityTypeConfiguration<DomainNamespace>
{
    public void Configure(EntityTypeBuilder<DomainNamespace> builder)
    {
        builder.ToTable("Namespace");
        builder.HasKey(n => n.Id);
        builder.Property(n => n.Id).UseIdentityColumn();
        builder.Property(n => n.FullName).IsRequired().HasMaxLength(500);
        builder.HasIndex(n => n.FullName).IsUnique();
    }
}
