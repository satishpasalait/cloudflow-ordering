using CloudFlow.Ordering.Domain.Entities;

namespace CloudFlow.Ordering.Domain.Repositories;

public interface IOrderRepository
{
    Task<Order> GetOrderById(int id);
    Task<IEnumerable<Order>> GetOrders();
    Task<Order> CreateOrder(Order order);
    Task<Order> UpdateOrder(Order order);
    Task<Order> DeleteOrder(int id);
}