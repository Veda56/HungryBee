package com.tap.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.daoImpl.OrderDAOImpl;
import com.tap.daoImpl.RestaurantDAOImpl;
import com.tap.model.OrderTable;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet({"/orders", "/order-confirm"})
public class OrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        try {
            OrderDAOImpl      orderDAO      = new OrderDAOImpl();
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();

            if ("/order-confirm".equals(path)) {
                // Order confirmation page
                String orderIdParam = request.getParameter("orderId");
                if (orderIdParam != null) {
                    int orderId = Integer.parseInt(orderIdParam);
                    OrderTable order = orderDAO.getOrderById(orderId);
                    if (order != null) {
                        Restaurant restaurant = restaurantDAO.getRestaurantById(order.getRestaurantId());
                        request.setAttribute("order", order);
                        request.setAttribute("restaurant", restaurant);
                    }
                }
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/order-confirm.jsp");
                rd.forward(request, response);

            } else {
                // My Orders list page
                List<OrderTable> orders = orderDAO.getOrdersByUserId(user.getUserId());
                request.setAttribute("orders", orders);
                request.setAttribute("restaurantDAO", restaurantDAO);
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/orders.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/orders.jsp");
            rd.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
