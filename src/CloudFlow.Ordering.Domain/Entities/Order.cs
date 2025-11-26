namespace CloudFlow.Ordering.Domain.Entities;

public class Order
{
    public int Id { get; set; }
    public required string CustomerName { get; set; }
    public required string CustomerEmail { get; set; }
    public required string CustomerPhone { get; set; }
    public required string CustomerAddress { get; set; }
    public required string CustomerCity { get; set; }
    public required string CustomerState { get; set; }
    public required string CustomerZip { get; set; }
    public required string CustomerCountry { get; set; }
    public decimal TotalAmount { get; set; } = 0;
    public OrderStatus Status { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}