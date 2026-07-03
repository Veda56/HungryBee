package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDAO;
import com.tap.model.Menu;
import com.tap.utility.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT_MENU =
            "INSERT INTO Menu(RestaurantID, ItemName, Description, Price, IsAvailable, Category, image_url, CreatedAt, UpdatedAt, DeletedAt) "
            + "VALUES(?,?,?,?,?,?,?,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,NULL)";

    private static final String GET_MENU_BY_ID =
            "SELECT * FROM Menu WHERE MenuID=? AND DeletedAt IS NULL";

    private static final String GET_ALL_MENUS =
            "SELECT * FROM Menu WHERE DeletedAt IS NULL";

    private static final String GET_MENUS_BY_RESTAURANT_ID =
            "SELECT * FROM Menu WHERE RestaurantID=? AND DeletedAt IS NULL";

    private static final String GET_AVAILABLE_MENUS_BY_RESTAURANT_ID =
            "SELECT * FROM Menu WHERE RestaurantID=? AND IsAvailable=1 AND DeletedAt IS NULL";

    private static final String GET_MENUS_BY_CATEGORY =
            "SELECT * FROM Menu WHERE Category=? AND DeletedAt IS NULL";

    private static final String UPDATE_MENU =
            "UPDATE Menu SET RestaurantID=?, ItemName=?, Description=?, Price=?, "
            + "IsAvailable=?, Category=?, image_url=?, UpdatedAt=CURRENT_TIMESTAMP "
            + "WHERE MenuID=? AND DeletedAt IS NULL";

    // Soft delete: item stays in database, but customers cannot see it.
    private static final String DELETE_MENU =
            "UPDATE Menu SET DeletedAt=CURRENT_TIMESTAMP, IsAvailable=0 "
            + "WHERE MenuID=? AND DeletedAt IS NULL";

    @Override
    public int addMenu(Menu menu) {

        int result = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_MENU)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setBigDecimal(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getCategory());
            pstmt.setString(7, menu.getImageUrl());

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public Menu getMenuById(int menuId) {

        Menu menu = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_MENU_BY_ID)) {

            pstmt.setInt(1, menuId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                menu = extractMenu(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ALL_MENUS)) {

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                menus.add(extractMenu(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenusByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_MENUS_BY_RESTAURANT_ID)) {

            pstmt.setInt(1, restaurantId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                menus.add(extractMenu(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getAvailableMenusByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt =
                     con.prepareStatement(GET_AVAILABLE_MENUS_BY_RESTAURANT_ID)) {

            pstmt.setInt(1, restaurantId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                menus.add(extractMenu(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenusByCategory(String category) {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_MENUS_BY_CATEGORY)) {

            pstmt.setString(1, category);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                menus.add(extractMenu(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public boolean updateMenu(Menu menu) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_MENU)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setBigDecimal(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getCategory());
            pstmt.setString(7, menu.getImageUrl());
            pstmt.setInt(8, menu.getMenuId());

            status = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean deleteMenu(int menuId) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_MENU)) {

            pstmt.setInt(1, menuId);

            status = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status;
    }

    private Menu extractMenu(ResultSet rs) throws SQLException {

        return new Menu(
                rs.getInt("MenuID"),
                rs.getInt("RestaurantID"),
                rs.getString("ItemName"),
                rs.getString("Description"),
                rs.getBigDecimal("Price"),
                rs.getBoolean("IsAvailable"),
                rs.getString("Category"),
                rs.getString("image_url"),
                rs.getTimestamp("CreatedAt"),
                rs.getTimestamp("UpdatedAt"),
                rs.getTimestamp("DeletedAt")
        );
    }
}