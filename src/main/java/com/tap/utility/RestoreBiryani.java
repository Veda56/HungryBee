package com.tap.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RestoreBiryani {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/instant_food?useSSL=false&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "root";
        
        try (Connection con = DriverManager.getConnection(url, user, password)) {
            
            // Check if it exists
            String checkSql = "SELECT * FROM Menu WHERE ItemName LIKE '%Biryani%' OR ItemName LIKE '%Biriani%'";
            try (PreparedStatement pstmt = con.prepareStatement(checkSql)) {
                ResultSet rs = pstmt.executeQuery();
                boolean found = false;
                while(rs.next()){
                    found = true;
                    System.out.println("Found: " + rs.getString("ItemName") + " ID: " + rs.getInt("MenuID"));
                }
                
                if (found) {
                    // Update
                    String updateSql = "UPDATE Menu SET DeletedAt=NULL, IsAvailable=1 WHERE ItemName LIKE '%Biryani%' OR ItemName LIKE '%Biriani%'";
                    try (PreparedStatement uStmt = con.prepareStatement(updateSql)) {
                        int count = uStmt.executeUpdate();
                        System.out.println("Restored " + count + " items.");
                    }
                } else {
                    // Insert
                    String insertSql = "INSERT INTO Menu(RestaurantID, ItemName, Description, Price, IsAvailable, Category, image_url, CreatedAt, UpdatedAt) VALUES(1, 'Chicken Biryani', 'Delicious aromatic biryani', 250.00, 1, 'Mains', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
                    try (PreparedStatement iStmt = con.prepareStatement(insertSql)) {
                        int count = iStmt.executeUpdate();
                        System.out.println("Inserted new item: " + count);
                    }
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
