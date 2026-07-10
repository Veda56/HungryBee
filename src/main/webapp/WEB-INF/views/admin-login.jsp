<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login - HungryBeee</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
</head>
<body class="admin-body">

    <div class="admin-login-container">
        <div class="admin-login-card">
            <h1>Admin Portal</h1>
            <p>Enter your credentials to access the dashboard</p>
            
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) { 
            %>
                <div class="admin-error">
                    <%= errorMessage %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin-login" method="post">
                <div class="admin-form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="admin@hungrybeee.com">
                </div>
                
                <div class="admin-form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="••••••••">
                </div>
                
                <button type="submit" class="btn-admin-primary">Login to Dashboard</button>
            </form>
        </div>
    </div>

</body>
</html>
