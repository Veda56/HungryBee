<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Admin" %>
<%
    Admin currentAdminTopbar = (Admin) session.getAttribute("loggedInAdmin");
    String adminInitial = currentAdminTopbar != null && currentAdminTopbar.getAdminName() != null && !currentAdminTopbar.getAdminName().isEmpty() ? 
                          currentAdminTopbar.getAdminName().substring(0, 1).toUpperCase() : "A";
%>
<header class="admin-topbar">
    <div class="topbar-search">
        <i class="fa-solid fa-magnifying-glass" style="color: var(--text-muted)"></i>
        <input type="text" placeholder="Search...">
    </div>
    <div class="topbar-profile">
        <div class="profile-name">Hello, <%= currentAdminTopbar != null ? currentAdminTopbar.getAdminName() : "Admin" %></div>
        <div class="profile-avatar">
            <%= adminInitial %>
        </div>
    </div>
</header>
