<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Hungry Bee — Fresh, delicious food delivered buzzing fast to your door. Browse top restaurants and order now.">
    <title>Hungry Bee — Home 🐝</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>

<%-- ═══════════ NAVBAR (partial) ═══════════ --%>
<%@ include file="partials/header.jsp" %>

<%-- ═══════════════════════════════════════
     HERO SECTION
═══════════════════════════════════════ --%>
<section class="hero" id="heroSection">
    <div class="hero-inner">

        <!-- Text content -->
        <div class="hero-text">
            <div class="hero-badge" id="heroBadge">
                🐝 &nbsp;Now delivering near you
            </div>

            <h1 class="hero-title">
                Craving something <span class="highlight">delicious?</span><br>We've got you.
            </h1>

            <p class="hero-desc">
                From crispy pizzas to sizzling burgers — explore hundreds of restaurants
                and get fresh food delivered right to your doorstep.
            </p>

            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/menu" class="btn-primary" id="heroOrderBtn">
                    <i class="fa-solid fa-bolt"></i> Order Now
                </a>
                <a href="#restaurants" class="btn-secondary" id="heroExploreBtn">
                    <i class="fa-solid fa-compass"></i> Explore Restaurants
                </a>
            </div>

            <!-- Quick stats -->
            <div class="hero-stats">
                <div class="stat-item">
                    <div class="stat-value" id="statRestaurants">50+</div>
                    <div class="stat-label">Restaurants</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">500+</div>
                    <div class="stat-label">Menu Items</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">30 min</div>
                    <div class="stat-label">Avg. Delivery</div>
                </div>
            </div>
        </div>

        <!-- Decorative visual -->
        <div class="hero-visual" id="heroVisual">
            <div class="hero-blob">🍕</div>

            <!-- Floating badges -->
            <div class="hero-float-badge badge-1" id="floatBadge1">
                <span class="float-icon">⭐</span>
                <div class="float-text">
                    <div class="label">Top Rated</div>
                    <div class="value">4.9 / 5.0</div>
                </div>
            </div>
            <div class="hero-float-badge badge-2" id="floatBadge2">
                <span class="float-icon">🛵</span>
                <div class="float-text">
                    <div class="label">Delivery</div>
                    <div class="value">25–35 min</div>
                </div>
            </div>
        </div>

    </div>
</section>

<%-- ═══════════════════════════════════════
     FOOD CATEGORIES
═══════════════════════════════════════ --%>
<div class="section" id="categoriesSection">
    <div class="section-header">
        <div>
            <h2 class="section-title">What are you craving?</h2>
            <p class="section-subtitle">Pick a category to find your perfect meal</p>
        </div>
    </div>

    <div class="categories-grid" id="categoriesGrid">
        <div class="category-card active" id="catAll" onclick="filterCategory('all', this)">
            <div class="cat-icon">🍽️</div>
            <div class="cat-name">All</div>
            <div class="cat-count">Everything</div>
        </div>
        <div class="category-card" id="catPizza" onclick="filterCategory('pizza', this)">
            <div class="cat-icon">🍕</div>
            <div class="cat-name">Pizza</div>
            <div class="cat-count">Hot &amp; Fresh</div>
        </div>
        <div class="category-card" id="catBurger" onclick="filterCategory('burger', this)">
            <div class="cat-icon">🍔</div>
            <div class="cat-name">Burgers</div>
            <div class="cat-count">Juicy</div>
        </div>
        <div class="category-card" id="catSushi" onclick="filterCategory('sushi', this)">
            <div class="cat-icon">🍣</div>
            <div class="cat-name">Sushi</div>
            <div class="cat-count">Japanese</div>
        </div>
        <div class="category-card" id="catChinese" onclick="filterCategory('chinese', this)">
            <div class="cat-icon">🍜</div>
            <div class="cat-name">Chinese</div>
            <div class="cat-count">Noodles</div>
        </div>
        <div class="category-card" id="catIndian" onclick="filterCategory('indian', this)">
            <div class="cat-icon">🍛</div>
            <div class="cat-name">Indian</div>
            <div class="cat-count">Spicy</div>
        </div>
        <div class="category-card" id="catItalian" onclick="filterCategory('italian', this)">
            <div class="cat-icon">🍝</div>
            <div class="cat-name">Italian</div>
            <div class="cat-count">Pasta</div>
        </div>
        <div class="category-card" id="catDessert" onclick="filterCategory('dessert', this)">
            <div class="cat-icon">🍰</div>
            <div class="cat-name">Desserts</div>
            <div class="cat-count">Sweet</div>
        </div>
    </div>
