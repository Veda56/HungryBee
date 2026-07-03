<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.math.BigDecimal, com.tap.model.CartItem, com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hungry Bee — Checkout 💳</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  User user = (User) session.getAttribute("user");
  BigDecimal subtotal    = (BigDecimal) request.getAttribute("subtotal");
  BigDecimal deliveryFee = (BigDecimal) request.getAttribute("deliveryFee");
  BigDecimal taxes       = (BigDecimal) request.getAttribute("taxes");
  BigDecimal grandTotal  = (BigDecimal) request.getAttribute("grandTotal");


  int itemCount = 0;
  if (cart != null) {
    for (CartItem item : cart.values()) itemCount += item.getQuantity();
  }

  String defaultAddress = (user != null && user.getAddress() != null && !user.getAddress().isEmpty())
                          ? user.getAddress() : "";
%>

<div class="page-wrapper">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>/</span>
    <a href="${pageContext.request.contextPath}/cart">Cart</a>
    <span>/</span>
    <span>Checkout</span>
  </div>

  <div class="page-header">
    <h1 class="page-title">Checkout 💳</h1>
    <p class="page-subtitle">Complete your order in a few simple steps</p>
  </div>

  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-error">
    <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <div class="checkout-layout">
    <div>
      <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="checkout-form-card">
          <div class="cf-section-title"><i class="fa-solid fa-location-dot"></i> Delivery Details</div>
          <div class="form-row">
            <div class="form-group">
              <label for="fullName">Full Name</label>
              <input type="text" id="fullName" name="fullName"
                     value="<%= user != null ? user.getName() : "" %>" required>
            </div>
            <div class="form-group">
              <label for="phone">Phone Number</label>
              <input type="tel" id="phone" name="phone" placeholder="10-digit mobile number" required>
            </div>
          </div>
          <div class="form-group">
            <label for="deliveryAddress">Delivery Address</label>
            <textarea id="deliveryAddress" name="deliveryAddress" placeholder="House no., street, city, pin code..." required><%= defaultAddress %></textarea>
          </div>
        </div>

        <div class="checkout-form-card">
          <div class="cf-section-title"><i class="fa-solid fa-wallet"></i> Payment Method</div>
          <div class="payment-options">
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="Cash on Delivery" checked>
              <span class="po-icon">💵</span>
              <div>
                <div class="po-label">Cash on Delivery</div>
                <div class="po-desc">Pay when your order arrives</div>
              </div>
            </label>
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="UPI">
              <span class="po-icon">📱</span>
              <div>
                <div class="po-label">UPI</div>
                <div class="po-desc">Google Pay, PhonePe, Paytm</div>
              </div>
            </label>
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="Credit/Debit Card">
              <span class="po-icon">💳</span>
              <div>
                <div class="po-label">Credit / Debit Card</div>
                <div class="po-desc">Visa, Mastercard, RuPay</div>
              </div>
            </label>
          </div>
        </div>

        <button type="submit" class="btn btn-primary btn-lg">
          <i class="fa-solid fa-check"></i> Place Order — ₹<%= grandTotal %>
        </button>
      </form>
    </div>

    <div class="order-summary-card">
      <div class="os-title">Order Summary (<%= itemCount %> items)</div>
      <% if (cart != null) {
           for (CartItem item : cart.values()) { %>
      <div class="os-row">
        <span><%= item.getMenu().getItemName() %> × <%= item.getQuantity() %></span>
        <span class="os-val">₹<%= item.getSubtotal() %></span>
      </div>
      <%   }
         } %>
      <hr class="os-divider">
      <div class="os-row"><span>Subtotal</span><span class="os-val">₹<%= subtotal %></span></div>
      <div class="os-row"><span>Delivery Fee</span><span class="os-val">₹<%= deliveryFee %></span></div>
      <div class="os-row"><span>Taxes (5%)</span><span class="os-val">₹<%= taxes %></span></div>
      <div class="os-row total"><span>Total</span><span class="os-val">₹<%= grandTotal %></span></div>
    </div>
  </div>
</div>

<%@ include file="partials/footer.jsp" %>

<script>
  const nb = document.getElementById('mainNavbar');
  if (nb) window.addEventListener('scroll', () => nb.classList.toggle('scrolled', scrollY > 10));
</script>
</body>
</html>
