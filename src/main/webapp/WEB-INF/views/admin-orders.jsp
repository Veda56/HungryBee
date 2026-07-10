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
    <title>Order Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
    <script>
        function filterOrders() {
            let input = document.getElementById("orderSearch");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("ordersTable");
            let tr = table.getElementsByTagName("tr");
            
            for (let i = 1; i < tr.length; i++) {
                let tdId = tr[i].getElementsByTagName("td")[0];
                let tdStatus = tr[i].getElementsByTagName("td")[5];
                if (tdId || tdStatus) {
                    let txtValueId = tdId.textContent || tdId.innerText;
                    let txtValueStatus = tdStatus.textContent || tdStatus.innerText;
                    if (txtValueId.toUpperCase().indexOf(filter) > -1 || txtValueStatus.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }       
            }
        }
    </script>
</head>
<body class="admin-body">
    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/partials/admin-sidebar.jsp" />
        <div class="admin-content-wrapper">
            <jsp:include page="/WEB-INF/views/partials/admin-topbar.jsp" />

            <main class="admin-main">
                <div class="dashboard-header">
                    <h2 class="dashboard-title">Order Management</h2>
                    <div class="dashboard-subtitle">Track and update customer order statuses</div>
                </div>

                <% 
                    String successMsg = (String) session.getAttribute("successMsg");
                    String errorMsg = (String) session.getAttribute("errorMsg");
                    if(successMsg != null) { 
                %>
                    <div style="background: #d1fae5; color: #065f46; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #10b981;"><%= successMsg %></div>
                <% session.removeAttribute("successMsg"); } %>
                
                <% if(errorMsg != null) { %>
                    <div class="admin-error"><%= errorMsg %></div>
                <% session.removeAttribute("errorMsg"); } %>

                <div class="dashboard-section">
                    <div class="section-header">
                        <div class="topbar-search" style="border: 1px solid var(--border); background: var(--bg-surface); margin:0;">
                            <i class="fa-solid fa-magnifying-glass" style="color: var(--text-muted)"></i>
                            <input type="text" id="orderSearch" onkeyup="filterOrders()" placeholder="Search by Order ID or Status...">
                        </div>
                    </div>
                    
                    <table class="admin-table" id="ordersTable">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>User ID</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Payment</th>
                                <th>Status & Update</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<com.tap.model.OrderTable> orders = (java.util.List<com.tap.model.OrderTable>) request.getAttribute("ordersList");
                                if (orders != null && !orders.isEmpty()) {
                                    for (com.tap.model.OrderTable o : orders) {
                            %>
                                        <tr>
                                            <td style="font-weight: 600;">#<%= o.getOrderId() %></td>
                                            <td>User #<%= o.getUserId() %></td>
                                            <td><%= o.getOrderDate() %></td>
                                            <td style="font-weight: 600;">₹<%= o.getTotalAmount() %></td>
                                            <td><%= o.getPaymentMethod() %></td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin-orders" method="POST" style="display: flex; align-items: center; gap: 10px;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                                    
                                                    <% String currentStatus = o.getStatus() != null ? o.getStatus() : "Pending"; %>
                                                    <select name="status" style="padding: 6px; border-radius: 6px; border: 1px solid var(--border); font-family: inherit;">
                                                        <option value="Pending" <%= "Pending".equals(currentStatus) ? "selected" : "" %>>Pending</option>
                                                        <option value="Accepted" <%= "Accepted".equals(currentStatus) ? "selected" : "" %>>Accepted</option>
                                                        <option value="Preparing" <%= "Preparing".equals(currentStatus) ? "selected" : "" %>>Preparing</option>
                                                        <option value="Out for Delivery" <%= "Out for Delivery".equals(currentStatus) ? "selected" : "" %>>Out for Delivery</option>
                                                        <option value="Delivered" <%= "Delivered".equals(currentStatus) ? "selected" : "" %>>Delivered</option>
                                                        <option value="Cancelled" <%= "Cancelled".equals(currentStatus) ? "selected" : "" %>>Cancelled</option>
                                                    </select>
                                                    
                                                    <button type="submit" class="btn-admin-primary" style="padding: 6px 12px; margin: 0; width: auto; font-size: 0.85rem;">Update</button>
                                                </form>
                                            </td>
                                        </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                            No orders found.
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
