package combine.booknook.parta;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

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
    // Stores all customer orders
    public List<BooksOrder> orders = new ArrayList<>();
    // List of categories to classify books 
    public List<BooksCategory> categoryList = new ArrayList<>();
    // A collection of all available books in the service
    public List<BooksEntry> bookList = new ArrayList<>();
    // A separate list to store all created orders
    public List<BooksOrder> orderList = new ArrayList<>();
    
    
    /**
     * Default constructor for initializing the BookManagement.
     * Automatically populates the category and book lists during initialization.
     */
    public BookManagement() {
        this.startservice(); // Initialize the service with default data
        
    }
    
    /**
     * Initializes the service with predefined categories and books.
     * Populates the category list and book list with default values.
     */
    public void startservice() {
        // Define default categories
        BooksCategory[] category = {
            new BooksCategory(1, "Science Fiction"),
            new BooksCategory(2, "Mystery & Thriller"),
            new BooksCategory(3, "Health"),
        };
        
        // Add the predefined categories to the category list
        categoryList.addAll(Arrays.asList(category));

        // Define default books and associate them with categories
        BooksEntry[] books = {
            new BooksEntry(1, "S0001", "Dune", categoryList.get(0), "Frank Herbert", 39.99),
            new BooksEntry(2, "M0001", "The Girl with the Dragon Tattoo", categoryList.get(1), "Stieg Larsson", 45.50),
            new BooksEntry(3, "H0001", "Atomic Habits", categoryList.get(2), "James Clear", 29.99),                 
            new BooksEntry(4, "S0002", "Sapiens: A Brief History of Humankind", categoryList.get(0), "Yuval Noah Harari", 50.00),
            new BooksEntry(5, "M0002", "Gone Girl", categoryList.get(1), "Gillian Flynn", 41.99),
            new BooksEntry(6, "H0002", "The Power of Habit", categoryList.get(2), "Charles Duhigg", 31.50),
        };
        
        // Add the predefined books to the book list
        bookList.addAll(Arrays.asList(books));

    }

    /**
     * Searches for books based on a query string. 
     * The query can match part or all of a book's name or author's name.
     * 
     * @param query The search term, which can be part of the book or author name.
     * @return A list of books that match the search criteria.
     */
    @Override
    public List<BooksEntry> searchBook(String query) {
        
        List<BooksEntry> searchList = new ArrayList<>();
        for (BooksEntry book : this.bookList) {
            if (book.getAuthor().toLowerCase().contains(query.toLowerCase())) {
                searchList.add(book);
            }
            if (book.getName().toLowerCase().contains(query.toLowerCase())) {
                searchList.add(book);
            }
        }
        return searchList;
    }

     /**
     * Simulates the purchase of a book based on its item code.
     * Matching books are added to a purchased list, and an order is created.
     * 
     * @param code The unique item code of the book to purchase.
     * @return A list containing the purchased book(s).
     */
    @Override
    public List<BooksEntry> purchaseBook(String code) {    
        List<BooksEntry> pBook = new ArrayList<>();
        for (BooksEntry b : this.bookList) {
            if (b.getItemCode().toLowerCase().contains(code.toLowerCase())) {
                pBook.add(b);  // Add the book to the purchase list
                orders.add(createOrder(b)); // Create an order for the book
            }
        }
        
        return pBook;
    }

    /**
     * Creates an order for a given book.
     * Generates a unique order ID and associates it with the book details.
     * 
     * @param book The book for which the order is created.
     * @return The created order.
     */
    @Override
    public BooksOrder createOrder(BooksEntry book) {
        UUID uuid = UUID.randomUUID(); // Generate a unique identifier for the order
        
        // Create order details using book attributes
        BooksOrderDetails orderSetails = new BooksOrderDetails(book.getItemCode(), 
                                        book.getName(), book.getPrice(),  
                                     book.getCategory(),1);
        
        // Create the order object and link it to the generated order details
        BooksOrder order= new BooksOrder(uuid.toString(), "member A", 
                orderSetails);
        order.addOrderDetails(orderSetails);
        orderList.add(order); // Add the order to the order list
        return order; 
    }
    
    /**
     * Generates a sales report summarizing the total quantity sold for each product.
     * 
     * @return A map where keys are product codes and values are total quantities sold.
     */
    @Override
    public Map<String , Integer> createSalesReport() {
        Map<String, Integer> totalQuantityPerProduct = getTotalQuantityPerProduct();
        return totalQuantityPerProduct;    
    }

    /**
     * Returns a list of all available books. This does not display actual customer orders.
     *
     * @return A list of books available in the service.
     */
    @Override
    public List<BooksEntry> viewOrders() {
        return bookList;
    }
    
    /**
     * Calculates the total quantity sold for each product.
     *
     * @return A map where keys are product codes and values are total quantities sold.
     */
    public Map<String, Integer> getTotalQuantityPerProduct() {
        Map<String, Integer> bookSales = new HashMap<>();
        for (BooksOrder order : this.orders) {
            for (BooksOrderDetails detail : order.order_details) {
                String productCode = detail.getItemCode();
                int quantity = detail.getQuantity();
                bookSales.put(productCode, bookSales.getOrDefault(productCode, 0) + quantity);
            }
        }
        return bookSales;
    }
    
    /**
     * Generates a random User object for testing purposes.
     * This utility method is currently unused and serves as a placeholder for future development.
     */
    // public User getRandomUser() {
    //     String[][] userData = {
    //         {"Alice", "alice@example.com"},
    //         {"Bob", "bob@example.com"},
    //         {"Catherine", "catherine@example.com"},
    //         {"Daniel", "daniel@example.com"},
    //         {"Emma", "emma@example.com"},
    //         {"Frank", "frank@example.com"}
    //     };
    //
    //     Random random = new Random();
    //     int randomIndex = random.nextInt(userData.length);
    //
    //     User user = new User(userData[randomIndex][0], userData[randomIndex][1]);
    //     return user;
    // }
}
