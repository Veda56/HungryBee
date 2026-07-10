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
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin-profile")
public class AdminProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (newPassword == null || newPassword.length() < 6) {
                session.setAttribute("errorMsg", "New password must be at least 6 characters.");
                response.sendRedirect(request.getContextPath() + "/admin-profile");
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("errorMsg", "New passwords do not match.");
                response.sendRedirect(request.getContextPath() + "/admin-profile");
                return;
            }

            // Re-validate current password
            Admin validated = adminDAO.validateAdmin(admin.getEmail(), currentPassword);
            if (validated != null) {
                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                boolean success = adminDAO.updatePassword(admin.getAdminId(), hashedNewPassword);
                
                if (success) {
                    session.setAttribute("successMsg", "Password successfully updated.");
                } else {
                    session.setAttribute("errorMsg", "Database error updating password.");
                }
            } else {
                session.setAttribute("errorMsg", "Current password is incorrect.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-profile");
    }
}
