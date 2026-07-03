<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Menu, com.tap.model.Restaurant, com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Hungry Bee Menu — Browse all available dishes and add to cart.">
  <title>Hungry Bee — Menu 🍕</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages.css">
</head>
<body>

<%@ include file="partials/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<Menu> menus = (List<Menu>) request.getAttribute("menus");

  @SuppressWarnings("unchecked")
  List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

  Restaurant selectedRestaurant = (Restaurant) request.getAttribute("selectedRestaurant");

  // Emoji map helper
  String[] foodEmojis = {"🍕","🍔","🍣","🍜","🍛","🍝","🌮","🥗","🍩","🍱","🥪","🍗"};
%>

<div class="page-wrapper">

  <!-- Breadcrumb -->
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>/</span>
    <% if (selectedRestaurant != null) { %>
      <a href="${pageContext.request.contextPath}/menu">Menu</a>
      <span>/</span>
      <span><%= selectedRestaurant.getName() %></span>
    <% } else { %>
      <span>Menu</span>
    <% } %>
  </div>

  <div class="menu-layout">

    <!-- ── SIDEBAR ── -->
    <aside class="menu-sidebar">
      <div class="sidebar-card">
        <div class="sidebar-title">🏪 Restaurants</div>
        <a href="${pageContext.request.contextPath}/menu" class="restaurant-filter-item <%= (selectedRestaurant == null) ? "active" : "" %>">
          <span class="rfi-icon">🍽️</span>
          <span class="rfi-name">All Restaurants</span>
        </a>
        <% if (restaurants != null) { for (Restaurant r : restaurants) {
            String isActive = (selectedRestaurant != null && selectedRestaurant.getRestaurantId() == r.getRestaurantId()) ? "active" : "";
        %>
        <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= r.getRestaurantId() %>"
           class="restaurant-filter-item <%= isActive %>">
          <span class="rfi-icon">🏪</span>
          <span class="rfi-name"><%= r.getName() %></span>
          <% if (r.isActive()) { %><span class="rfi-badge">Open</span><% } %>
        </a>
        <% } } %>
      </div>

      <div class="sidebar-card" style="margin-top:16px;">
        <div class="sidebar-title">🏷️ Categories</div>
        <a href="${pageContext.request.contextPath}/menu" class="restaurant-filter-item">
          <span class="rfi-icon">🍽️</span><span class="rfi-name">All Categories</span>
        </a>
        <a href="${pageContext.request.contextPath}/menu?category=Pizza" class="restaurant-filter-item">
          <span class="rfi-icon">🍕</span><span class="rfi-name">Pizza</span>
        </a>
        <a href="${pageContext.request.contextPath}/menu?category=Burger" class="restaurant-filter-item">
          <span class="rfi-icon">🍔</span><span class="rfi-name">Burgers</span>
        </a>
        <a href="${pageContext.request.contextPath}/menu?category=Sushi" class="restaurant-filter-item">
          <span class="rfi-icon">🍣</span><span class="rfi-name">Sushi</span>
        </a>
        <a href="${pageContext.request.contextPath}/menu?category=Chinese" class="restaurant-filter-item">
          <span class="rfi-icon">🍜</span><span class="rfi-name">Chinese</span>
        </a>
        <a href="${pageContext.request.contextPath}/menu?category=Indian" class="restaurant-filter-item">
          <span class="rfi-icon">🍛</span><span class="rfi-name">Indian</span>
        </a>
        <a href="${pageContext.request.contextPath}/menu?category=Dessert" class="restaurant-filter-item">
          <span class="rfi-icon">🍰</span><span class="rfi-name">Desserts</span>
        </a>
      </div>
    </aside>

    <!-- ── MAIN CONTENT ── -->
    <div>

      <!-- Restaurant banner (when filtered) -->
      <% if (selectedRestaurant != null) { %>
      <div class="restaurant-banner">
        <div class="rb-icon">🏪</div>
        <div class="rb-info">
          <div class="rb-name"><%= selectedRestaurant.getName() %></div>
          <div class="rb-cuisine"><%= selectedRestaurant.getCuisineType() %> · <%= selectedRestaurant.getAddress() %></div>
          <div class="rb-meta">
            <div class="rb-meta-item"><i class="fa-solid fa-star"></i> <%= selectedRestaurant.getRating() %></div>
            <div class="rb-meta-item"><i class="fa-solid fa-clock"></i> <%= selectedRestaurant.getDeliveryTime() %></div>
            <div class="rb-meta-item"><i class="fa-solid fa-circle" style="color:<%= selectedRestaurant.isActive() ? "#22c55e" : "#ef4444" %>;font-size:8px;"></i>
              <%= selectedRestaurant.isActive() ? "Open Now" : "Closed" %></div>
          </div>
        </div>
      </div>
      <% } %>

      <!-- Page header + search -->
      <div class="page-header" style="margin-bottom:20px;">
        <h1 class="page-title">
          <% if (selectedRestaurant != null) { %>
            <%= selectedRestaurant.getName() %>'s Menu
          <% } else { %>
            All Menu Items
          <% } %>
        </h1>
        <p class="page-subtitle">
          <%= (menus != null ? menus.size() : 0) %> items available
        </p>
      </div>

      <!-- Search -->
      <div class="menu-search-wrap">
        <i class="fa-solid fa-magnifying-glass si"></i>
        <input type="text" id="menuSearch" placeholder="Search dishes by name..." autocomplete="off">
      </div>

      <!-- Category chip filters -->
      <div class="cat-chips" id="catChips">
        <span class="cat-chip active" data-cat="all">🍽️ All</span>
        <span class="cat-chip" data-cat="pizza">🍕 Pizza</span>
        <span class="cat-chip" data-cat="burger">🍔 Burger</span>
        <span class="cat-chip" data-cat="sushi">🍣 Sushi</span>
        <span class="cat-chip" data-cat="chinese">🍜 Chinese</span>
        <span class="cat-chip" data-cat="indian">🍛 Indian</span>
        <span class="cat-chip" data-cat="dessert">🍰 Dessert</span>
      </div>

      <!-- Flash message -->
      <% if (request.getAttribute("added") != null) { %>
      <div class="alert alert-success" id="addedAlert">
        <i class="fa-solid fa-circle-check"></i> Item added to cart!
      </div>
      <% } %>

      <!-- Menu grid -->
      <div class="menu-grid" id="menuGrid">
        <% if (menus == null || menus.isEmpty()) { %>
        <div class="empty-state">
          <span class="es-icon">🍽️</span>
          <h3>No items found</h3>
          <p>Try selecting a different restaurant or category.</p>
          <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Browse All</a>
        </div>
        <% } else {
            int emojiIdx = 0;
            for (Menu m : menus) {
              String emoji = foodEmojis[emojiIdx % foodEmojis.length];
              emojiIdx++;
              String catLower = m.getCategory() != null ? m.getCategory().toLowerCase() : "";
              if (catLower.contains("pizza")) emoji = "🍕";
              else if (catLower.contains("burger")) emoji = "🍔";
              else if (catLower.contains("sushi")) emoji = "🍣";
              else if (catLower.contains("chinese") || catLower.contains("noodle")) emoji = "🍜";
              else if (catLower.contains("indian") || catLower.contains("curry")) emoji = "🍛";
              else if (catLower.contains("dessert") || catLower.contains("cake") || catLower.contains("sweet")) emoji = "🍰";
              else if (catLower.contains("pasta") || catLower.contains("italian")) emoji = "🍝";
              else if (catLower.contains("salad")) emoji = "🥗";
              else if (catLower.contains("chicken")) emoji = "🍗";
        %>
        <%
          String finalImageUrl = m.getImageUrl();
          boolean hasImage = (finalImageUrl != null && !finalImageUrl.trim().isEmpty());
          
          if (hasImage) {
            finalImageUrl = finalImageUrl.replace("\\", "/");
            if (finalImageUrl.startsWith("assets/")) {
                finalImageUrl = request.getContextPath() + "/" + finalImageUrl;
            }
          }
        %>
        <div class="menu-card" id="mc-<%= m.getMenuId() %>"
             data-name="<%= m.getItemName().toLowerCase() %>"
             data-cat="<%= catLower %>">
          <div class="menu-card-img">
            <% if (hasImage) { %>
              <img src="<%= finalImageUrl %>" alt="<%= m.getItemName() %>" style="width: 100%; height: 100%; object-fit: cover; position: absolute; top: 0; left: 0; z-index: 0;">
            <% } else { %>
              <%= emoji %>
            <% } %>
            <% if (m.isAvailable()) { %><span class="mc-avail-badge">✅ Available</span>
            <% } else { %><span class="mc-unavail-badge">❌ Unavailable</span><% } %>
          </div>
          <div class="menu-card-body">
            <div class="mc-name"><%= m.getItemName() %></div>
            <div class="mc-desc"><%= m.getDescription() != null ? m.getDescription() : "A delicious dish prepared with the finest ingredients." %></div>
            <div class="mc-footer">
              <div>
                <div class="mc-price">₹<%= m.getPrice() %></div>
                <div class="mc-cat"><%= m.getCategory() %></div>
              </div>
              <% if (m.isAvailable()) { %>
              <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="redirect" value="menu">
                <button type="submit" class="mc-add-btn" id="addBtn-<%= m.getMenuId() %>">
                  <i class="fa-solid fa-cart-plus"></i> Add
                </button>
              </form>
              <% } else { %>
              <button class="mc-add-btn" disabled>Unavailable</button>
              <% } %>
            </div>
          </div>
        </div>
        <% } } %>
      </div>
    </div>
  </div>
