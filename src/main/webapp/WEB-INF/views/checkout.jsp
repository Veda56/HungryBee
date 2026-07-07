<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.math.BigDecimal, com.tap.model.CartItem, com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hungry Bee — Checkout 💳</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  User user = (User) session.getAttribute("user");
  BigDecimal subtotal    = (BigDecimal) request.getAttribute("subtotal");
  BigDecimal deliveryFee = (BigDecimal) request.getAttribute("deliveryFee");
  BigDecimal taxes       = (BigDecimal) request.getAttribute("taxes");
  BigDecimal grandTotal  = (BigDecimal) request.getAttribute("grandTotal");


  int itemCount = 0;
  if (cart != null) {
    for (CartItem item : cart.values()) itemCount += item.getQuantity();
  }

  String defaultAddress = (user != null && user.getAddress() != null && !user.getAddress().isEmpty())
                          ? user.getAddress() : "";
%>

<div class="page-wrapper">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>/</span>
    <a href="${pageContext.request.contextPath}/cart">Cart</a>
    <span>/</span>
    <span>Checkout</span>
  </div>

  <div class="page-header">
    <h1 class="page-title">Checkout 💳</h1>
    <p class="page-subtitle">Complete your order in a few simple steps</p>
  </div>

  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-error">
    <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <div class="checkout-layout">
    <div>
      <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="post">
        <!-- Hidden input to pass coupon to backend -->
        <input type="hidden" id="appliedCoupon" name="coupon" value="">
        
        <div class="checkout-form-card">
          <div class="cf-section-title"><i class="fa-solid fa-location-dot"></i> Delivery Details</div>
          <div class="form-row">
            <div class="form-group">
              <label for="fullName">Full Name</label>
              <input type="text" id="fullName" name="fullName"
                     value="<%= user != null ? user.getName() : "" %>" required>
            </div>
            <div class="form-group">
              <label for="phone">Phone Number</label>
              <input type="tel" id="phone" name="phone" placeholder="10-digit mobile number" required>
            </div>
          </div>
          <div class="form-group">
            <label for="deliveryAddress">Delivery Address</label>
            <textarea id="deliveryAddress" name="deliveryAddress" placeholder="House no., street, city, pin code..." required><%= defaultAddress %></textarea>
          </div>
        </div>

        <div class="checkout-form-card">
          <div class="cf-section-title"><i class="fa-solid fa-wallet"></i> Payment Method</div>
          <div class="payment-options">
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="Cash" checked>
              <span class="po-icon">💵</span>
              <div>
                <div class="po-label">Cash on Delivery</div>
                <div class="po-desc">Pay when your order arrives</div>
              </div>
            </label>
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="UPI">
              <span class="po-icon">📱</span>
              <div>
                <div class="po-label">UPI</div>
                <div class="po-desc">Google Pay, PhonePe, Paytm</div>
              </div>
            </label>
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="Card">
              <span class="po-icon">💳</span>
              <div>
                <div class="po-label">Credit / Debit Card</div>
                <div class="po-desc">Visa, Mastercard, RuPay</div>
              </div>
            </label>
          </div>
        </div>

        <button type="submit" class="btn btn-primary btn-lg">
          <i class="fa-solid fa-check"></i> Place Order — ₹<%= grandTotal %>
        </button>
      </form>
    </div>

    <div class="order-summary-card">
      <div class="os-title">Order Summary (<%= itemCount %> items)</div>
      <% if (cart != null) {
           for (CartItem item : cart.values()) { %>
      <div class="os-row">
        <span><%= item.getMenu().getItemName() %> × <%= item.getQuantity() %></span>
        <span class="os-val">₹<%= item.getSubtotal() %></span>
      </div>
      <%   }
         } %>
      <hr class="os-divider">
      <div class="os-row"><span>Subtotal</span><span class="os-val">₹<%= subtotal %></span></div>
      <div class="os-row" id="deliveryFeeRow">
        <span>Delivery Fee</span>
        <span class="os-val" id="deliveryFeeDisplay">₹<%= deliveryFee %></span>
      </div>
      <div class="os-row"><span>Taxes (5%)</span><span class="os-val">₹<%= taxes %></span></div>
      <div class="os-row total"><span>Total</span><span class="os-val" id="grandTotalDisplay">₹<%= grandTotal %></span></div>
      
      <!-- Coupon Section -->
      <div class="coupon-section" style="margin-top: 20px; padding-top: 20px; border-top: 1px dashed #cbd5e1;">
        <label for="couponCode" style="display: block; font-weight: 600; font-size: 0.9rem; color: #334155; margin-bottom: 8px;">Have a Coupon?</label>
        <div style="display: flex; gap: 8px;">
          <input type="text" id="couponCode" placeholder="Enter FREEDELIVERY" style="flex: 1; padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 8px; text-transform: uppercase;">
          <button type="button" id="applyCouponBtn" class="btn btn-outline" style="padding: 10px 16px;">Apply</button>
        </div>
        <div id="couponMsg" style="margin-top: 8px; font-size: 0.85rem; font-weight: 500;"></div>
      </div>
    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const applyBtn = document.getElementById('applyCouponBtn');
    const couponInput = document.getElementById('couponCode');
    const msgDiv = document.getElementById('couponMsg');
    const deliveryDisplay = document.getElementById('deliveryFeeDisplay');
    const grandTotalDisplay = document.getElementById('grandTotalDisplay');
    const submitBtn = document.querySelector('button[type="submit"]');
    const hiddenCouponInput = document.getElementById('appliedCoupon');
    
    // Store original values (passed from JSP)
    const originalDeliveryFee = <%= deliveryFee %>;
    const originalGrandTotal = <%= grandTotal %>;
    let isCouponApplied = false;

    applyBtn.addEventListener('click', function() {
      const code = couponInput.value.trim().toUpperCase();
      
      if (code === 'FREEDELIVERY') {
        if (!isCouponApplied) {
          isCouponApplied = true;
          hiddenCouponInput.value = 'FREEDELIVERY';
          
          // Update UI
          deliveryDisplay.innerHTML = `<span style="text-decoration: line-through; color: #94a3b8; margin-right: 8px;">₹${originalDeliveryFee}</span><span style="color: #10b981;">FREE</span>`;
          const newTotal = (originalGrandTotal - originalDeliveryFee).toFixed(2);
          grandTotalDisplay.innerText = '₹' + newTotal;
          
          // Update main button text
          submitBtn.innerHTML = `<i class="fa-solid fa-check"></i> Place Order — ₹${newTotal}`;
          
          // Show success msg
          msgDiv.style.color = '#10b981';
          msgDiv.innerText = '✨ Free delivery applied!';
          
          // Disable input
          couponInput.disabled = true;
          applyBtn.innerText = 'Applied';
          applyBtn.disabled = true;
        }
      } else if (code === '') {
        msgDiv.style.color = '#ef4444';
        msgDiv.innerText = 'Please enter a coupon code.';
      } else {
        msgDiv.style.color = '#ef4444';
        msgDiv.innerText = 'Invalid coupon code. Try FREEDELIVERY.';
      }
    });
  });
</script>

<%@ include file="partials/footer.jsp" %>

<script>
  const nb = document.getElementById('mainNavbar');
  if (nb) window.addEventListener('scroll', () => nb.classList.toggle('scrolled', scrollY > 10));
</script>
</body>
</html>
