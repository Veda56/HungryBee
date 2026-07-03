package com.tap.dao;

import java.util.List;

import com.tap.model.Menu;

public interface MenuDAO {

    int addMenu(Menu menu);

    Menu getMenuById(int menuId);

    List<Menu> getAllMenus();

    List<Menu> getMenusByRestaurantId(int restaurantId);

    List<Menu> getAvailableMenusByRestaurantId(int restaurantId);

    List<Menu> getMenusByCategory(String category);

    boolean updateMenu(Menu menu);

    boolean deleteMenu(int menuId);
}