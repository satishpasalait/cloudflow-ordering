namespace CloudFlow.Ordering.Domain.Entities;

public class Order
{
    public int Id { get; set; }
    public string CustomerName { get; set; }
    public string CustomerEmail { get; set; }
    public string CustomerPhone { get; set; }
    public string CustomerAddress { get; set; }
    public string CustomerCity { get; set; }
    public string CustomerState { get; set; }
    public string CustomerZip { get; set; }
    public string CustomerCountry { get; set; }
    public decimal TotalAmount { get; set; } = 0;
    public OrderStatus Status { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}