<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, java.util.Map, com.tap.model.CartItem" %>
<%
    User navUser = (User) session.getAttribute("user");
    String displayName = (navUser != null) ? navUser.getName() : "Guest";
    String avatarLetter = (displayName != null && !displayName.isEmpty())
                          ? String.valueOf(displayName.charAt(0)).toUpperCase() : "?";
    String servletPath = request.getServletPath() != null ? request.getServletPath() : "";
    String homeActive   = servletPath.contains("home")   ? "active" : "";
    String menuActive   = servletPath.contains("menu")   ? "active" : "";
    String cartActive   = servletPath.contains("cart")   ? "active" : "";
    String ordersActive = servletPath.contains("orders") || servletPath.contains("order-confirm") ? "active" : "";
    String profileActive = servletPath.contains("profile") ? "active" : "";

    int cartCount = 0;
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart != null) {
        for (CartItem item : cart.values()) {
            cartCount += item.getQuantity();
        }
    }
%>
<nav class="navbar" id="mainNavbar">

    <a href="${pageContext.request.contextPath}/home" class="nav-logo" id="navLogo">
        <span class="bee-icon">🐝</span>
        <span>Hungry Bee</span>
    </a>

    <div class="nav-search">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <input
            type="text"
            id="navSearchInput"
            placeholder="Search restaurants, cuisines..."
            autocomplete="off"
        >
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home" id="navHome" class="<%= homeActive %>">
            <i class="fa-solid fa-house"></i> Home
        </a>
        <a href="${pageContext.request.contextPath}/menu" id="navMenu" class="<%= menuActive %>">
            <i class="fa-solid fa-utensils"></i> Menu
        </a>
        <a href="${pageContext.request.contextPath}/orders" id="navOrders" class="<%= ordersActive %>">
            <i class="fa-solid fa-box"></i> Orders
        </a>
        <a href="${pageContext.request.contextPath}/cart" id="navCart" class="cart-link <%= cartActive %>">
            <i class="fa-solid fa-cart-shopping"></i> Cart
            <% if (cartCount > 0) { %>
            <span class="cart-badge" id="cartBadge"><%= cartCount %></span>
            <% } %>
        </a>
    </div>

    <a href="${pageContext.request.contextPath}/profile" class="nav-user <%= profileActive %>" id="navUserMenu" title="<%= displayName %>">
        <div class="avatar"><%= avatarLetter %></div>
        <span class="user-name"><%= displayName %></span>
    </a>

    <a href="${pageContext.request.contextPath}/logout" id="navLogout">
        <button type="button" class="btn-logout">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </button>
    </a>
</nav>
