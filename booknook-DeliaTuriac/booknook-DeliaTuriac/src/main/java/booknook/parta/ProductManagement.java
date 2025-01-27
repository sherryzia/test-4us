package booknook.parta;

import java.util.List;
import java.util.Map;

/**
 * Defines the operations for managing products in the BookNook system.
 * This interface provides methods for searching books, making purchases,
 * creating orders, viewing orders, and generating sales reports.
 * Implementing classes should provide concrete logic for these operations.
 *
 * @author
 */
public interface ProductManagement {
    
    // Searches for books based on a query.
    public List<BooksEntry> searchBook(String query);
    
    // Processes the purchase of a book by its code.
    public List<BooksEntry> purchaseBook(String bookcode);
    
    // Creates an order for a given book.
    public BooksOrder createOrder(BooksEntry book);
    
    // Retrieves all orders placed by users.
    public List<BooksEntry> viewOrders();
    
    // Generates a report of total quantities sold per product.
    public Map<String , Integer> createSalesReport();
}
