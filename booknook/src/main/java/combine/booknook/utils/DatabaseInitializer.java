package combine.booknook.utils;

import java.sql.Connection;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;

public class DatabaseInitializer {
    public static void initialize() {
        try (Connection connection = DatabaseConnection.getConnection();
             Statement statement = connection.createStatement()) {

            // Load the schema file (ensure the file path is correct)
            String schema = new String(Files.readAllBytes(Paths.get("src/main/resources/database/schema.sql")));

            // Execute the schema
            statement.executeUpdate(schema);
            System.out.println("Database initialized successfully.");

        } catch (Exception e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
        }
    }
}

