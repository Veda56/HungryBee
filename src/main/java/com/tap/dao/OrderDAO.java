package com.tap.dao;

import java.util.List;

import com.tap.model.OrderTable;

public interface OrderDAO {

    int addOrder(OrderTable order);

    OrderTable getOrderById(int orderId);

    List<OrderTable> getAllOrders();

    List<OrderTable> getOrdersByUserId(int userId);

    List<OrderTable> getOrdersByRestaurantId(int restaurantId);

    boolean updateOrderStatus(int orderId, String status);

    boolean updatePaymentMethod(int orderId, String paymentMethod);

    boolean deleteOrder(int orderId);
}