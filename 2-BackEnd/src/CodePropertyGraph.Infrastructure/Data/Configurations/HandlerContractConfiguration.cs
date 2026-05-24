using CodePropertyGraph.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace CodePropertyGraph.Infrastructure.Data.Configurations;

public sealed class HandlerContractConfiguration : IEntityTypeConfiguration<HandlerContract>
{
    public void Configure(EntityTypeBuilder<HandlerContract> builder)
    {
        builder.ToTable("HandlerContract");
        builder.HasKey(h => h.HandlerId);

        // HandlerId is not an identity — it's a FK to an existing CodeElement
        builder.Property(h => h.HandlerId).ValueGeneratedNever();

        builder.HasOne(h => h.Handler)
            .WithMany()
            .HasForeignKey(h => h.HandlerId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(h => h.Input)
            .WithMany()
            .HasForeignKey(h => h.InputId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(h => h.Output)
            .WithMany()
            .HasForeignKey(h => h.OutputId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
