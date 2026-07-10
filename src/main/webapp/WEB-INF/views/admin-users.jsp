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
    <title>User Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
    <script>
        function filterUsers() {
            let input = document.getElementById("userSearch");
            let filter = input.value.toUpperCase();
            let table = document.getElementById("usersTable");
            let tr = table.getElementsByTagName("tr");
            
            for (let i = 1; i < tr.length; i++) {
                let tdName = tr[i].getElementsByTagName("td")[1];
                let tdEmail = tr[i].getElementsByTagName("td")[2];
                if (tdName || tdEmail) {
                    let txtValueName = tdName.textContent || tdName.innerText;
                    let txtValueEmail = tdEmail.textContent || tdEmail.innerText;
                    if (txtValueName.toUpperCase().indexOf(filter) > -1 || txtValueEmail.toUpperCase().indexOf(filter) > -1) {
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
                        <h2 class="dashboard-title">User Management</h2>
                        <div class="dashboard-subtitle">Manage registered customers on your platform</div>
                    </div>
                </div>

                <% 
                    String successMsg = (String) session.getAttribute("successMsg");
                    String errorMsg = (String) session.getAttribute("errorMsg");
                    if(successMsg != null) { 
                %>
                    <div style="background: #d1fae5; color: #065f46; padding: 15px; border-radius: 8px; margin-bottom: 20px;"><%= successMsg %></div>
                <% session.removeAttribute("successMsg"); } %>
                
                <% if(errorMsg != null) { %>
                    <div class="admin-error"><%= errorMsg %></div>
                <% session.removeAttribute("errorMsg"); } %>

                <div class="dashboard-section">
                    <div class="section-header">
                        <div class="topbar-search" style="border: 1px solid var(--border); background: var(--bg-surface); margin:0;">
                            <i class="fa-solid fa-magnifying-glass" style="color: var(--text-muted)"></i>
                            <input type="text" id="userSearch" onkeyup="filterUsers()" placeholder="Search by name or email...">
                        </div>
                    </div>
                    
                    <table class="admin-table" id="usersTable">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Address</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<com.tap.model.User> users = (java.util.List<com.tap.model.User>) request.getAttribute("usersList");
                                if (users != null && !users.isEmpty()) {
                                    for (com.tap.model.User u : users) {
                            %>
                                        <tr>
                                            <td>#<%= u.getUserId() %></td>
                                            <td style="font-weight: 600;"><%= u.getName() %></td>
                                            <td><%= u.getEmail() %></td>
                                            <td><%= u.getRole() != null ? u.getRole() : "User" %></td>
                                            <td><%= u.getAddress() != null ? (u.getAddress().length() > 30 ? u.getAddress().substring(0, 30) + "..." : u.getAddress()) : "-" %></td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin-users" method="POST" style="display:inline;" onsubmit="return confirmAdminDelete(this, 'Are you sure you want to delete this user?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                    <button type="submit" style="background:none; border:none; color: var(--danger); cursor: pointer; padding: 8px; border-radius: 4px;" title="Delete User">
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
                                            No users found.
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
