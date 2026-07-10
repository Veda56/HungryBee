package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.tap.dao.OrderDAO;
import com.tap.daoImpl.OrderDAOImpl;
import com.tap.model.Admin;
import com.tap.model.OrderTable;

@WebServlet("/admin-payments")
public class AdminPaymentsServlet extends HttpServlet {
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
            request.setAttribute("paymentHistory", orders);
            
            BigDecimal totalEarnings = BigDecimal.ZERO;
            int successfulPayments = 0;
            
            if (orders != null) {
                for (OrderTable o : orders) {
                    if (o.getStatus() != null && !o.getStatus().equalsIgnoreCase("Cancelled")) {
                        if (o.getTotalAmount() != null) {
                            totalEarnings = totalEarnings.add(o.getTotalAmount());
                            successfulPayments++;
                        }
                    }
                }
            }
            
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("successfulPayments", successfulPayments);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("paymentHistory", new java.util.ArrayList<>());
            request.setAttribute("totalEarnings", BigDecimal.ZERO);
            request.setAttribute("successfulPayments", 0);
            request.setAttribute("errorMsg", "Failed to load payment history.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-payments.jsp").forward(request, response);
    }
}
