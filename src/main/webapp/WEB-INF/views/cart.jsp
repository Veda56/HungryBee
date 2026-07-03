<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.math.BigDecimal, com.tap.model.CartItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hungry Bee — Cart 🛒</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  // NOTE: The 'cart' variable is already declared and injected by the header.jsp include above.
  // Do not re-declare Map<Integer, CartItem> cart here, otherwise you will get a "Duplicate local variable" error!
  BigDecimal subtotal = BigDecimal.ZERO;
  int itemCount = 0;
  if (cart != null) {
    for (CartItem item : cart.values()) {
      subtotal = subtotal.add(item.getSubtotal());
      itemCount += item.getQuantity();
    }
  }
  BigDecimal deliveryFee = new BigDecimal("40.00");
  BigDecimal taxes = subtotal.multiply(new BigDecimal("0.05")).setScale(2, java.math.RoundingMode.HALF_UP);
  BigDecimal grandTotal = subtotal.add(deliveryFee).add(taxes);
%>

<div class="page-wrapper">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>/</span>
    <span>Cart</span>
  </div>

  <div class="page-header">
    <h1 class="page-title">Your Cart 🛒</h1>
    <p class="page-subtitle"><%= itemCount %> item<%= itemCount != 1 ? "s" : "" %> in your cart</p>
  </div>

  <% if (cart == null || cart.isEmpty()) { %>
  <div class="empty-state">
    <span class="es-icon">🛒</span>
    <h3>Your cart is empty</h3>
    <p>Add some delicious items from our menu to get started.</p>
    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">
      <i class="fa-solid fa-utensils"></i> Browse Menu
    </a>
  </div>
  <% } else { %>
  <div class="cart-layout">
    <div class="cart-items-section">
      <% for (CartItem item : cart.values()) {
           int menuId = item.getMenu().getMenuId();
           String catLower = item.getMenu().getCategory() != null ? item.getMenu().getCategory().toLowerCase() : "";
           String emoji = "🍽️";
           if (catLower.contains("pizza")) emoji = "🍕";
           else if (catLower.contains("burger")) emoji = "🍔";
           else if (catLower.contains("sushi")) emoji = "🍣";
           else if (catLower.contains("chinese")) emoji = "🍜";
           else if (catLower.contains("indian")) emoji = "🍛";
           else if (catLower.contains("dessert")) emoji = "🍰";
      %>
      <div class="cart-item-card" id="cartItem-<%= menuId %>">
        <div class="ci-img"><%= emoji %></div>
        <div class="ci-info">
          <div class="ci-name"><%= item.getMenu().getItemName() %></div>
          <div class="ci-restaurant"><%= item.getMenu().getCategory() %></div>
          <div class="ci-price">₹<%= item.getSubtotal() %></div>
        </div>
        <div class="ci-actions">
          <form action="${pageContext.request.contextPath}/cart" method="post" class="qty-control">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="menuId" value="<%= menuId %>">
            <button type="submit" name="quantity" value="<%= item.getQuantity() - 1 %>" class="qty-btn">−</button>
            <span class="qty-val"><%= item.getQuantity() %></span>
            <button type="submit" name="quantity" value="<%= item.getQuantity() + 1 %>" class="qty-btn">+</button>
          </form>
          <form action="${pageContext.request.contextPath}/cart" method="post">
            <input type="hidden" name="action" value="remove">
            <input type="hidden" name="menuId" value="<%= menuId %>">
            <button type="submit" class="ci-remove-btn" title="Remove item">
              <i class="fa-solid fa-trash"></i>
            </button>
          </form>
        </div>
      </div>
      <% } %>

      <form action="${pageContext.request.contextPath}/cart" method="post" style="margin-top:8px;">
        <input type="hidden" name="action" value="clear">
        <button type="submit" class="btn btn-outline btn-sm">
          <i class="fa-solid fa-trash-can"></i> Clear Cart
        </button>
      </form>
    </div>

    <div class="order-summary-card">
      <div class="os-title">Order Summary</div>
      <div class="os-row"><span>Subtotal</span><span class="os-val">₹<%= subtotal %></span></div>
      <div class="os-row"><span>Delivery Fee</span><span class="os-val">₹<%= deliveryFee %></span></div>
      <div class="os-row"><span>Taxes (5%)</span><span class="os-val">₹<%= taxes %></span></div>
      <hr class="os-divider">
      <div class="os-row total"><span>Total</span><span class="os-val">₹<%= grandTotal %></span></div>
      <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg" style="width:100%;margin-top:20px;justify-content:center;">
        <i class="fa-solid fa-credit-card"></i> Proceed to Checkout
      </a>
      <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline" style="width:100%;margin-top:12px;justify-content:center;">
        <i class="fa-solid fa-arrow-left"></i> Continue Shopping
      </a>
    </div>
  </div>
  <% } %>
</div>

<%@ include file="partials/footer.jsp" %>

<script>
  const nb = document.getElementById('mainNavbar');
  if (nb) window.addEventListener('scroll', () => nb.classList.toggle('scrolled', scrollY > 10));
</script>
</body>
</html>
