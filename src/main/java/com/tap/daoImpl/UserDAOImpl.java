package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserDAO;
import com.tap.model.User;
import com.tap.utility.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_USER =
            "INSERT INTO user(name,password,email,address,role,created_date,last_login_date) VALUES(?,?,?,?,?,?,?)";

    private static final String GET_USER_BY_ID =
            "SELECT * FROM user WHERE user_id=?";

    private static final String GET_ALL_USERS =
            "SELECT * FROM user";

    private static final String UPDATE_USER =
            "UPDATE user SET name=?,password=?,email=?,address=?,role=?,last_login_date=? WHERE user_id=?";

    private static final String DELETE_USER =
            "DELETE FROM user WHERE user_id=?";

    private static final String GET_USER_BY_EMAIL =
            "SELECT * FROM user WHERE email=?";

    private static final String VALIDATE_USER =
            "SELECT * FROM user WHERE email=? AND password=?";

    @Override
    public int addUser(User user) {

        int result = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_USER)) {

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getAddress());
            pstmt.setString(5, user.getRole());
            if (user.getCreatedDate() != null) {
                pstmt.setTimestamp(6, user.getCreatedDate());
            } else {
                pstmt.setNull(6, java.sql.Types.TIMESTAMP);
            }
            if (user.getLastLoginDate() != null) {
                pstmt.setTimestamp(7, user.getLastLoginDate());
            } else {
                pstmt.setNull(7, java.sql.Types.TIMESTAMP);
            }

            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public User getUserById(int userId) {

        User user = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_USER_BY_ID)) {

            pstmt.setInt(1, userId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = extractUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ALL_USERS)) {

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                users.add(extractUser(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }

    @Override
    public boolean updateUser(User user) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_USER)) {

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getAddress());
            pstmt.setString(5, user.getRole());
            if (user.getLastLoginDate() != null) {
                pstmt.setTimestamp(6, user.getLastLoginDate());
            } else {
                pstmt.setNull(6, java.sql.Types.TIMESTAMP);
            }
            pstmt.setInt(7, user.getUserId());

            status = pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean deleteUser(int userId) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_USER)) {

            pstmt.setInt(1, userId);

            status = pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public User getUserByEmail(String email) {

        User user = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_USER_BY_EMAIL)) {

            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = extractUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public User validateUser(String email, String password) {

        User user = getUserByEmail(email);
        
        if (user != null) {
            String dbPassword = user.getPassword();
            if (dbPassword != null) {
                boolean isMatch = false;
                try {
                    isMatch = BCrypt.checkpw(password, dbPassword);
                } catch (Exception e) {
                    // Fallback for legacy plain-text or previous hashing mechanism
                    isMatch = dbPassword.equals(password);
                }
                
                if (isMatch) {
                    return user;
                }
            }
        }

        return null;
    }

    private User extractUser(ResultSet rs) throws Exception {

        int userId = rs.getInt("user_id");
        String name = rs.getString("name");
        String password = rs.getString("password");
        String email = rs.getString("email");
        String address = rs.getString("address");
        String role = rs.getString("role");
        Timestamp createdDate = rs.getTimestamp("created_date");
        Timestamp lastLoginDate = rs.getTimestamp("last_login_date");

        return new User(
                userId,
                name,
                password,
                email,
                address,
                role,
                createdDate,
                lastLoginDate
        );
    }
}