</div>

<%@ include file="partials/footer.jsp" %>

<script>
  // ── Navbar scroll ──
  const nb = document.getElementById('mainNavbar');
  if (nb) window.addEventListener('scroll', () => nb.classList.toggle('scrolled', scrollY > 10));

  // ── Live search ──
  document.getElementById('menuSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase().trim();
    document.querySelectorAll('.menu-card').forEach(c => {
      c.style.display = (!q || c.dataset.name.includes(q)) ? '' : 'none';
    });
  });

  // ── Category chip filter ──
  document.querySelectorAll('.cat-chip').forEach(chip => {
    chip.addEventListener('click', function() {
      document.querySelectorAll('.cat-chip').forEach(c => c.classList.remove('active'));
      this.classList.add('active');
      const cat = this.dataset.cat;
      document.querySelectorAll('.menu-card').forEach(c => {
        c.style.display = (cat === 'all' || c.dataset.cat.includes(cat)) ? '' : 'none';
      });
    });
  });

  // ── Animate cards on load ──
  document.querySelectorAll('.menu-card').forEach((c, i) => {
    c.style.opacity = '0';
    c.style.transform = 'translateY(20px)';
    c.style.transition = 'opacity .4s ease, transform .4s ease';
    setTimeout(() => { c.style.opacity = '1'; c.style.transform = 'translateY(0)'; }, i * 60);
  });

  // Auto-dismiss alert
  const alert = document.getElementById('addedAlert');
  if (alert) setTimeout(() => alert.remove(), 3000);
</script>
</body>
</html>
