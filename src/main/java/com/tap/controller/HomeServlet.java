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

import com.tap.daoImpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Handles GET /home — shows home page after login
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in — redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch active restaurants and pass them to the view
        try {
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
            List<Restaurant> restaurants = restaurantDAO.getActiveRestaurants();
            request.setAttribute("restaurants", restaurants);
        } catch (Exception e) {
            e.printStackTrace();
            // Continue — view handles null list gracefully with empty state
        }

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
        rd.forward(request, response);
    }

    // Handle POST /home as well (in case of form submissions on home page)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