</div>

<%-- ═══════════════════════════════════════
     RESTAURANTS LISTING
═══════════════════════════════════════ --%>
<div class="section" id="restaurants">
    <div class="section-header">
        <div>
            <h2 class="section-title">Popular Restaurants</h2>
            <p class="section-subtitle">Handpicked restaurants loved by the community</p>
        </div>
        <a href="${pageContext.request.contextPath}/menu" class="section-link" id="viewAllRestaurants">
            View all <i class="fa-solid fa-arrow-right"></i>
        </a>
    </div>

    <div class="restaurants-grid" id="restaurantsGrid">

        <%
            @SuppressWarnings("unchecked")
            List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

            if (restaurants != null && !restaurants.isEmpty()) {
                for (Restaurant r : restaurants) {
                    String cuisine = r.getCuisineType() != null ? r.getCuisineType().toLowerCase() : "default";
                    String cuisineClass = "default";
                    String cuisineEmoji = "🍽️";

                    if (cuisine.contains("pizza") || cuisine.contains("italian")) {
                        cuisineClass = "pizza"; cuisineEmoji = "🍕";
                    } else if (cuisine.contains("burger") || cuisine.contains("american")) {
                        cuisineClass = "burger"; cuisineEmoji = "🍔";
                    } else if (cuisine.contains("sushi") || cuisine.contains("japanese")) {
                        cuisineClass = "sushi"; cuisineEmoji = "🍣";
                    } else if (cuisine.contains("chinese")) {
                        cuisineClass = "chinese"; cuisineEmoji = "🍜";
                    } else if (cuisine.contains("indian")) {
                        cuisineClass = "indian"; cuisineEmoji = "🍛";
                    } else if (cuisine.contains("dessert") || cuisine.contains("cake")) {
                        cuisineClass = "dessert"; cuisineEmoji = "🍰";
                    }

                    String statusClass = r.isActive() ? "open" : "closed";
                    String statusText  = r.isActive() ? "✅ Open" : "❌ Closed";

                    String rating = (r.getRating() != null) ? r.getRating().toString() : "N/A";
                    String delivery = (r.getDeliveryTime() != null && !r.getDeliveryTime().isEmpty())
                                     ? r.getDeliveryTime() : "30 min";
        %>
        <div class="restaurant-card" id="rest-<%= r.getRestaurantId() %>"
             data-cuisine="<%= cuisine %>"
             onclick="window.location='${pageContext.request.contextPath}/menu?restaurantId=<%= r.getRestaurantId() %>'">

            <div class="card-image <%= cuisineClass %>">
                <%= cuisineEmoji %>
                <span class="card-badge <%= statusClass %>"><%= statusText %></span>
            </div>

            <div class="card-body">
                <div class="card-header-row">
                    <h3 class="card-name"><%= r.getName() %></h3>
                    <div class="card-rating">⭐ <%= rating %></div>
                </div>

                <div class="card-cuisine">
                    <i class="fa-solid fa-tag" style="color:var(--primary);margin-right:5px;"></i>
                    <%= r.getCuisineType() %>
                </div>

                <div class="card-meta">
                    <div class="meta-item">
                        <i class="fa-solid fa-clock"></i>
                        <span><%= delivery %></span>
                    </div>
                    <div class="meta-item">
                        <i class="fa-solid fa-location-dot"></i>
                        <span><%= r.getAddress() != null ? r.getAddress() : "City" %></span>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= r.getRestaurantId() %>"
                   class="card-cta" id="orderBtn-<%= r.getRestaurantId() %>"
                   onclick="event.stopPropagation()">
                    <i class="fa-solid fa-cart-plus"></i> Order from here
                </a>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="empty-state" id="emptyState">
            <div class="empty-icon">🍽️</div>
            <h3>No restaurants found</h3>
            <p>We're adding more restaurants soon. Check back later!</p>
        </div>
        <%
            }
        %>

    </div>
</div>

<%-- ═══════════════════════════════════════
     HOW IT WORKS
═══════════════════════════════════════ --%>
<section class="how-section" id="howItWorks">
    <div class="how-inner">
        <div class="section-header">
            <div>
                <h2 class="section-title">How Hungry Bee Works</h2>
                <p class="section-subtitle">Get food to your door in just a few steps</p>
            </div>
        </div>
        <div class="how-steps">
            <div class="step-card" id="step1">
                <div class="step-number">1</div>
                <div class="step-icon">📍</div>
                <div class="step-title">Choose a Restaurant</div>
                <p class="step-desc">Browse from our curated list of top-rated local restaurants near you.</p>
            </div>
            <div class="step-card" id="step2">
                <div class="step-number">2</div>
                <div class="step-icon">🛒</div>
                <div class="step-title">Pick Your Meals</div>
                <p class="step-desc">Select your favourite dishes and customize your order exactly how you like.</p>
            </div>
            <div class="step-card" id="step3">
                <div class="step-number">3</div>
                <div class="step-icon">💳</div>
                <div class="step-title">Place Your Order</div>
                <p class="step-desc">Checkout securely in seconds and track your order in real time.</p>
            </div>
            <div class="step-card" id="step4">
                <div class="step-number">4</div>
                <div class="step-icon">🛵</div>
                <div class="step-title">Enjoy Your Food</div>
                <p class="step-desc">Your meal arrives fresh and hot, delivered buzzing fast to your door.</p>
            </div>
        </div>
    </div>
</section>

<%-- ═══════════════════════════════════════
     PROMO BANNER
═══════════════════════════════════════ --%>
<div class="promo-banner" id="promoBanner">
    <div class="promo-inner">
        <div class="promo-text">
            <div class="promo-tag">🎉 Limited Time Offer</div>
            <div class="promo-title">First Order Free Delivery!</div>
            <div class="promo-sub">Use code <strong>BEEFREE</strong> at checkout — no minimum order required.</div>
        </div>
        <a href="${pageContext.request.contextPath}/menu" class="btn-promo" id="promoBtn">
            <i class="fa-solid fa-bolt"></i> Claim Offer
        </a>
    </div>
</div>

<%-- ═══════════ FOOTER (partial) ═══════════ --%>
<%@ include file="partials/footer.jsp" %>

<%-- ═══════════════════════════════════════
     SCRIPTS
═══════════════════════════════════════ --%>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script>
    // ── Navbar scroll effect ──
    const navbar = document.getElementById('mainNavbar');
    window.addEventListener('scroll', () => {
        navbar.classList.toggle('scrolled', window.scrollY > 10);
    });

    // ── Category filter ──
    function filterCategory(category, el) {
        // Update active pill
        document.querySelectorAll('.category-card').forEach(c => c.classList.remove('active'));
        el.classList.add('active');

        // Filter cards
        const cards = document.querySelectorAll('.restaurant-card');
        let visible = 0;
        cards.forEach(card => {
            const cuisine = card.dataset.cuisine || '';
            const show = category === 'all' || cuisine.includes(category);
            card.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        // Show empty state if no match
        const empty = document.getElementById('emptyState');
        if (empty) empty.style.display = visible === 0 ? '' : 'none';
    }

    // ── Live search ──
    const searchInput = document.getElementById('navSearchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            const q = this.value.toLowerCase().trim();
            const cards = document.querySelectorAll('.restaurant-card');
            let visible = 0;
            cards.forEach(card => {
                const name = (card.querySelector('.card-name')?.textContent || '').toLowerCase();
                const cuisine = (card.querySelector('.card-cuisine')?.textContent || '').toLowerCase();
                const show = !q || name.includes(q) || cuisine.includes(q);
                card.style.display = show ? '' : 'none';
                if (show) visible++;
            });
            const empty = document.getElementById('emptyState');
            if (empty) empty.style.display = visible === 0 ? '' : 'none';
        });
    }

    // ── Smooth scroll for anchor links ──
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', e => {
            const target = document.querySelector(link.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // ── Animate restaurant cards on intersection ──
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.restaurant-card, .step-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(24px)';
        card.style.transition = 'opacity .5s ease, transform .5s ease';
        observer.observe(card);
    });
</script>
</body>
</html>