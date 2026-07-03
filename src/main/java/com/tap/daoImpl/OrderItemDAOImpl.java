package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.utility.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO OrderItem(OrderID, MenuID, Quantity, ItemTotal) VALUES(?,?,?,?)";

    private static final String GET_ORDER_ITEM_BY_ID =
            "SELECT * FROM OrderItem WHERE OrderItemID=?";

    private static final String GET_ORDER_ITEMS_BY_ORDER_ID =
            "SELECT * FROM OrderItem WHERE OrderID=?";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE OrderItem SET MenuID=?, Quantity=?, ItemTotal=? WHERE OrderItemID=?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM OrderItem WHERE OrderItemID=?";

    @Override
    public int addOrderItem(OrderItem orderItem) {

        int generatedOrderItemId = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(
                     INSERT_ORDER_ITEM,
                     Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setBigDecimal(4, orderItem.getItemTotal());

            pstmt.executeUpdate();

            ResultSet generatedKeys = pstmt.getGeneratedKeys();

            if (generatedKeys.next()) {
                generatedOrderItemId = generatedKeys.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderItemId;
    }

    @Override
    public OrderItem getOrderItemById(int orderItemId) {

        OrderItem orderItem = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ORDER_ITEM_BY_ID)) {

            pstmt.setInt(1, orderItemId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                orderItem = extractOrderItem(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt =
                     con.prepareStatement(GET_ORDER_ITEMS_BY_ORDER_ID)) {

            pstmt.setInt(1, orderId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orderItems.add(extractOrderItem(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    @Override
    public boolean updateOrderItem(OrderItem orderItem) {

        boolean isUpdated = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_ORDER_ITEM)) {

            pstmt.setInt(1, orderItem.getMenuId());
            pstmt.setInt(2, orderItem.getQuantity());
            pstmt.setBigDecimal(3, orderItem.getItemTotal());
            pstmt.setInt(4, orderItem.getOrderItemId());

            isUpdated = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isUpdated;
    }

    @Override
    public boolean deleteOrderItem(int orderItemId) {

        boolean isDeleted = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_ORDER_ITEM)) {

            pstmt.setInt(1, orderItemId);

            isDeleted = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isDeleted;
    }

    private OrderItem extractOrderItem(ResultSet rs) throws SQLException {

        return new OrderItem(
                rs.getInt("OrderItemID"),
                rs.getInt("OrderID"),
                rs.getInt("MenuID"),
                rs.getInt("Quantity"),
                rs.getBigDecimal("ItemTotal")
        );
    }
}