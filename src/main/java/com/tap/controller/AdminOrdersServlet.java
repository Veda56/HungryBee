package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.tap.dao.OrderDAO;
import com.tap.daoImpl.OrderDAOImpl;
import com.tap.model.Admin;
import com.tap.model.OrderTable;

@WebServlet("/admin-orders")
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        try {
            List<OrderTable> orders = orderDAO.getAllOrders();
            request.setAttribute("ordersList", orders);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ordersList", new java.util.ArrayList<>());
            request.setAttribute("errorMsg", "Failed to load orders.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-orders.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                
                boolean success = orderDAO.updateOrderStatus(orderId, status);
                if (success) {
                    session.setAttribute("successMsg", "Order #" + orderId + " status updated to " + status);
                } else {
                    session.setAttribute("errorMsg", "Failed to update order status.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Invalid Request Parameters.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-orders");
    }
}
