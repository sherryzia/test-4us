


package booknook.parta;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a customer's order, containing details about the user, the purchased books,
 * and the order's total amount.
 * This class also handles operations related to orders, such as calculating total price
 * and adding order details.
 *
 * @author Delia Turiac
 */
public class BooksOrder{
 // Unique identifier for the order
    String id;
    // Total amount for the order
    double amount;
    // User associated with the order
    private String user;
    // List of order details for the current order
    public List<BooksOrderDetails> order_details = new ArrayList<>();
    // List of books included in the order
    public List<BooksEntry> books = new ArrayList<>();

    // Internal unique identifier for the order
    private String orderId;

    // Detailed information about a single order
    BooksOrderDetails orderDetails;

    /**
     * Default constructor.
     * Creates an empty order instance.
     */
    public BooksOrder(){}
    
    /**
     * Constructs an order with a specific ID, user, and order details.
     *
     * @param orderId Unique identifier for the order.
     * @param user The user who placed the order.
     * @param orderDetails Detailed information about the order.
     */
    public BooksOrder(String orderId, String user, BooksOrderDetails orderDetails) {
        this.orderId = orderId;
        this.user = user;
        this.orderDetails = orderDetails;
        
    }
    
     /**
     * Constructs an order with a specific ID and user, without initial order details.
     *
     * @param orderId Unique identifier for the order.
     * @param user The user who placed the order.
     */
    public BooksOrder(String orderId, String user) {
        this.orderId = orderId;
        this.user = user;
        
        
    }

    /**
     * Retrieves the user associated with the order.
     *
     * @return The username of the order's owner.
     */
    public String getUser() {
        return user;
    }

    /**
     * Retrieves the unique ID of the order.
     *
     * @return The order's unique identifier.
     */
    public String getId() {
        return id;
    }

    /**
     * Assigns a unique ID to the order.
     *
     * @param id The unique identifier to set.
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Retrieves the total amount of the order.
     *
     * @return The total cost of the order.
     */
    public double getAmount() {
        return amount;
    }

    /**
     * Sets the total amount for the order.
     *
     * @param amount The total cost to set.
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }

    
    
    /**
     * Calculates the total price of all books in the given list.
     *
     * @param book List of books for which the total price is calculated.
     * @return The cumulative price of the books in the list.
     */
    public double getTotalPrice(List<BooksEntry> book) {
        double totalPrice = 0;
        for (BooksEntry b : book) {
            totalPrice += b.getPrice();
        }
        return totalPrice;
    }
    
     /**
     * Adds a new order detail to the order's details list.
     *
     * @param orderDetails Details to add to the current order.
     */
     public void addOrderDetails(BooksOrderDetails orderDetails) {
        order_details.add(orderDetails);
    }

    /**
     * Retrieves the list of order details associated with this order.
     *
     * @return A list of order details.
     */
    public List<BooksOrderDetails> getOrderDetails() {
        return order_details;
    }

    /**
     * Adds a book to the list of books included in the order.
     *
     * @param book The book to add to the order.
     */
    public void addBookToOrder(BooksEntry book) {
        books.add(book);
    }
    
    /**
     * Provides a string representation of the order.
     * Includes the order's ID, total amount, user, and the first book in the list (if available).
     *
     * @return A string summary of the order.
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Order{");
        sb.append("id=").append(id);
        sb.append(", amount=").append(amount);
        sb.append(", user=").append(user);
        sb.append(", order_details=").append(this.books.get(0));
        sb.append('}');
        return sb.toString();
    }
    

    

}
