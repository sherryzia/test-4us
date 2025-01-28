package combine.booknook.partb;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import combine.booknook.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BookManagement implements ProductManagement {

    public List<BooksCategory> categoryList = new ArrayList<>();
    public List<BooksEntry> bookList = new ArrayList<>();

    public BookManagement() {
        this.loadCategoriesFromDatabase();
        this.loadBooksFromDatabase();
    }

    // Load categories from the database
    private void loadCategoriesFromDatabase() {
        categoryList.clear();
        String query = "SELECT * FROM categories"; // Assuming a `categories` table exists
        try (Connection connection = DatabaseConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            while (resultSet.next()) {
                BooksCategory category = new BooksCategory(
                        resultSet.getInt("id"),
                        resultSet.getString("name")
                );
                categoryList.add(category);
            }
        } catch (Exception e) {
            System.err.println("Error loading categories: " + e.getMessage());
        }
    }

    // Load books from the database
    private void loadBooksFromDatabase() {
        bookList.clear();
        String query = "SELECT * FROM books";
        try (Connection connection = DatabaseConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            while (resultSet.next()) {
                BooksEntry book = new BooksEntry(
                        resultSet.getInt("id"),
                        resultSet.getString("item_code"),
                        resultSet.getString("name"),
                        new BooksCategory(0, resultSet.getString("category")), // Category ID is optional
                        resultSet.getString("author"),
                        resultSet.getDouble("price")
                );
                bookList.add(book);
            }
        } catch (Exception e) {
            System.err.println("Error loading books: " + e.getMessage());
        }
    }

    @Override
    public List<BooksEntry> addBook(BooksEntry book) {
        String query = "INSERT INTO books (item_code, name, author, category, price) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, book.getItemCode());
            statement.setString(2, book.getName());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getCategory().getName());
            statement.setDouble(5, book.getPrice());
            statement.executeUpdate();
            bookList.add(book);
        } catch (Exception e) {
            System.err.println("Error adding book: " + e.getMessage());
        }
        return bookList;
    }

    @Override
    public List<BooksCategory> addCategory(String name) {
        String query = "INSERT INTO categories (name) VALUES (?)"; // Assuming a `categories` table exists
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, name);
            statement.executeUpdate();
            categoryList.add(new BooksCategory(categoryList.size() + 1, name));
        } catch (Exception e) {
            System.err.println("Error adding category: " + e.getMessage());
        }
        return categoryList;
    }

    public List<BooksCategory> getCategories() {
        return categoryList;
    }
}
