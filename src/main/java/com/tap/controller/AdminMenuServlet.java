package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.tap.dao.MenuDAO;
import com.tap.daoImpl.MenuDAOImpl;
import com.tap.model.Admin;
import com.tap.model.Menu;

@WebServlet("/admin-menu")
public class AdminMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO;

    @Override
    public void init() throws ServletException {
        menuDAO = new MenuDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        try {
            List<Menu> menus = menuDAO.getAllMenus();
            request.setAttribute("menusList", menus);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("menusList", new java.util.ArrayList<>());
            request.setAttribute("errorMsg", "Failed to load menus.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-menu.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                boolean success = menuDAO.deleteMenu(menuId);
                if (success) {
                    session.setAttribute("successMsg", "Menu item deleted successfully.");
                } else {
                    session.setAttribute("errorMsg", "Failed to delete menu item.");
                }
            } else if ("toggle".equals(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                Menu menu = menuDAO.getMenuById(menuId);
                if (menu != null) {
                    menu.setAvailable(!menu.isAvailable()); // Toggle boolean
                    boolean success = menuDAO.updateMenu(menu);
                    if (success) {
                        session.setAttribute("successMsg", "Menu availability toggled successfully.");
                    } else {
                        session.setAttribute("errorMsg", "Failed to update availability.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-menu");
    }
}
