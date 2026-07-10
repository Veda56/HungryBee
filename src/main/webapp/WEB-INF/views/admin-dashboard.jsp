<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Admin" %>
<%
    Admin admin = (Admin) session.getAttribute("loggedInAdmin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - HungryBeee</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
</head>
<body class="admin-body">
    <div class="admin-layout">
        
        <jsp:include page="/WEB-INF/views/partials/admin-sidebar.jsp" />

        <div class="admin-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/partials/admin-topbar.jsp" />

            <main class="admin-main">
                <div class="dashboard-header">
                    <h2 class="dashboard-title">Dashboard Overview</h2>
                    <div class="dashboard-subtitle">Monitor your platform's performance today</div>
                </div>
                
                <div class="admin-stats-grid">
                    <div class="stat-card" style="animation-delay: 0.1s;">
                        <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Total Users</div>
                            <div class="stat-value"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></div>
                        </div>
                    </div>
                    
                    <div class="stat-card" style="animation-delay: 0.2s;">
                        <div class="stat-icon"><i class="fa-solid fa-store"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Restaurants</div>
                            <div class="stat-value"><%= request.getAttribute("totalRestaurants") != null ? request.getAttribute("totalRestaurants") : 0 %></div>
                        </div>
                    </div>

                    <div class="stat-card" style="animation-delay: 0.3s;">
                        <div class="stat-icon"><i class="fa-solid fa-hamburger"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Food Items</div>
                            <div class="stat-value"><%= request.getAttribute("totalMenu") != null ? request.getAttribute("totalMenu") : 0 %></div>
                        </div>
                    </div>
                    
                    <div class="stat-card" style="animation-delay: 0.4s;">
                        <div class="stat-icon"><i class="fa-solid fa-receipt"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Total Orders</div>
                            <div class="stat-value"><%= request.getAttribute("totalOrders") != null ? request.getAttribute("totalOrders") : 0 %></div>
                        </div>
                    </div>

                    <div class="stat-card" style="grid-column: span 2; animation-delay: 0.5s;">
                        <div class="stat-icon"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Total Revenue</div>
                            <div class="stat-value" style="color: var(--primary);">₹<%= request.getAttribute("totalRevenue") != null ? request.getAttribute("totalRevenue") : "0.00" %></div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Orders Section -->
                <div class="dashboard-section">
                    <div class="section-header">
                        <h3>Recent Orders</h3>
                        <a href="${pageContext.request.contextPath}/admin-orders" class="view-all-link">View All</a>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Total Amount</th>
                                <th>Payment</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<com.tap.model.OrderTable> recentOrders = (java.util.List<com.tap.model.OrderTable>) request.getAttribute("recentOrders");
                                if (recentOrders != null && !recentOrders.isEmpty()) {
                                    int count = 0;
                                    for (com.tap.model.OrderTable order : recentOrders) {
                                        if (count >= 5) break;
                                        count++;
                            %>
                                        <tr>
                                            <td>#<%= order.getOrderId() %></td>
                                            <td><%= order.getOrderDate() %></td>
                                            <td>₹<%= order.getTotalAmount() %></td>
                                            <td><%= order.getPaymentMethod() %></td>
                                            <td>
                                                <% 
                                                    String status = order.getStatus();
                                                    String badgeClass = "status-pending";
                                                    if ("Delivered".equalsIgnoreCase(status)) badgeClass = "status-delivered";
                                                    else if ("Cancelled".equalsIgnoreCase(status)) badgeClass = "status-cancelled";
                                                %>
                                                <span class="status-badge <%= badgeClass %>">
                                                    <%= status != null ? status : "Pending" %>
                                                </span>
                                            </td>
                                        </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                            No recent orders found.
                                        </td>
                                    </tr>
                            <% 
                                } 
                            %>
                        </tbody>
                    </table>
                </div>

            </main>
        </div>
    </div>
</body>
</html>
