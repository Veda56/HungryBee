package com.tap.model;

import java.math.BigDecimal;

public class Restaurant {

    private int restaurantId;
    private String name;
    private String cuisineType;
    private String deliveryTime;
    private String address;
    private int adminUserId;
    private BigDecimal rating;
    private boolean isActive;

    public Restaurant() {
    }

    // Used while adding a new restaurant
    public Restaurant(String name, String cuisineType, String deliveryTime,
                      String address, int adminUserId,
                      BigDecimal rating, boolean isActive) {

        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.address = address;
        this.adminUserId = adminUserId;
        this.rating = rating;
        this.isActive = isActive;
    }

    // Used while fetching a restaurant from database
    public Restaurant(int restaurantId, String name, String cuisineType,
                      String deliveryTime, String address, int adminUserId,
                      BigDecimal rating, boolean isActive) {

        this.restaurantId = restaurantId;
        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.address = address;
        this.adminUserId = adminUserId;
        this.rating = rating;
        this.isActive = isActive;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public String getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(String deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getAdminUserId() {
        return adminUserId;
    }

    public void setAdminUserId(int adminUserId) {
        this.adminUserId = adminUserId;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Restaurant [restaurantId=" + restaurantId
                + ", name=" + name
                + ", cuisineType=" + cuisineType
                + ", deliveryTime=" + deliveryTime
                + ", rating=" + rating
                + ", isActive=" + isActive + "]";
    }
}