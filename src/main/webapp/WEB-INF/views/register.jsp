<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hungry Bee - Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
</head>
<body>

    <div class="split-layout">
        <!-- Left Section: Brand Panel -->
        <div class="brand-panel">
            <div class="honeycomb-pattern"></div>
            <div class="brand-content">
                <div class="logo-large">🐝</div>
                <h2 class="brand-title">Hungry Bee</h2>
                <p class="brand-tagline">Buzzing food to your door 🍕</p>
            </div>
        </div>

        <!-- Right Section: Form Panel -->
        <div class="form-panel">
            <div class="form-header">
                <h1>Join the Hive 🐝</h1>
                <p>Create an account and start discovering delicious meals.</p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="post" class="auth-form">
                <input type="hidden" name="action" value="register">

                <%-- Show error message if registration fails --%>
                <% if (request.getAttribute("error") != null) { %>
                    <div style="background:#fee2e2;color:#b91c1c;border:1px solid #fca5a5;border-radius:8px;padding:10px 14px;margin-bottom:14px;font-size:0.9rem;">
                        ⚠️ <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <div class="input-group">
                    <label for="name">Full Name</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-user input-icon"></i>
                        <input type="text" id="name" name="name" placeholder="Enter your full name" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                </div>
                
                <div class="input-group">
                    <label for="phone">Phone Number</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-phone input-icon"></i>
                        <input type="tel" id="phone" name="phone" placeholder="Enter your phone number" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock input-icon"></i>
                        <input type="password" id="password" name="password" placeholder="Create a password" required>
                        <button type="button" class="toggle-password" onclick="togglePasswordVisibility('password', this)" aria-label="Toggle Password Visibility">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="input-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock input-icon"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                        <button type="button" class="toggle-password" onclick="togglePasswordVisibility('confirmPassword', this)" aria-label="Toggle Password Visibility">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="primary-btn">Save & Join the Hive</button>
            </form>

            <div class="form-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Log in</a></p>
            </div>
        </div>
    </div>

    <script>
        function togglePasswordVisibility(inputId, button) {
            const input = document.getElementById(inputId);
            const icon = button.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
</body>
</html>