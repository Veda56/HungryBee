package com.tap.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.tap.dao.RestaurantDAO;
import com.tap.daoImpl.RestaurantDAOImpl;
import com.tap.model.Admin;
import com.tap.model.Restaurant;

@WebServlet("/admin-restaurants")
public class AdminRestaurantsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedInAdmin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        try {
            List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();
            request.setAttribute("restaurantsList", restaurants);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("restaurantsList", new java.util.ArrayList<>());
            request.setAttribute("errorMsg", "Failed to load restaurants.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-restaurants.jsp").forward(request, response);
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
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                boolean success = restaurantDAO.deleteRestaurant(restaurantId);
                if (success) {
                    session.setAttribute("successMsg", "Restaurant deleted successfully.");
                } else {
                    session.setAttribute("errorMsg", "Failed to delete restaurant.");
                }
            } else if ("add".equals(action)) {
                String name = request.getParameter("name");
                String cuisine = request.getParameter("cuisine");
                String deliveryTime = request.getParameter("deliveryTime");
                int adminUserId = Integer.parseInt(request.getParameter("adminUserId"));
                String address = request.getParameter("address");
                
                Restaurant newRest = new Restaurant(name, cuisine, deliveryTime, address, adminUserId, java.math.BigDecimal.ZERO, true);
                int result = restaurantDAO.addRestaurant(newRest);
                
                if (result > 0) {
                    session.setAttribute("successMsg", "Restaurant added successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to add restaurant. Check if the Admin User ID exists.");
                }
            } else if ("toggle".equals(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                Restaurant r = restaurantDAO.getRestaurantById(restaurantId);
                if (r != null) {
                    r.setActive(!r.isActive());
                    boolean success = restaurantDAO.updateRestaurant(r);
                    if (success) {
                        session.setAttribute("successMsg", "Restaurant status toggled.");
                    } else {
                        session.setAttribute("errorMsg", "Failed to update restaurant status.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin-restaurants");
    }
}
