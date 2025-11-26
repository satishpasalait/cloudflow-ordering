using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using Microsoft.Extensions.Logging;
using CloudFlow.Ordering.Domain.Entities;
using CloudFlow.Ordering.Domain.Repositories;
using CloudFlow.Ordering.Application.DTOs;


namespace CloudFlow.Ordering.Application.Services;

public class OrderService : IOrderService
{

    private readonly IOrderRepository _orderRepository;
    private readonly ILogger<OrderService> _logger;

    public OrderService(IOrderRepository orderRepository, ILogger<OrderService> logger)
    {
        _orderRepository = orderRepository;
        _logger = logger;
    }

    public async Task<OrderResponse> CreateOrder(OrderCreateRequest request)
    {
        _logger.LogInformation("Creating order for customer {CustomerName}", request.CustomerName);
        var order = new Order
        {
            CustomerName = request.CustomerName,
            CustomerEmail = request.CustomerEmail,
            CustomerPhone = request.CustomerPhone,
            CustomerAddress = request.CustomerAddress,
            CustomerCity = request.CustomerCity,
            CustomerState = request.CustomerState,
            CustomerZip = request.CustomerZip,
            CustomerCountry = request.CustomerCountry,
            TotalAmount = request.TotalAmount,
            Status = OrderStatus.Pending,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };
        var createdOrder = await _orderRepository.CreateOrder(order);
        return new OrderResponse(
            createdOrder.Id,
            createdOrder.CustomerName,
            createdOrder.CustomerEmail,
            createdOrder.CustomerPhone,
            createdOrder.CustomerAddress,
            createdOrder.CustomerCity,
            createdOrder.CustomerState,
            createdOrder.CustomerZip,
            createdOrder.CustomerCountry,
            createdOrder.TotalAmount,
            createdOrder.Status,
            createdOrder.CreatedAt,
            createdOrder.UpdatedAt);
    }
    public async Task<OrderResponse> GetOrderById(int id)
    {
        _logger.LogInformation("Getting order by id {Id}", id);

        var order = await _orderRepository.GetOrderById(id);
        if (order == null)
        {
            _logger.LogError("Order not found with id {Id}", id);
            throw new Exception($"Order not found with id {id}");
        }
        return new OrderResponse(
            order.Id,
            order.CustomerName,
            order.CustomerEmail,
            order.CustomerPhone,
            order.CustomerAddress,
            order.CustomerCity,
            order.CustomerState,
            order.CustomerZip,
            order.CustomerCountry,
            order.TotalAmount,
            order.Status,
            order.CreatedAt,
            order.UpdatedAt);
    }
    public async Task<IEnumerable<OrderResponse>> GetOrders()
    {
        _logger.LogInformation("Getting all orders");
        var orders = await _orderRepository.GetOrders();
        return orders.Select(o => new OrderResponse(
            o.Id,
            o.CustomerName,
            o.CustomerEmail,
            o.CustomerPhone,
            o.CustomerAddress,
            o.CustomerCity,
            o.CustomerState,
            o.CustomerZip,
            o.CustomerCountry,
            o.TotalAmount,
            o.Status,
            o.CreatedAt,
            o.UpdatedAt));
    }
    public async Task<OrderResponse> UpdateOrder(int id, OrderUpdateRequest request)
    {
        _logger.LogInformation("Updating order by id {Id}", id);
        var order = await _orderRepository.GetOrderById(id);
        if (order == null)
        {
            _logger.LogError("Order not found with id {Id}", id);
            throw new Exception($"Order not found with id {id}");
        }
        order.CustomerName = request.CustomerName ?? order.CustomerName;
        order.CustomerEmail = request.CustomerEmail ?? order.CustomerEmail;
        order.CustomerPhone = request.CustomerPhone ?? order.CustomerPhone;
        order.CustomerAddress = request.CustomerAddress ?? order.CustomerAddress;
        order.CustomerCity = request.CustomerCity ?? order.CustomerCity;
        order.CustomerState = request.CustomerState ?? order.CustomerState;
        order.CustomerZip = request.CustomerZip ?? order.CustomerZip;
        order.CustomerCountry = request.CustomerCountry ?? order.CustomerCountry;
        order.TotalAmount = request.TotalAmount ?? order.TotalAmount;
        order.Status = request.Status ?? order.Status;
        order.UpdatedAt = DateTime.UtcNow;
        var updatedOrder = await _orderRepository.UpdateOrder(order);
        return new OrderResponse(
            updatedOrder.Id,
            updatedOrder.CustomerName,
            updatedOrder.CustomerEmail,
            updatedOrder.CustomerPhone,
            updatedOrder.CustomerAddress,
            updatedOrder.CustomerCity,
            updatedOrder.CustomerState,
            updatedOrder.CustomerZip,
            updatedOrder.CustomerCountry,
            updatedOrder.TotalAmount,
            updatedOrder.Status,
            updatedOrder.CreatedAt,
            updatedOrder.UpdatedAt);
    }
    public async Task<OrderResponse> DeleteOrder(int id)
    {
        _logger.LogInformation("Deleting order by id {Id}", id);
        var order = await _orderRepository.GetOrderById(id);
        if (order == null)
        {
            _logger.LogError("Order not found with id {Id}", id);
            throw new Exception($"Order not found with id {id}");
        }
        await _orderRepository.DeleteOrder(id);
        return new OrderResponse(
            order.Id,
            order.CustomerName,
            order.CustomerEmail,
            order.CustomerPhone,
            order.CustomerAddress,
            order.CustomerCity,
            order.CustomerState,
            order.CustomerZip,
            order.CustomerCountry,
            order.TotalAmount,
            order.Status,
            order.CreatedAt,
            order.UpdatedAt);
    }
}