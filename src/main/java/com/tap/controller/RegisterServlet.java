package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.dao.UserDAO;
import com.tap.daoImpl.UserDAOImpl;
import com.tap.model.User;
import com.tap.utility.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/register.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (name == null || name.trim().length() < 3) {
            request.setAttribute("error", "Name must be at least 3 characters.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.trim().contains("@")) {
            request.setAttribute("error", "Enter a valid email address.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAOImpl();
            email = email.trim();

            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "This email is already registered. Please log in.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            Timestamp currentDate = new Timestamp(System.currentTimeMillis());
            String hashedPassword = PasswordUtil.hashPassword(password);
            String address = (phone != null && !phone.trim().isEmpty()) ? phone.trim() : "";

            User user = new User(
                name.trim(),
                hashedPassword,
                email,
                address,
                "Customer",
                currentDate,
                currentDate
            );

            int result = userDAO.addUser(user);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
