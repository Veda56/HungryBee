<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.tap.model.OrderTable" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoImpl.RestaurantDAOImpl" %>
<%@ page import="com.tap.daoImpl.OrderItemDAOImpl" %>
<%@ page import="com.tap.daoImpl.MenuDAOImpl" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hungry Bee — Profile 👤</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  User user = (User) session.getAttribute("user");
  Integer orderCount     = (Integer) request.getAttribute("orderCount");
  Long pendingCount      = (Long) request.getAttribute("pendingCount");
  Long deliveredCount    = (Long) request.getAttribute("deliveredCount");
  if (orderCount == null) orderCount = 0;
  if (pendingCount == null) pendingCount = 0L;
  if (deliveredCount == null) deliveredCount = 0L;
  
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
  SimpleDateFormat dateOnlySdf = new SimpleDateFormat("dd MMM yyyy");
  
  @SuppressWarnings("unchecked")
  List<OrderTable> orders = (List<OrderTable>) request.getAttribute("orders");
  RestaurantDAOImpl restaurantDAO = (RestaurantDAOImpl) request.getAttribute("restaurantDAO");
  OrderItemDAOImpl orderItemDAO = (OrderItemDAOImpl) request.getAttribute("orderItemDAO");
  MenuDAOImpl menuDAO = (MenuDAOImpl) request.getAttribute("menuDAO");
%>

