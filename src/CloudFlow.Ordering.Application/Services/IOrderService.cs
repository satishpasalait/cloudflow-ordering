using CloudFlow.Ordering.Application.DTOs;

namespace CloudFlow.Ordering.Application.Services;

public interface IOrderService
{
    Task<OrderResponse> CreateOrder(OrderCreateRequest request);
    Task<OrderResponse> GetOrderById(int id);
    Task<IEnumerable<OrderResponse>> GetOrders();
    Task<OrderResponse> UpdateOrder(int id, OrderUpdateRequest request);
    Task<OrderResponse> DeleteOrder(int id);
}