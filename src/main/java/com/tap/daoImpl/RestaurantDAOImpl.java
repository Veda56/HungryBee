package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT_RESTAURANT = "INSERT INTO Restaurant(Name, CuisineType, DeliveryTime, Address, AdminUserID, Rating, IsActive) "
            + "VALUES(?,?,?,?,?,?,?)";

    private static final String GET_RESTAURANT_BY_ID = "SELECT * FROM Restaurant WHERE RestaurantID=?";

    private static final String GET_ALL_RESTAURANTS = "SELECT * FROM Restaurant";

    private static final String GET_ACTIVE_RESTAURANTS = "SELECT * FROM Restaurant WHERE IsActive=1";

    private static final String GET_RESTAURANTS_BY_ADMIN_USER_ID = "SELECT * FROM Restaurant WHERE AdminUserID=?";

    private static final String UPDATE_RESTAURANT = "UPDATE Restaurant SET Name=?, CuisineType=?, DeliveryTime=?, Address=?, AdminUserID=?, Rating=?, IsActive=? "
            + "WHERE RestaurantID=?";

    private static final String DELETE_RESTAURANT = "DELETE FROM Restaurant WHERE RestaurantID=?";

    @Override
    public int addRestaurant(Restaurant restaurant) {

        int result = 0;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(INSERT_RESTAURANT)) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setBigDecimal(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANT_BY_ID)) {

            pstmt.setInt(1, restaurantId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                restaurant = extractRestaurant(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(GET_ALL_RESTAURANTS)) {

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                restaurants.add(extractRestaurant(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> getActiveRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(GET_ACTIVE_RESTAURANTS)) {

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                restaurants.add(extractRestaurant(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> getRestaurantsByAdminUserId(int adminUserId) {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANTS_BY_ADMIN_USER_ID)) {

            pstmt.setInt(1, adminUserId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                restaurants.add(extractRestaurant(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(UPDATE_RESTAURANT)) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setBigDecimal(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setInt(8, restaurant.getRestaurantId());

            status = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(DELETE_RESTAURANT)) {

            pstmt.setInt(1, restaurantId);

            status = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status;
    }

    private Restaurant extractRestaurant(ResultSet rs) throws SQLException {

        return new Restaurant(
                rs.getInt("RestaurantID"),
                rs.getString("Name"),
                rs.getString("CuisineType"),
                rs.getString("DeliveryTime"),
                rs.getString("Address"),
                rs.getInt("AdminUserID"),
                rs.getBigDecimal("Rating"),
                rs.getBoolean("IsActive"));
    }
}