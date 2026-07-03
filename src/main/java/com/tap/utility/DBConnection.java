package com.tap.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/instant_food";

    private static final String USERNAME =
            "root";

    private static final String PASSWORD =
            "root";

    /**
     * Returns a new database connection each time it is called.
     * Callers must close the connection (use try-with-resources).
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}