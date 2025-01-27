package combine.booknook.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String DATABASE_URL = "jdbc:sqlite:src/main/resources/database/booknook.db";

    // Establishes a new connection to the SQLite database
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(DATABASE_URL);
        } catch (SQLException e) {
            System.err.println("Failed to connect to the database: " + e.getMessage());
            return null;
        }
    }
}

