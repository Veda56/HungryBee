package com.tap.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.daoImpl.OrderDAOImpl;
import com.tap.daoImpl.OrderItemDAOImpl;
import com.tap.daoImpl.UserDAOImpl;
import com.tap.model.CartItem;
import com.tap.model.OrderItem;
import com.tap.model.OrderTable;
import com.tap.model.User;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // GET /checkout — show checkout form
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Calculate totals
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            subtotal = subtotal.add(item.getSubtotal());
        }
        BigDecimal deliveryFee = new BigDecimal("40.00");
        BigDecimal taxes      = subtotal.multiply(new BigDecimal("0.05")).setScale(2, java.math.RoundingMode.HALF_UP);
        BigDecimal grandTotal = subtotal.add(deliveryFee).add(taxes);

        request.setAttribute("subtotal",    subtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("taxes",       taxes);
        request.setAttribute("grandTotal",  grandTotal);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/checkout.jsp");
        rd.forward(request, response);
    }

    // POST /checkout — place the order
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        User user = (User) session.getAttribute("user");
        String paymentMethod = request.getParameter("paymentMethod");
        String deliveryAddress = request.getParameter("deliveryAddress");

        if (deliveryAddress != null && !deliveryAddress.trim().isEmpty()) {
            user.setAddress(deliveryAddress.trim());
            new UserDAOImpl().updateUser(user);
        }

        // Determine restaurant from first cart item
        int restaurantId = cart.values().iterator().next().getMenu().getRestaurantId();

        // Calculate grand total
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            subtotal = subtotal.add(item.getSubtotal());
        }
        BigDecimal deliveryFee = new BigDecimal("40.00");
        
        String coupon = request.getParameter("coupon");
        if ("FREEDELIVERY".equalsIgnoreCase(coupon)) {
            deliveryFee = BigDecimal.ZERO;
        }
        
        BigDecimal taxes       = subtotal.multiply(new BigDecimal("0.05")).setScale(2, java.math.RoundingMode.HALF_UP);
        BigDecimal grandTotal  = subtotal.add(deliveryFee).add(taxes);
        
        try {
            OrderDAOImpl orderDAO        = new OrderDAOImpl();
            OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();

            // 1. Create the order record
            OrderTable order = new OrderTable(
                user.getUserId(),
                restaurantId,
                new Timestamp(System.currentTimeMillis()),
                grandTotal,
                "Pending",
                paymentMethod != null ? paymentMethod : "Cash"
            );
            int orderId = orderDAO.addOrder(order);

            if (orderId > 0) {
                // 2. Insert each order item
                for (CartItem item : cart.values()) {
                    OrderItem oi = new OrderItem(
                        orderId,
                        item.getMenu().getMenuId(),
                        item.getQuantity(),
                        item.getSubtotal()
                    );
                    orderItemDAO.addOrderItem(oi);
                }

                // 3. Clear the cart
                session.removeAttribute("cart");
                session.setAttribute("user", user);

                response.sendRedirect(request.getContextPath() + "/order-confirm?orderId=" + orderId);
            } else {
                request.setAttribute("error", "Failed to place order. Please try again.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}
