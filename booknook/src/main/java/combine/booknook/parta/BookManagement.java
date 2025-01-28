package combine.booknook.parta;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import combine.booknook.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
/**
 * The BookManagement class acts as the primary service layer for managing books,
 * categories, orders, and related operations.
 *
 * This service includes methods for searching, purchasing, and managing orders.
 * It does not include user authentication, as per Group A's specifications.
 *
 * @author Delia Turiac
 */
public final class BookManagement implements ProductManagement {
    public List<BooksEntry> bookList = new ArrayList<>();

    public BookManagement() {
        this.loadBooksFromDatabase();
    }

    private void loadBooksFromDatabase() {
        bookList.clear();
        String query = "SELECT * FROM books";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                BooksEntry book = new BooksEntry(
                        resultSet.getInt("id"),
                        resultSet.getString("item_code"),
                        resultSet.getString("name"),
                        new BooksCategory(0, resultSet.getString("category")), // No category ID in your schema
                        resultSet.getString("author"),
                        resultSet.getDouble("price")
                );
                bookList.add(book);
            }
            System.out.println("Books loaded successfully from the database.");
        } catch (Exception e) {
            System.err.println("Error loading books: " + e.getMessage());
        }
    }


    @Override
    public List<BooksEntry> searchBook(String query) {
        List<BooksEntry> searchList = new ArrayList<>();
        for (BooksEntry book : this.bookList) {
            if (book.getAuthor().toLowerCase().contains(query.toLowerCase()) ||
                    book.getName().toLowerCase().contains(query.toLowerCase()) ||
                    book.getCategory().getName().toLowerCase().contains(query.toLowerCase())) {
                searchList.add(book);
            }
        }
        return searchList;
    }

    @Override
    public List<BooksEntry> purchaseBook(String code) {
        List<BooksEntry> purchasedBooks = new ArrayList<>();
        for (BooksEntry book : bookList) {
            if (book.getItemCode().equalsIgnoreCase(code)) {
                purchasedBooks.add(book);
                createOrder(book); // Create an order for each purchased book
            }
        }
        return purchasedBooks;
    }

    @Override
    public BooksOrder createOrder(BooksEntry book) {
        String orderId = java.util.UUID.randomUUID().toString(); // Generate unique order ID
        String queryOrder = "INSERT INTO orders (order_id, user, total_price) VALUES (?, ?, ?)";
        String queryOrderDetails = "INSERT INTO order_details (order_id, item_code, quantity) VALUES (?, ?, ?)";
        try (Connection connection = DatabaseConnection.getConnection()) {
            // Insert into orders
            try (PreparedStatement statementOrder = connection.prepareStatement(queryOrder)) {
                statementOrder.setString(1, orderId);
                statementOrder.setString(2, "Guest"); // Replace with actual user from session
                statementOrder.setDouble(3, book.getPrice());
                statementOrder.executeUpdate();
            }

            // Insert into order details
            try (PreparedStatement statementDetails = connection.prepareStatement(queryOrderDetails)) {
                statementDetails.setString(1, orderId);
                statementDetails.setString(2, book.getItemCode());
                statementDetails.setInt(3, 1); // Default quantity
                statementDetails.executeUpdate();
            }
            System.out.println("Order created successfully for book: " + book.getName());
        } catch (Exception e) {
            System.err.println("Error creating order: " + e.getMessage());
        }
        return null; // Modify to return a proper BooksOrder object if needed
    }

    @Override
    public List<BooksEntry> viewOrders() {
        List<BooksEntry> orderedBooks = new ArrayList<>();
        String query = "SELECT b.item_code, b.name, b.author, b.category, b.price " +
                "FROM orders o " +
                "JOIN order_details od ON o.order_id = od.order_id " +
                "JOIN books b ON od.item_code = b.item_code";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                BooksEntry book = new BooksEntry(
                        resultSet.getString("item_code"),
                        resultSet.getString("name"),
                        resultSet.getDouble("price"),
                        new BooksCategory(0, resultSet.getString("category"))
                );
                book.setAuthor(resultSet.getString("author"));
                orderedBooks.add(book);
            }
        } catch (Exception e) {
            System.err.println("Error retrieving orders: " + e.getMessage());
        }
        return orderedBooks;
    }


    public Map<String, Integer> getTotalQuantityPerProduct() {
        Map<String, Integer> bookSales = new HashMap<>();
        String query = "SELECT item_code, SUM(quantity) AS total_quantity " +
                "FROM order_details " +
                "GROUP BY item_code";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                String itemCode = resultSet.getString("item_code");
                int totalQuantity = resultSet.getInt("total_quantity");
                bookSales.put(itemCode, totalQuantity);
            }
        } catch (Exception e) {
            System.err.println("Error fetching total quantities per product: " + e.getMessage());
        }
        return bookSales;
    }

    @Override
    public Map<String, Integer> createSalesReport() {
        Map<String, Integer> salesReport = new HashMap<>();
        String query = "SELECT b.name, SUM(od.quantity) AS total_quantity " +
                "FROM books b " +
                "JOIN order_details od ON b.item_code = od.item_code " +
                "GROUP BY b.name";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                String bookName = resultSet.getString("name");
                int totalQuantity = resultSet.getInt("total_quantity");
                salesReport.put(bookName, totalQuantity);
            }
        } catch (Exception e) {
            System.err.println("Error generating sales report: " + e.getMessage());
        }
        return salesReport;
    }
}
