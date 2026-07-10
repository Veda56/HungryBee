<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, com.tap.model.OrderTable, com.tap.daoImpl.RestaurantDAOImpl, com.tap.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hungry Bee — My Orders 📦</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<OrderTable> orders = (List<OrderTable>) request.getAttribute("orders");
  RestaurantDAOImpl restaurantDAO = (RestaurantDAOImpl) request.getAttribute("restaurantDAO");
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

  int totalOrders = orders != null ? orders.size() : 0;
  long pendingCount = 0, deliveredCount = 0;
  if (orders != null) {
    for (OrderTable o : orders) {
      if ("Pending".equalsIgnoreCase(o.getStatus())) pendingCount++;
      if ("Delivered".equalsIgnoreCase(o.getStatus())) deliveredCount++;
    }
  }
%>

<div class="page-wrapper">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>/</span>
    <span>My Orders</span>
  </div>

  <div class="page-header">
    <h1 class="page-title">My Orders 📦</h1>
    <p class="page-subtitle">Track and review all your past orders</p>
  </div>

  <div class="stats-row">
    <div class="stat-card">
      <div class="stat-card-icon">📋</div>
      <div>
        <div class="stat-card-val"><%= totalOrders %></div>
        <div class="stat-card-label">Total Orders</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-card-icon">⏳</div>
      <div>
        <div class="stat-card-val"><%= pendingCount %></div>
        <div class="stat-card-label">Pending</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-card-icon">✅</div>
      <div>
        <div class="stat-card-val"><%= deliveredCount %></div>
        <div class="stat-card-label">Delivered</div>
      </div>
    </div>
  </div>

  <% if (orders == null || orders.isEmpty()) { %>
  <div class="empty-state">
    <span class="es-icon">📦</span>
    <h3>No orders yet</h3>
    <p>When you place an order, it will appear here.</p>
    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">
      <i class="fa-solid fa-utensils"></i> Order Now
    </a>
  </div>
  <% } else { %>
  <div class="orders-list">
    <% for (OrderTable o : orders) {
         Restaurant restaurant = restaurantDAO != null ? restaurantDAO.getRestaurantById(o.getRestaurantId()) : null;
         String restaurantName = restaurant != null ? restaurant.getName() : "Restaurant #" + o.getRestaurantId();
         String statusClass = "status-pending";
         if ("Delivered".equalsIgnoreCase(o.getStatus())) statusClass = "status-delivered";
         else if ("Cancelled".equalsIgnoreCase(o.getStatus())) statusClass = "status-cancelled";
         String dateStr = o.getOrderDate() != null ? sdf.format(o.getOrderDate()) : "—";
    %>
    <div class="order-card" id="order-<%= o.getOrderId() %>">
      <div class="oc-left">
        <div class="oc-icon">🍽️</div>
        <div class="oc-info">
          <div class="oc-id">Order #<%= o.getOrderId() %></div>
          <div class="oc-name"><%= restaurantName %></div>
          <div class="oc-date"><i class="fa-regular fa-clock"></i> <%= dateStr %></div>
        </div>
      </div>
      <div class="oc-right">
        <div class="oc-amount">₹<%= o.getTotalAmount() %></div>
        <span class="status-badge <%= statusClass %>"><%= o.getStatus() %></span>
        <div class="oc-method">
          <i class="fa-solid fa-wallet"></i> <%= o.getPaymentMethod() %>
        </div>
        <a href="${pageContext.request.contextPath}/order-confirm?orderId=<%= o.getOrderId() %>" class="btn btn-outline btn-sm view-details-btn">
          View Details
        </a>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>
</div>

<%@ include file="partials/footer.jsp" %>

<script>
  const nb = document.getElementById('mainNavbar');
  if (nb) window.addEventListener('scroll', () => nb.classList.toggle('scrolled', scrollY > 10));

  // Add realistic bee flight keyframes
  const style = document.createElement('style');
  style.innerHTML = `
    @keyframes realistic-bee-flight {
      0% {
        transform: translate(0, 0) scale(1) rotate(0deg);
        opacity: 1;
      }
      20% {
        transform: translate(-40px, -60px) scale(1.2) rotate(-15deg);
      }
      40% {
        transform: translate(-120px, -40px) scale(1.5) rotate(-5deg);
      }
      60% {
        transform: translate(-250px, -150px) scale(1.8) rotate(-25deg);
      }
      80% {
        transform: translate(-400px, -100px) scale(2.2) rotate(-10deg);
        opacity: 1;
      }
      100% {
        transform: translate(-600px, -300px) scale(3) rotate(-30deg);
        opacity: 0;
      }
    }
  `;
  document.head.appendChild(style);

  // Bee fly animation on View Details click
  document.querySelectorAll('.view-details-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      const url = this.href;

      // Create a transition overlay to make it look like it's redirecting
      const overlay = document.createElement('div');
      overlay.style.position = 'fixed';
      overlay.style.inset = '0';
      overlay.style.backgroundColor = 'rgba(255, 253, 248, 0.85)';
      overlay.style.backdropFilter = 'blur(5px)';
      overlay.style.zIndex = '999998';
      overlay.style.display = 'flex';
      overlay.style.alignItems = 'center';
      overlay.style.justifyContent = 'center';
      overlay.style.opacity = '0';
      overlay.style.transition = 'opacity 0.4s ease';

      const loadingText = document.createElement('h2');
      loadingText.innerText = 'Buzzing to your order details... 🐝';
      loadingText.style.color = 'var(--primary, #FFA500)';
      loadingText.style.fontFamily = 'Inter, sans-serif';
      loadingText.style.fontSize = '24px';
      loadingText.style.fontWeight = '800';
      
      overlay.appendChild(loadingText);
      document.body.appendChild(overlay);

      // Fade in the overlay
      setTimeout(() => overlay.style.opacity = '1', 10);

      // Create bee element for the flight
      const bee = document.createElement('div');
      bee.innerText = '🐝';
      bee.style.position = 'fixed';
      bee.style.fontSize = '32px';
      // Ensure it renders above the overlay
      bee.style.zIndex = '999999';
      bee.style.pointerEvents = 'none';

      // Start position at the center of the button
      const rect = this.getBoundingClientRect();
      bee.style.left = (rect.left + rect.width / 2 - 16) + 'px';
      bee.style.top = (rect.top + rect.height / 2 - 16) + 'px';
      
      // Apply the realistic flight animation
      bee.style.animation = 'realistic-bee-flight 1.5s cubic-bezier(0.25, 0.1, 0.25, 1) forwards';

      document.body.appendChild(bee);

      // Redirect after animation finishes
      setTimeout(() => {
        // Fade out the whole body right before navigating for a smooth transition
        document.body.style.transition = 'opacity 0.2s ease';
        document.body.style.opacity = '0';
        setTimeout(() => {
            window.location.href = url;
        }, 200);
      }, 1300);
    });
  });
</script>
</body>
</html>
