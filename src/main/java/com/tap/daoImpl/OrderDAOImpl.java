package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDAO;
import com.tap.model.OrderTable;
import com.tap.utility.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    private static final String INSERT_ORDER =
            "INSERT INTO ordertable(UserID, RestaurantID, OrderDate, TotalAmount, Status, PaymentMethod) "
            + "VALUES(?,?,?,?,?,?)";

    private static final String GET_ORDER_BY_ID =
            "SELECT * FROM ordertable WHERE OrderID=?";

    private static final String GET_ALL_ORDERS =
            "SELECT * FROM ordertable";

    private static final String GET_ORDERS_BY_USER_ID =
            "SELECT * FROM ordertable WHERE UserID=? ORDER BY OrderDate DESC";

    private static final String GET_ORDERS_BY_RESTAURANT_ID =
            "SELECT * FROM ordertable WHERE RestaurantID=? ORDER BY OrderDate DESC";

    private static final String UPDATE_ORDER_STATUS =
            "UPDATE ordertable SET Status=? WHERE OrderID=?";

    private static final String UPDATE_PAYMENT_METHOD =
            "UPDATE ordertable SET PaymentMethod=? WHERE OrderID=?";

    private static final String DELETE_ORDER =
            "DELETE FROM ordertable WHERE OrderID=?";

    @Override
    public int addOrder(OrderTable order) {

        int generatedOrderId = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(
                     INSERT_ORDER,
                     Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setTimestamp(3, order.getOrderDate());
            pstmt.setBigDecimal(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMethod());

            pstmt.executeUpdate();

            ResultSet generatedKeys = pstmt.getGeneratedKeys();

            if (generatedKeys.next()) {
                generatedOrderId = generatedKeys.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }

    @Override
    public OrderTable getOrderById(int orderId) {

        OrderTable order = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ORDER_BY_ID)) {

            pstmt.setInt(1, orderId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                order = extractOrder(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public List<OrderTable> getAllOrders() {

        List<OrderTable> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ALL_ORDERS)) {

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orders.add(extractOrder(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<OrderTable> getOrdersByUserId(int userId) {

        List<OrderTable> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ORDERS_BY_USER_ID)) {

            pstmt.setInt(1, userId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orders.add(extractOrder(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<OrderTable> getOrdersByRestaurantId(int restaurantId) {

        List<OrderTable> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt =
                     con.prepareStatement(GET_ORDERS_BY_RESTAURANT_ID)) {

            pstmt.setInt(1, restaurantId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orders.add(extractOrder(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {

        boolean isUpdated = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_ORDER_STATUS)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);

            isUpdated = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isUpdated;
    }

    @Override
    public boolean updatePaymentMethod(int orderId, String paymentMethod) {

        boolean isUpdated = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt =
                     con.prepareStatement(UPDATE_PAYMENT_METHOD)) {

            pstmt.setString(1, paymentMethod);
            pstmt.setInt(2, orderId);

            isUpdated = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isUpdated;
    }

    @Override
    public boolean deleteOrder(int orderId) {

        boolean isDeleted = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_ORDER)) {

            pstmt.setInt(1, orderId);

            isDeleted = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isDeleted;
    }

    private OrderTable extractOrder(ResultSet rs) throws SQLException {

        return new OrderTable(
                rs.getInt("OrderID"),
                rs.getInt("UserID"),
                rs.getInt("RestaurantID"),
                rs.getTimestamp("OrderDate"),
                rs.getBigDecimal("TotalAmount"),
                rs.getString("Status"),
                rs.getString("PaymentMethod")
        );
    }
}