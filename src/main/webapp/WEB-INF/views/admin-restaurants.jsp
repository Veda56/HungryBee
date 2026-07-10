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
    <title>Restaurant Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
    <script>
        function filterRestaurants() {
            let input = document.getElementById("restSearch");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("restTable");
            let tr = table.getElementsByTagName("tr");
            
            for (let i = 1; i < tr.length; i++) {
                let tdName = tr[i].getElementsByTagName("td")[0];
                if (tdName) {
                    let txtValueName = tdName.textContent || tdName.innerText;
                    if (txtValueName.toUpperCase().indexOf(filter) > -1) {
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
                <div class="dashboard-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h2 class="dashboard-title">Restaurant Management</h2>
                        <div class="dashboard-subtitle">Manage partner restaurants and their status</div>
                    </div>
                    <button class="btn-admin-primary" onclick="document.getElementById('addRestModal').classList.add('active');" style="width: auto; padding: 10px 20px; display: flex; align-items: center; gap: 8px;">
                        <i class="fa-solid fa-plus"></i> Add Restaurant
                    </button>
                </div>

                <!-- Add Restaurant Modal -->
                <div id="addRestModal" class="admin-modal-overlay">
                    <div class="admin-modal" style="max-width: 500px; text-align: left;">
                        <h3 style="margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 10px;">Add New Restaurant</h3>
                        <form action="${pageContext.request.contextPath}/admin-restaurants" method="POST">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="admin-form-group">
                                <label>Restaurant Name</label>
                                <input type="text" name="name" required placeholder="e.g. Pizza Paradise">
                            </div>
                            
                            <div class="admin-form-group">
                                <label>Cuisine Type</label>
                                <input type="text" name="cuisine" required placeholder="e.g. Italian, Fast Food">
                            </div>
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="admin-form-group">
                                    <label>Delivery Time (mins)</label>
                                    <input type="number" name="deliveryTime" required placeholder="e.g. 30">
                                </div>
                                <div class="admin-form-group">
                                    <label>Admin User ID (Owner)</label>
                                    <input type="number" name="adminUserId" required placeholder="User ID">
                                </div>
                            </div>
                            
                            <div class="admin-form-group">
                                <label>Address</label>
                                <input type="text" name="address" required placeholder="Full address">
                            </div>
                            
                            <div class="admin-modal-actions" style="margin-top: 25px; justify-content: flex-end;">
                                <button type="button" class="btn-modal-cancel" onclick="document.getElementById('addRestModal').classList.remove('active');">Cancel</button>
                                <button type="submit" class="btn-admin-primary" style="margin: 0; width: auto; padding: 10px 20px;">Save Restaurant</button>
                            </div>
                        </form>
                    </div>
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
                            <input type="text" id="restSearch" onkeyup="filterRestaurants()" placeholder="Search by restaurant name...">
                        </div>
                    </div>
                    
                    <table class="admin-table" id="restTable">
                        <thead>
                            <tr>
                                <th>Restaurant Name</th>
                                <th>Cuisine</th>
                                <th>Delivery Time</th>
                                <th>Rating</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<com.tap.model.Restaurant> rests = (java.util.List<com.tap.model.Restaurant>) request.getAttribute("restaurantsList");
                                if (rests != null && !rests.isEmpty()) {
                                    for (com.tap.model.Restaurant r : rests) {
                            %>
                                        <tr>
                                            <td style="font-weight: 600;"><%= r.getName() %></td>
                                            <td><%= r.getCuisineType() %></td>
                                            <td><%= r.getDeliveryTime() %></td>
                                            <td><i class="fa-solid fa-star" style="color: var(--primary);"></i> <%= r.getRating() %></td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin-restaurants" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="toggle">
                                                    <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                                                    <button type="submit" style="background:none; border:none; cursor: pointer;">
                                                        <span class="status-badge <%= r.isActive() ? "status-delivered" : "status-cancelled" %>">
                                                            <%= r.isActive() ? "Active" : "Inactive" %>
                                                        </span>
                                                    </button>
                                                </form>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin-restaurants" method="POST" style="display:inline;" onsubmit="return confirmAdminDelete(this, 'Delete this restaurant? This will remove all associated menus and could orphan orders.');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                                                    <button type="submit" style="background:none; border:none; color: var(--danger); cursor: pointer; padding: 8px; border-radius: 4px;" title="Delete">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                            <% 
                                    }
                                } else { 
                            %>
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                            No restaurants found.
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
