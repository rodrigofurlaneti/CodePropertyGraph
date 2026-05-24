using CodePropertyGraph.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class ApiEndpointConfiguration : IEntityTypeConfiguration<ApiEndpoint>
{
    public void Configure(EntityTypeBuilder<ApiEndpoint> builder)
    {
        builder.ToTable("ApiEndpoint");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).UseIdentityColumn();

        builder.Property(e => e.MethodName).IsRequired().HasMaxLength(100);
        builder.Property(e => e.HttpVerb).IsRequired().HasMaxLength(10);
        builder.Property(e => e.Route).IsRequired().HasMaxLength(300);
        builder.Property(e => e.Roles).HasMaxLength(200);

        builder.HasOne(e => e.Controller)
            .WithMany()
            .HasForeignKey(e => e.ControllerId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Input)
            .WithMany()
            .HasForeignKey(e => e.InputId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Output)
            .WithMany()
            .HasForeignKey(e => e.OutputId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
