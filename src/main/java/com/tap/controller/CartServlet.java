package com.tap.controller;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.daoImpl.MenuDAOImpl;
import com.tap.model.CartItem;
import com.tap.model.Menu;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String CART_SESSION_KEY = "cart";

    // GET /cart — display the cart
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/cart.jsp");
        rd.forward(request, response);
    }

    // POST /cart — add / update / remove items
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("clear".equals(action)) {
            session.removeAttribute(CART_SESSION_KEY);
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String menuIdParam = request.getParameter("menuId");

        if (menuIdParam == null || menuIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int menuId = Integer.parseInt(menuIdParam);

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new LinkedHashMap<>();
        }

        if ("add".equals(action)) {
            String qtyParam = request.getParameter("quantity");
            int qty = (qtyParam != null && !qtyParam.isEmpty()) ? Integer.parseInt(qtyParam) : 1;

            if (cart.containsKey(menuId)) {
                CartItem existing = cart.get(menuId);
                existing.setQuantity(existing.getQuantity() + qty);
            } else {
                MenuDAOImpl menuDAO = new MenuDAOImpl();
                Menu menu = menuDAO.getMenuById(menuId);
                if (menu != null) {
                    cart.put(menuId, new CartItem(menu, qty));
                }
            }

        } else if ("update".equals(action)) {
            String qtyParam = request.getParameter("quantity");
            int qty = (qtyParam != null) ? Integer.parseInt(qtyParam) : 1;
            if (qty <= 0) {
                cart.remove(menuId);
            } else if (cart.containsKey(menuId)) {
                cart.get(menuId).setQuantity(qty);
            }

        } else if ("remove".equals(action)) {
            cart.remove(menuId);

        }

        session.setAttribute(CART_SESSION_KEY, cart);

        String ctx = request.getContextPath();
        String redirect = request.getParameter("redirect");
        if ("menu".equals(redirect)) {
            String ref = request.getHeader("Referer");
            response.sendRedirect(ref != null ? ref : ctx + "/menu");
        } else {
            response.sendRedirect(ctx + "/cart");
        }
    }
}
