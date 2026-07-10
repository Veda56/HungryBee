package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tap.dao.AdminDAO;
import com.tap.model.Admin;
import com.tap.utility.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

public class AdminDAOImpl implements AdminDAO {

    private static final String GET_ADMIN_BY_EMAIL = "SELECT * FROM admin WHERE email=?";
    private static final String UPDATE_ADMIN_PASSWORD = "UPDATE admin SET password=? WHERE admin_id=?";

    @Override
    public Admin validateAdmin(String email, String password) {
        Admin admin = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ADMIN_BY_EMAIL)) {

            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                
                boolean isMatch = false;
                try {
                    isMatch = BCrypt.checkpw(password, dbPassword);
                } catch (Exception e) {
                    // Fallback for legacy plain-text
                    isMatch = dbPassword.equals(password);
                }

                if (isMatch) {
                    int adminId = rs.getInt("admin_id");
                    String adminName = rs.getString("admin_name");
                    admin = new Admin(adminId, adminName, email, dbPassword);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }
    
    @Override
    public boolean updatePassword(int adminId, String newHashedPassword) {
        boolean status = false;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_ADMIN_PASSWORD)) {
            
            pstmt.setString(1, newHashedPassword);
            pstmt.setInt(2, adminId);
            
            status = pstmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