<div class="page-wrapper">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>/</span>
    <span>Profile</span>
  </div>

  <% if (request.getAttribute("success") != null) { %>
  <div class="alert alert-success">
    <i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("success") %>
  </div>
  <% } %>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-error">
    <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <div class="profile-layout">
    <aside class="profile-sidebar-card">
      <div class="profile-avatar-large"><%= avatarLetter %></div>
      <div class="profile-name"><%= user != null ? user.getName() : "Guest" %></div>
      <div class="profile-email"><%= user != null ? user.getEmail() : "" %></div>
      <span class="profile-role"><%= user != null ? user.getRole() : "Customer" %></span>

      <div class="profile-stats">
        <div class="ps-stat">
          <div class="ps-val"><%= orderCount %></div>
          <div class="ps-label">Orders</div>
        </div>
        <div class="ps-stat">
          <div class="ps-val"><%= deliveredCount %></div>
          <div class="ps-label">Delivered</div>
        </div>
      </div>

      <nav class="profile-nav">
        <a href="${pageContext.request.contextPath}/profile" class="profile-nav-item active">
          <i class="fa-solid fa-user"></i> Edit Profile
        </a>
        <a href="#order-history" class="profile-nav-item">
          <i class="fa-solid fa-box"></i> My Orders
        </a>
        <a href="${pageContext.request.contextPath}/cart" class="profile-nav-item">
          <i class="fa-solid fa-cart-shopping"></i> My Cart
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="profile-nav-item" style="color: #e74c3c;">
          <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
      </nav>
    </aside>

    <div>
      <div class="profile-main-card">
        <div class="pmc-title"><i class="fa-solid fa-pen-to-square"></i> Personal Information</div>
        <form action="${pageContext.request.contextPath}/profile" method="post">
          <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name"
                   value="<%= user != null ? user.getName() : "" %>" required>
          </div>
          <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email"
                   value="<%= user != null ? user.getEmail() : "" %>" disabled>
          </div>
          <div class="form-group">
            <label for="address">Delivery Address</label>
            <textarea id="address" name="address" placeholder="Your default delivery address"><%= user != null && user.getAddress() != null ? user.getAddress() : "" %></textarea>
          </div>
          <div class="form-group">
            <label>Date Joined</label>
            <%
               String dateJoined = "Not available";
               if (user != null && user.getCreatedDate() != null) {
                   dateJoined = dateOnlySdf.format(user.getCreatedDate());
               }
            %>
            <input type="text" value="<%= dateJoined %>" disabled>
          </div>
          <button type="submit" class="btn btn-primary">
            <i class="fa-solid fa-floppy-disk"></i> Save Changes
          </button>
        </form>
      </div>

      <div class="profile-main-card">
        <div class="pmc-title"><i class="fa-solid fa-lock"></i> Change Password</div>
        <form action="${pageContext.request.contextPath}/profile" method="post">
          <input type="hidden" name="name" value="<%= user != null ? user.getName() : "" %>">
          <input type="hidden" name="address" value="<%= user != null && user.getAddress() != null ? user.getAddress() : "" %>">
          <div class="form-row">
            <div class="form-group">
              <label for="newPassword">New Password</label>
              <input type="password" id="newPassword" name="newPassword" placeholder="Min. 6 characters" minlength="6">
            </div>
            <div class="form-group">
              <label for="confirmPassword">Confirm Password</label>
              <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password">
            </div>
          </div>
          <button type="submit" class="btn btn-outline">
            <i class="fa-solid fa-key"></i> Update Password
          </button>
        </form>
      </div>
      <div class="profile-main-card" id="order-history" style="margin-top: 2rem;">
        <div class="pmc-title"><i class="fa-solid fa-clock-rotate-left"></i> Order History</div>
        
        <% if (orders == null || orders.isEmpty()) { %>
          <div class="alert alert-info" style="background-color: #f8f9fa; border-left: 4px solid #3498db; padding: 15px; margin-top: 15px;">
            <i class="fa-solid fa-info-circle"></i> You haven't placed any orders yet.
          </div>
        <% } else { %>
          <div class="table-responsive" style="margin-top: 15px; overflow-x: auto;">
            <table class="table" style="width: 100%; border-collapse: collapse; text-align: left;">
              <thead>
                <tr style="background-color: #f4f6f8; border-bottom: 2px solid #e2e8f0;">
                  <th style="padding: 12px;">Order Details</th>
                  <th style="padding: 12px;">Items Ordered</th>
                  <th style="padding: 12px;">Payment & Delivery</th>
                  <th style="padding: 12px;">Amount & Status</th>
                </tr>
              </thead>
              <tbody>
                <% for (OrderTable o : orders) {
                     String statusColor = "#3b82f6"; // default blue
                     if ("Delivered".equalsIgnoreCase(o.getStatus())) statusColor = "#10b981"; // green
                     else if ("Cancelled".equalsIgnoreCase(o.getStatus())) statusColor = "#ef4444"; // red
                     else if ("Pending".equalsIgnoreCase(o.getStatus())) statusColor = "#f59e0b"; // orange
                     else if ("Preparing".equalsIgnoreCase(o.getStatus())) statusColor = "#8b5cf6"; // purple
                     
                     String orderDateStr = o.getOrderDate() != null ? sdf.format(o.getOrderDate()) : "N/A";
                     List<OrderItem> items = orderItemDAO != null ? orderItemDAO.getOrderItemsByOrderId(o.getOrderId()) : null;
                %>
                <tr style="border-bottom: 1px solid #e2e8f0;">
                  <td style="padding: 12px; vertical-align: top;">
                    <strong>#<%= o.getOrderId() %></strong><br>
                    <small style="color: #64748b;"><%= orderDateStr %></small>
                  </td>
                  <td style="padding: 12px; vertical-align: top;">
                    <ul style="margin: 0; padding-left: 15px; font-size: 0.9em;">
                      <% if (items != null && !items.isEmpty()) {
                           for (OrderItem item : items) {
                             Menu menu = menuDAO != null ? menuDAO.getMenuById(item.getMenuId()) : null;
                             String itemName = menu != null ? menu.getItemName() : "Item #" + item.getMenuId();
                      %>
                        <li><%= itemName %> <strong>x <%= item.getQuantity() %></strong></li>
                      <%   }
                         } else { %>
                        <li><em style="color: #94a3b8;">No items found</em></li>
                      <% } %>
                    </ul>
                  </td>
                  <td style="padding: 12px; vertical-align: top;">
                    <div><i class="fa-solid fa-wallet" style="color: #64748b;"></i> <%= o.getPaymentMethod() %></div>
                    <div style="font-size: 0.85em; color: #64748b; margin-top: 4px; max-width: 200px;">
                      <i class="fa-solid fa-location-dot"></i> <%= user != null && user.getAddress() != null && !user.getAddress().isEmpty() ? user.getAddress() : "Address not provided" %>
                    </div>
                  </td>
                  <td style="padding: 12px; vertical-align: top;">
                    <div style="font-weight: 600;">₹<%= o.getTotalAmount() %></div>
                    <div style="margin-top: 4px;">
                      <span style="display: inline-block; padding: 2px 8px; border-radius: 12px; font-size: 0.8em; font-weight: 500; background-color: <%= statusColor %>20; color: <%= statusColor %>;">
                        <%= o.getStatus() %>
                      </span>
                    </div>
                  </td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        <% } %>
      </div>
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
