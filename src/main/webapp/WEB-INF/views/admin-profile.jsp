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
    <title>Admin Profile - HungryBeee</title>
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
                    <h2 class="dashboard-title">Admin Profile</h2>
                    <div class="dashboard-subtitle">Manage your account settings</div>
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

                <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 30px;">
                    <!-- Profile Info -->
                    <div class="dashboard-section" style="align-self: start;">
                        <div style="text-align: center; padding: 20px 0;">
                            <div style="width: 100px; height: 100px; border-radius: 50%; background: #fef3c7; color: var(--primary-hover); font-size: 3rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px auto; border: 4px solid #fde68a;">
                                <%= admin.getAdminName().substring(0,1).toUpperCase() %>
                            </div>
                            <h3 style="margin: 0; font-size: 1.5rem; color: var(--text-main);"><%= admin.getAdminName() %></h3>
                            <p style="color: var(--text-muted); margin-top: 5px;"><%= admin.getEmail() %></p>
                            <div style="margin-top: 20px; display: inline-block; padding: 5px 15px; background: #e0e7ff; color: #4f46e5; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">Super Admin</div>
                        </div>
                    </div>

                    <!-- Change Password -->
                    <div class="dashboard-section">
                        <div class="section-header">
                            <h3>Change Password</h3>
                        </div>
                        <div style="padding: 20px;">
                            <form action="${pageContext.request.contextPath}/admin-profile" method="POST">
                                <input type="hidden" name="action" value="changePassword">
                                
                                <div class="admin-form-group">
                                    <label>Current Password</label>
                                    <input type="password" name="currentPassword" required placeholder="Enter current password">
                                </div>
                                
                                <div class="admin-form-group">
                                    <label>New Password</label>
                                    <input type="password" name="newPassword" required placeholder="Min. 6 characters">
                                </div>
                                
                                <div class="admin-form-group">
                                    <label>Confirm New Password</label>
                                    <input type="password" name="confirmPassword" required placeholder="Re-enter new password">
                                </div>
                                
                                <div style="margin-top: 30px;">
                                    <button type="submit" class="btn-admin-primary" style="width: auto; padding: 12px 30px;">Update Password</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
