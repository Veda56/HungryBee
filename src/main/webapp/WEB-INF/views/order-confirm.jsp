<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, com.tap.model.OrderTable, com.tap.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hungry Bee — Order Confirmed ✅</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  OrderTable order = (OrderTable) request.getAttribute("order");
  Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

  if (order == null) {
%>
<div class="page-wrapper">
  <div class="empty-state">
    <span class="es-icon">❓</span>
    <h3>Order not found</h3>
    <p>We couldn't find the order you're looking for.</p>
    <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary">View My Orders</a>
  </div>
</div>
<% } else {
     String restaurantName = restaurant != null ? restaurant.getName() : "Restaurant";
     String dateStr = order.getOrderDate() != null ? sdf.format(order.getOrderDate()) : "—";
     String statusClass = "status-pending";
     if ("Delivered".equalsIgnoreCase(order.getStatus())) statusClass = "status-delivered";
     else if ("Cancelled".equalsIgnoreCase(order.getStatus())) statusClass = "status-cancelled";
%>

<div class="confirm-wrapper">
  <div class="confirm-animation">✅</div>
  <h1 class="confirm-title">Order Placed!</h1>
  <p class="confirm-subtitle">Your food is being prepared and will arrive buzzing fast 🐝</p>

  <div class="confirm-card">
    <div class="confirm-row">
      <span class="label">Order ID</span>
      <span class="value">#<%= order.getOrderId() %></span>
    </div>
    <div class="confirm-row">
      <span class="label">Restaurant</span>
      <span class="value"><%= restaurantName %></span>
    </div>
    <div class="confirm-row">
      <span class="label">Order Date</span>
      <span class="value"><%= dateStr %></span>
    </div>
    <div class="confirm-row">
      <span class="label">Payment</span>
      <span class="value"><%= order.getPaymentMethod() %></span>
    </div>
    <div class="confirm-row">
      <span class="label">Status</span>
      <span class="status-badge <%= statusClass %>"><%= order.getStatus() %></span>
    </div>
    <div class="confirm-row">
      <span class="label">Total Amount</span>
      <span class="value amount">₹<%= order.getTotalAmount() %></span>
    </div>
  </div>

  <div class="track-steps">
    <div class="track-step">
      <div class="ts-icon done">✅</div>
      <div class="ts-label">Order<br>Placed</div>
    </div>
    <div class="track-step">
      <div class="ts-icon active">👨‍🍳</div>
      <div class="ts-label">Preparing<br>Food</div>
    </div>
    <div class="track-step">
      <div class="ts-icon">🛵</div>
      <div class="ts-label">Out for<br>Delivery</div>
    </div>
    <div class="track-step">
      <div class="ts-icon">🍽️</div>
      <div class="ts-label">Delivered</div>
    </div>
  </div>

  <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
    <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary btn-lg">
      <i class="fa-solid fa-box"></i> View All Orders
    </a>
    <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-lg">
      <i class="fa-solid fa-utensils"></i> Order Again
    </a>
  </div>
</div>

<% } %>

<%@ include file="partials/footer.jsp" %>

<script>
  const nb = document.getElementById('mainNavbar');
  if (nb) window.addEventListener('scroll', () => nb.classList.toggle('scrolled', scrollY > 10));

  <% if (order != null) { %>
  // Show success popup only when order is successfully confirmed by backend
  document.addEventListener('DOMContentLoaded', function() {
      Swal.fire({
          title: 'Order Placed Successfully! 🎉',
          text: 'Your delicious food is being prepared 😋',
          icon: 'success',
          confirmButtonColor: '#10b981', // green for success
          confirmButtonText: 'Awesome!'
      });
  });
  <% } %>
</script>
</body>
</html>
