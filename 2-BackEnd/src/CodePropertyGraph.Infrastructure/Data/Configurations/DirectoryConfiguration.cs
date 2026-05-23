using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using DomainDirectory = CodePropertyGraph.Domain.Entities.Directory;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class DirectoryConfiguration : IEntityTypeConfiguration<DomainDirectory>
{
    public void Configure(EntityTypeBuilder<DomainDirectory> builder)
    {
        builder.ToTable("Directory");
        builder.HasKey(d => d.Id);
        builder.Property(d => d.Id).UseIdentityColumn();
        builder.Property(d => d.Path).IsRequired().HasMaxLength(1000);
        builder.HasIndex(d => d.Path).IsUnique();
    }
}
