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

import com.tap.daoImpl.MenuDAOImpl;
import com.tap.daoImpl.RestaurantDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();

            String restaurantIdParam = request.getParameter("restaurantId");
            String categoryParam = request.getParameter("category");

            List<Menu> menus;
            Restaurant selectedRestaurant = null;

            if (restaurantIdParam != null && !restaurantIdParam.isEmpty()) {
                int restaurantId = Integer.parseInt(restaurantIdParam);
                menus = menuDAO.getAvailableMenusByRestaurantId(restaurantId);
                selectedRestaurant = restaurantDAO.getRestaurantById(restaurantId);
                request.setAttribute("selectedRestaurant", selectedRestaurant);
            } else if (categoryParam != null && !categoryParam.isEmpty()) {
                menus = menuDAO.getMenusByCategory(categoryParam);
                request.setAttribute("selectedCategory", categoryParam);
            } else {
                menus = menuDAO.getAllMenus();
            }

            // Also pass all active restaurants for the sidebar/filter
            List<Restaurant> restaurants = restaurantDAO.getActiveRestaurants();
            request.setAttribute("menus", menus);
            request.setAttribute("restaurants", restaurants);

        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/menu.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
