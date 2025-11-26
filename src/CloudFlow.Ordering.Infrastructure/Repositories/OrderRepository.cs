using Microsoft.EntityFrameworkCore;
using CloudFlow.Ordering.Domain.Entities;
using CloudFlow.Ordering.Domain.Repositories;
using CloudFlow.Ordering.Infrastructure.Data;

namespace CloudFlow.Ordering.Infrastructure.Repositories;

public class OrderRepository : IOrderRepository
{
    private readonly OrderingDbContext _context;

    public OrderRepository(OrderingDbContext context)
    {
        _context = context;
    }

    public async Task<Order?> GetOrderById(int id)
    {
        return await _context.Orders.FindAsync(id);
    }

    public async Task<IEnumerable<Order>> GetOrders()
    {
        return await _context.Orders.ToListAsync();
    }

    public async Task<Order> CreateOrder(Order order)
    {
        _context.Orders.Add(order);
        await _context.SaveChangesAsync();
        return order;
    }

    public async Task<Order> UpdateOrder(Order order)
    {
        _context.Orders.Update(order);
        await _context.SaveChangesAsync();
        return order;
    }

    public async Task<Order> DeleteOrder(int id)
    {
        var order = await GetOrderById(id);
        if (order == null)
        {
            throw new KeyNotFoundException($"Order with id {id} not found");
        }
        _context.Orders.Remove(order);
        await _context.SaveChangesAsync();
        return order;
    }
}

