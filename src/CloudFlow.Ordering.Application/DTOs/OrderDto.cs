using System;
using CloudFlow.Ordering.Domain.Entities;

namespace CloudFlow.Ordering.Application.DTOs;

public record OrderCreateRequest(
    string CustomerName,
    string CustomerEmail,
    string CustomerPhone,
    string CustomerAddress,
    string CustomerCity,
    string CustomerState,
    string CustomerZip,
    string CustomerCountry,
    decimal TotalAmount
);

public record OrderResponse(
    int Id,
    string CustomerName,
    string CustomerEmail,
    string CustomerPhone,
    string CustomerAddress,
    string CustomerCity,
    string CustomerState,
    string CustomerZip,
    string CustomerCountry,
    decimal TotalAmount,
    OrderStatus Status,
    DateTime CreatedAt,
    DateTime UpdatedAt
);

public record OrderUpdateRequest(
    string? CustomerName,
    string? CustomerEmail,
    string? CustomerPhone,
    string? CustomerAddress,
    string? CustomerCity,
    string? CustomerState,
    string? CustomerZip,
    string? CustomerCountry,
    decimal? TotalAmount,
    OrderStatus? Status
);