<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Admin" %>
<%
    Admin currentAdminSidebar = (Admin) session.getAttribute("loggedInAdmin");
    String currentPage = request.getRequestURI();
%>
<aside class="admin-sidebar">
    <div class="sidebar-logo">
        <i class="fa-solid fa-leaf"></i>
        HungryBeee
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="sidebar-link <%= currentPage.contains("admin-dashboard") ? "active" : "" %>">
            <i class="fa-solid fa-chart-pie"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin-users" class="sidebar-link <%= currentPage.contains("admin-users") ? "active" : "" %>">
            <i class="fa-solid fa-users"></i> User Management
        </a>
        <a href="${pageContext.request.contextPath}/admin-restaurants" class="sidebar-link <%= currentPage.contains("admin-restaurants") ? "active" : "" %>">
            <i class="fa-solid fa-store"></i> Restaurant Management
        </a>
        <a href="${pageContext.request.contextPath}/admin-menu" class="sidebar-link <%= currentPage.contains("admin-menu") ? "active" : "" %>">
            <i class="fa-solid fa-utensils"></i> Menu Management
        </a>
        <a href="${pageContext.request.contextPath}/admin-orders" class="sidebar-link <%= currentPage.contains("admin-orders") ? "active" : "" %>">
            <i class="fa-solid fa-receipt"></i> Order Management
        </a>
        <a href="${pageContext.request.contextPath}/admin-payments" class="sidebar-link <%= currentPage.contains("admin-payments") ? "active" : "" %>">
            <i class="fa-solid fa-wallet"></i> Payments
        </a>
        <a href="${pageContext.request.contextPath}/admin-profile" class="sidebar-link <%= currentPage.contains("admin-profile") ? "active" : "" %>">
            <i class="fa-solid fa-user-shield"></i> Admin Profile
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="#" class="logout-btn" onclick="document.getElementById('logoutModal').classList.add('active'); return false;">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
    </div>
</aside>

<!-- Custom Logout Modal -->
<div id="logoutModal" class="admin-modal-overlay">
    <div class="admin-modal">
        <i class="fa-solid fa-arrow-right-from-bracket" style="font-size: 2.5rem; color: var(--danger); margin-bottom: 15px;"></i>
        <h3>Ready to Leave?</h3>
        <p>Are you sure you want to logout of the admin panel?</p>
        <div class="admin-modal-actions">
            <button class="btn-modal-cancel" onclick="document.getElementById('logoutModal').classList.remove('active');">Cancel</button>
            <a href="${pageContext.request.contextPath}/admin-logout" class="btn-modal-confirm" style="text-decoration: none; display: inline-block;">Yes, Logout</a>
        </div>
    </div>
</div>

<!-- Generic Delete Confirmation Modal -->
<div id="deleteConfirmModal" class="admin-modal-overlay">
    <div class="admin-modal">
        <i class="fa-solid fa-triangle-exclamation" style="font-size: 2.5rem; color: var(--danger); margin-bottom: 15px;"></i>
        <h3>Confirm Deletion</h3>
        <p id="deleteConfirmMsg">Are you sure you want to delete this?</p>
        <div class="admin-modal-actions">
            <button class="btn-modal-cancel" onclick="document.getElementById('deleteConfirmModal').classList.remove('active');">Cancel</button>
            <button id="deleteConfirmBtn" class="btn-modal-confirm" style="background: var(--danger);">Yes, Delete</button>
        </div>
    </div>
</div>

<script>
    function confirmAdminDelete(formElement, message) {
        document.getElementById('deleteConfirmMsg').innerText = message || 'Are you sure you want to delete this?';
        document.getElementById('deleteConfirmModal').classList.add('active');
        
        document.getElementById('deleteConfirmBtn').onclick = function() {
            formElement.submit();
        };
        return false;
    }
</script>
