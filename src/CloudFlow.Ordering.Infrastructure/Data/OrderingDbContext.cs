using Microsoft.EntityFrameworkCore;
using CloudFlow.Ordering.Domain.Entities;

namespace CloudFlow.Ordering.Infrastructure.Data;

public class OrderingDbContext : DbContext
{
    public OrderingDbContext(DbContextOptions<OrderingDbContext> options) : base(options)
    {
    }

    public DbSet<Order> Orders { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.CustomerName).IsRequired().HasMaxLength(200);
            entity.Property(e => e.CustomerEmail).IsRequired().HasMaxLength(200);
            entity.Property(e => e.CustomerPhone).IsRequired().HasMaxLength(50);
            entity.Property(e => e.CustomerAddress).IsRequired().HasMaxLength(500);
            entity.Property(e => e.CustomerCity).IsRequired().HasMaxLength(100);
            entity.Property(e => e.CustomerState).IsRequired().HasMaxLength(100);
            entity.Property(e => e.CustomerZip).IsRequired().HasMaxLength(20);
            entity.Property(e => e.CustomerCountry).IsRequired().HasMaxLength(100);
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(18,2)").IsRequired();
            entity.Property(e => e.Status).IsRequired();
            entity.Property(e => e.CreatedAt).IsRequired();
            entity.Property(e => e.UpdatedAt).IsRequired();

            entity.ToTable("Orders");
        });
    }
}

