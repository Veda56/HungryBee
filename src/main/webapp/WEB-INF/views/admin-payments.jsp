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
    <title>Payments - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
    <script>
        function filterPayments() {
            let input = document.getElementById("paySearch");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("payTable");
            let tr = table.getElementsByTagName("tr");
            
            for (let i = 1; i < tr.length; i++) {
                let tdId = tr[i].getElementsByTagName("td")[0];
                if (tdId) {
                    let txtValueId = tdId.textContent || tdId.innerText;
                    if (txtValueId.toUpperCase().indexOf(filter) > -1) {
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
                    <h2 class="dashboard-title">Payment Management</h2>
                    <div class="dashboard-subtitle">Track revenue and payment history</div>
                </div>

                <div class="admin-stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: #d1fae5; color: #059669;"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Total Earnings</div>
                            <div class="stat-value" style="color: #059669;">₹<%= request.getAttribute("totalEarnings") %></div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon" style="background: #e0e7ff; color: #4f46e5;"><i class="fa-solid fa-credit-card"></i></div>
                        <div class="stat-info">
                            <div class="stat-title">Successful Payments</div>
                            <div class="stat-value"><%= request.getAttribute("successfulPayments") %></div>
                        </div>
                    </div>
                </div>

                <div class="dashboard-section">
                    <div class="section-header">
                        <div class="topbar-search" style="border: 1px solid var(--border); background: var(--bg-surface); margin:0;">
                            <i class="fa-solid fa-magnifying-glass" style="color: var(--text-muted)"></i>
                            <input type="text" id="paySearch" onkeyup="filterPayments()" placeholder="Search by Order ID...">
                        </div>
                    </div>
                    
                    <table class="admin-table" id="payTable">
                        <thead>
                            <tr>
                                <th>Transaction/Order ID</th>
                                <th>Date</th>
                                <th>Payment Method</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<com.tap.model.OrderTable> payments = (java.util.List<com.tap.model.OrderTable>) request.getAttribute("paymentHistory");
                                if (payments != null && !payments.isEmpty()) {
                                    for (com.tap.model.OrderTable p : payments) {
                            %>
                                        <tr>
                                            <td style="font-weight: 600;">#<%= p.getOrderId() %></td>
                                            <td><%= p.getOrderDate() %></td>
                                            <td>
                                                <i class="fa-solid fa-money-bill-wave" style="color: var(--text-muted); margin-right: 5px;"></i> 
                                                <%= p.getPaymentMethod() %>
                                            </td>
                                            <td style="font-weight: 600; color: #059669;">+₹<%= p.getTotalAmount() %></td>
                                            <td>
                                                <% 
                                                    String status = p.getStatus();
                                                    String badgeClass = "status-delivered"; // Default green for successful payment intent
                                                    if ("Cancelled".equalsIgnoreCase(status)) badgeClass = "status-cancelled";
                                                    else if ("Pending".equalsIgnoreCase(status)) badgeClass = "status-pending";
                                                %>
                                                <span class="status-badge <%= badgeClass %>">
                                                    <%= "Cancelled".equalsIgnoreCase(status) ? "Refunded/Failed" : ("Pending".equalsIgnoreCase(status) ? "Pending" : "Completed") %>
                                                </span>
                                            </td>
                                        </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                            No payment history found.
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
