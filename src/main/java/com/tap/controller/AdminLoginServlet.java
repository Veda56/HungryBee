package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.tap.dao.AdminDAO;
import com.tap.daoImpl.AdminDAOImpl;
import com.tap.model.Admin;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AdminDAO adminDAO = new AdminDAOImpl();
        Admin admin = adminDAO.validateAdmin(email, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInAdmin", admin);
            response.sendRedirect("admin-dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid Admin Credentials.");
            request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
        }
    }
}
