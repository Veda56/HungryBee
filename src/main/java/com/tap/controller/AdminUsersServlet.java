package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.tap.dao.UserDAO;
import com.tap.daoImpl.UserDAOImpl;
import com.tap.model.Admin;
import com.tap.model.User;

@WebServlet("/admin-users")
public class AdminUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("usersList", users);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("usersList", new java.util.ArrayList<>());
            request.setAttribute("errorMsg", "Failed to load users.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-users.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean success = userDAO.deleteUser(userId);
                if (success) {
                    session.setAttribute("successMsg", "User deleted successfully.");
                } else {
                    session.setAttribute("errorMsg", "Failed to delete user.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Invalid User ID.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-users");
    }
}
