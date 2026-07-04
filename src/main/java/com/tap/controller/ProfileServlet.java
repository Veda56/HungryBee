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
import com.tap.daoImpl.OrderItemDAOImpl;
import com.tap.daoImpl.MenuDAOImpl;
import com.tap.daoImpl.RestaurantDAOImpl;
import com.tap.daoImpl.UserDAOImpl;
import com.tap.model.OrderTable;
import com.tap.model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // GET /profile — show profile page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            OrderDAOImpl orderDAO = new OrderDAOImpl();
            List<OrderTable> orders = orderDAO.getOrdersByUserId(user.getUserId());
            request.setAttribute("orderCount", orders.size());
            request.setAttribute("orders", orders);
            request.setAttribute("restaurantDAO", new RestaurantDAOImpl());
            request.setAttribute("orderItemDAO", new OrderItemDAOImpl());
            request.setAttribute("menuDAO", new MenuDAOImpl());

            // Stats: count by status
            long pending   = orders.stream().filter(o -> "Pending".equalsIgnoreCase(o.getStatus())).count();
            long delivered = orders.stream().filter(o -> "Delivered".equalsIgnoreCase(o.getStatus())).count();
            request.setAttribute("pendingCount",   pending);
            request.setAttribute("deliveredCount", delivered);

        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/profile.jsp");
        rd.forward(request, response);
    }

    // POST /profile — update name / address / password
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String name    = request.getParameter("name");
        String address = request.getParameter("address");
        String newPwd  = request.getParameter("newPassword");
        String confPwd = request.getParameter("confirmPassword");

        try {
            UserDAOImpl userDAO = new UserDAOImpl();

            if (name != null && !name.trim().isEmpty()) user.setName(name.trim());
            if (address != null)                         user.setAddress(address.trim());

            if (newPwd != null && !newPwd.isEmpty()) {
                if (!newPwd.equals(confPwd)) {
                    request.setAttribute("error", "Passwords do not match.");
                    doGet(request, response);
                    return;
                }
                user.setPassword(BCrypt.hashpw(newPwd, BCrypt.gensalt()));
            }

            boolean updated = userDAO.updateUser(user);
            if (updated) {
                session.setAttribute("user", user);
                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Update failed. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        doGet(request, response);
    }
}
