package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.tap.dao.UserDAO;
import com.tap.dao.RestaurantDAO;
import com.tap.dao.OrderDAO;
import com.tap.daoImpl.UserDAOImpl;
import com.tap.daoImpl.RestaurantDAOImpl;
import com.tap.daoImpl.OrderDAOImpl;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInAdmin") == null) {
            response.sendRedirect("admin-login");
            return;
        }

        try {
            UserDAO userDAO = new UserDAOImpl();
            RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
            OrderDAO orderDAO = new OrderDAOImpl();

            int totalUsers = userDAO.getAllUsers() != null ? userDAO.getAllUsers().size() : 0;
            int totalRestaurants = restaurantDAO.getAllRestaurants() != null ? restaurantDAO.getAllRestaurants().size() : 0;
            
            java.util.List<com.tap.model.OrderTable> orders = orderDAO.getAllOrders();
            int totalOrders = orders != null ? orders.size() : 0;
            
            java.math.BigDecimal totalRevenue = java.math.BigDecimal.ZERO;
            if (orders != null) {
                for (com.tap.model.OrderTable o : orders) {
                    if (o.getStatus() != null && !o.getStatus().equalsIgnoreCase("Cancelled")) {
                        if (o.getTotalAmount() != null) {
                            totalRevenue = totalRevenue.add(o.getTotalAmount());
                        }
                    }
                }
            }
            
            com.tap.dao.MenuDAO menuDAO = new com.tap.daoImpl.MenuDAOImpl();
            int totalMenu = menuDAO.getAllMenus() != null ? menuDAO.getAllMenus().size() : 0;

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalRestaurants", totalRestaurants);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalMenu", totalMenu);
            
            // Pass recent orders to JSP
            request.setAttribute("recentOrders", orders);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback counts if DAOs fail or methods don't exist
            request.setAttribute("totalUsers", 0);
            request.setAttribute("totalRestaurants", 0);
            request.setAttribute("totalOrders", 0);
            request.setAttribute("totalRevenue", java.math.BigDecimal.ZERO);
            request.setAttribute("totalMenu", 0);
            request.setAttribute("recentOrders", new java.util.ArrayList<>());
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
    }
}
