package com.tap.model;

import java.math.BigDecimal;

/**
 * Session-only cart helper — NOT a database entity.
 * Wraps a Menu item with a quantity for the shopping cart.
 */
public class CartItem {

    private Menu menu;
    private int quantity;

    public CartItem(Menu menu, int quantity) {
        this.menu = menu;
        this.quantity = quantity;
    }

    public Menu getMenu() { return menu; }
    public void setMenu(Menu menu) { this.menu = menu; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    /** Convenience: price × quantity */
    public BigDecimal getSubtotal() {
        if (menu == null || menu.getPrice() == null) return BigDecimal.ZERO;
        return menu.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}
