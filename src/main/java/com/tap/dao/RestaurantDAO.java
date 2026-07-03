package com.tap.dao;

import java.util.List;

import com.tap.model.Restaurant;

public interface RestaurantDAO {

    int addRestaurant(Restaurant restaurant);

    Restaurant getRestaurantById(int restaurantId);

    List<Restaurant> getAllRestaurants();

    List<Restaurant> getActiveRestaurants();

    List<Restaurant> getRestaurantsByAdminUserId(int adminUserId);

    boolean updateRestaurant(Restaurant restaurant);

    boolean deleteRestaurant(int restaurantId);
}