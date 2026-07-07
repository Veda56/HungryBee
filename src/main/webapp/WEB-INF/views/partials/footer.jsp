<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">

            <!-- Brand column -->
            <div class="footer-brand">
                <div class="footer-logo">🐝 Hungry Bee</div>
                <p>Fresh, delicious food delivered buzzing fast to your doorstep. Taste the joy in every bite.</p>
                <div class="footer-social">
                    <div class="social-btn" title="Facebook">📘</div>
                    <div class="social-btn" title="Instagram">📸</div>
                    <div class="social-btn" title="Twitter">🐦</div>
                    <div class="social-btn" title="YouTube">▶️</div>
                </div>
            </div>

            <!-- Quick links -->
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Menu</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">My Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders">My Orders</a></li>
                </ul>
            </div>

            <!-- Cuisine links -->
            <div class="footer-col">
                <h4>Cuisines</h4>
                <ul>
                    <li><a href="#">Pizza 🍕</a></li>
                    <li><a href="#">Burgers 🍔</a></li>
                    <li><a href="#">Sushi 🍣</a></li>
                    <li><a href="#">Indian 🍛</a></li>
                </ul>
            </div>

            <!-- Support -->
            <div class="footer-col">
                <h4>Support</h4>
                <ul>
                    <li><a href="#">Help Center</a></li>
                    <li><a href="#">Track Order</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <span>🐝 &copy; 2026 Hungry Bee — Fresh food delivered with happiness 🍕</span>
            <span>Made with ❤️ for food lovers</span>
        </div>
    </div>
</footer>

<!-- SweetAlert2 for beautiful popups -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .emotional-bee {
        font-size: 3.5rem;
        display: inline-block;
        margin-bottom: 5px;
        filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1));
    }
</style>
<script>
    function confirmLogout(event, url) {
        event.preventDefault(); // Stop default navigation
        Swal.fire({
            title: 'Leaving the hive?',
            html: '<div class="emotional-bee" id="beeEmoji">🥺</div><br><span style="font-size: 1.1rem; color: #64748b;">The hive feels so empty without you... Are you sure you want to fly away?</span>',
            showCancelButton: true,
            confirmButtonColor: '#e74c3c', // Red for logout
            cancelButtonColor: '#f59e0b', // Yellow/Honey color for staying
            confirmButtonText: 'Yes, let me fly away!',
            cancelButtonText: 'No, I want to stay 💛',
            reverseButtons: true // Puts the primary action (staying) on the right
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
        return false;
    }
</script>