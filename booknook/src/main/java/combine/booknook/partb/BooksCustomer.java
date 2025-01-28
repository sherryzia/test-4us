package combine.booknook.partb;

import combine.booknook.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BooksCustomer implements UserManagement {

    public boolean isLoggedIn = false;
    public boolean isAdmin = false;
    private List<User> loggedInUsers = new ArrayList<>();

    public BooksCustomer() {
    }

    @Override
    public List<User> LoginUser(String email, String password) {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, email);
            statement.setString(2, password);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    User user = new User(
                            resultSet.getInt("id"),
                            resultSet.getString("name"),
                            resultSet.getString("email"),
                            resultSet.getString("password"),
                            resultSet.getString("role")
                    );
                    users.add(user);
                    loggedInUsers.add(user);
                    if ("admin".equalsIgnoreCase(user.getUser_role())) {
                        isAdmin = true;
                    }
                    isLoggedIn = true;
                }
            }
        } catch (Exception e) {
            System.err.println("Login failed: " + e.getMessage());
        }
        return users;
    }

    @Override
    public String deleteUser(String email) {
        String query = "DELETE FROM users WHERE email = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, email);
            int rowsDeleted = statement.executeUpdate();
            return rowsDeleted > 0 ? "User deleted successfully." : "User not found.";
        } catch (Exception e) {
            return "Error deleting user: " + e.getMessage();
        }
    }

    @Override
    public List<User> updateUser(String[] data) {
        String query = "UPDATE users SET name = ?, email = ?, role = ? WHERE name = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, data[1]);
            statement.setString(2, data[2]);
            statement.setString(3, data[3]);
            statement.setString(4, data[0]);
            statement.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error updating user: " + e.getMessage());
        }
        return viewUsers();
    }

    @Override
    public List<User> viewUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                users.add(new User(
                        resultSet.getInt("id"),
                        resultSet.getString("name"),
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("role")
                ));
            }
        } catch (Exception e) {
            System.err.println("Error viewing users: " + e.getMessage());
        }
        return users;
    }

    @Override
    public List<User> getUser(String username) {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE name = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    users.add(new User(
                            resultSet.getInt("id"),
                            resultSet.getString("name"),
                            resultSet.getString("email"),
                            resultSet.getString("password"),
                            resultSet.getString("role")
                    ));
                }
            }
        } catch (Exception e) {
            System.err.println("Error retrieving user: " + e.getMessage());
        }
        return users;
    }
}
