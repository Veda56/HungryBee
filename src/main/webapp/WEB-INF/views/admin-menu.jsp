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
    <title>Menu Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
    <script>
        function filterMenus() {
            let input = document.getElementById("menuSearch");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("menuTable");
            let tr = table.getElementsByTagName("tr");
            
            for (let i = 1; i < tr.length; i++) {
                let tdName = tr[i].getElementsByTagName("td")[0];
                let tdCategory = tr[i].getElementsByTagName("td")[3];
                if (tdName || tdCategory) {
                    let txtValueName = tdName.textContent || tdName.innerText;
                    let txtValueCategory = tdCategory.textContent || tdCategory.innerText;
                    if (txtValueName.toUpperCase().indexOf(filter) > -1 || txtValueCategory.toUpperCase().indexOf(filter) > -1) {
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
                        <h2 class="dashboard-title">Menu Management</h2>
                        <div class="dashboard-subtitle">Manage food items across all restaurants</div>
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
                            <input type="text" id="menuSearch" onkeyup="filterMenus()" placeholder="Search by item name or category...">
                        </div>
                    </div>
                    
                    <table class="admin-table" id="menuTable">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th>Restaurant ID</th>
                                <th>Price</th>
                                <th>Category</th>
                                <th>Availability</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<com.tap.model.Menu> menus = (java.util.List<com.tap.model.Menu>) request.getAttribute("menusList");
                                if (menus != null && !menus.isEmpty()) {
                                    for (com.tap.model.Menu m : menus) {
                            %>
                                        <tr>
                                            <td style="font-weight: 600;"><%= m.getItemName() %></td>
                                            <td>Rest. #<%= m.getRestaurantId() %></td>
                                            <td style="font-weight: 600;">₹<%= m.getPrice() %></td>
                                            <td><%= m.getCategory() != null ? m.getCategory() : "Uncategorized" %></td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin-menu" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="toggle">
                                                    <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                                    <button type="submit" style="background:none; border:none; cursor: pointer;">
                                                        <span class="status-badge <%= m.isAvailable() ? "status-delivered" : "status-cancelled" %>">
                                                            <%= m.isAvailable() ? "Available" : "Unavailable" %>
                                                        </span>
                                                    </button>
                                                </form>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin-menu" method="POST" style="display:inline;" onsubmit="return confirmAdminDelete(this, 'Delete this menu item?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
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
                                            No menu items found.
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
