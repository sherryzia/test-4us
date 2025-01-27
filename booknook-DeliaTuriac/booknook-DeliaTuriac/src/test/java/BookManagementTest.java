import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import booknook.parta.BooksEntry;
import booknook.parta.BookManagement;
import booknook.parta.BooksCategory;
import booknook.parta.BooksOrder;


/**
 * Test class for BookManagement.
 * Verifies the functionality of methods for managing books, categories, orders, and related operations.
 */
public class BookManagementTest {

    public static List<BooksCategory> categoryList = new ArrayList<>();
    public List<BooksEntry> bookList = new ArrayList<>();
    public  BooksOrder order;
    

    BookManagement bs = new BookManagement();

    /**
     * Sets up test data before each test.
     * Populates categoryList and bookList with sample data.
     */
    @BeforeEach
    public void setup() {
        BooksCategory[] categories = {
            new BooksCategory(1, "Science Fiction"),
            new BooksCategory(2, "Mystery & Thriller"),
            new BooksCategory(3, "Health")
        };

        categoryList.addAll(Arrays.asList(categories));

         BooksEntry[] books = {
            new BooksEntry(1, "S0001", "Dune", categoryList.get(0), "Frank Herbert", 39.99),
            new BooksEntry(2, "M0001", "The Girl with the Dragon Tattoo", categoryList.get(1), "Stieg Larsson", 45.50),
            new BooksEntry(3, "H0001", "Atomic Habits", categoryList.get(2), "James Clear", 29.99),                 
            new BooksEntry(4, "S0002", "Sapiens: A Brief History of Humankind", categoryList.get(0), "Yuval Noah Harari", 50.00),
            new BooksEntry(5, "M0002", "Gone Girl", categoryList.get(1), "Gillian Flynn", 41.99),
            new BooksEntry(6, "H0002", "The Power of Habit", categoryList.get(2), "Charles Duhigg", 31.50),
        };
        bookList.addAll(Arrays.asList(books));    
    }

    /**
     * Tests grouped assertions for book details.
     */
    @Test
    public void groupedAssertions() {
        assertAll("Book details",
                () -> assertEquals("S0001", bookList.get(0).getItemCode()),
                () -> assertEquals("Dune", bookList.get(0).getName()),
                () -> assertEquals("Frank Herbert", bookList.get(0).getAuthor()),
                () -> assertEquals(39.99, bookList.get(0).getPrice()),
                () -> assertEquals("Science Fiction", categoryList.get(0).getName())
        );
    }

    /**
     * Verifies the searchBook method for valid query handling.
     */
    @Test
    public void SearchBookAssertion() {
        String query = "java";
        assertAll("Book details",
                () -> assertNotNull(bs.searchBook(query))
        );
    }

    /**
     * Tests book properties like name, author, and price.
     */
    @Test
    public void propertiesAssetions() {
        assertAll("properties",
                () -> {
                    String bookName = bookList.get(0).getName();
                    assertNotNull(bookName);
                    assertAll("Book name",
                            () -> assertTrue(bookName.startsWith("D")),
                            () -> assertTrue(bookName.endsWith("e"))
                    );
                },
                () -> {
                    String authorName = bookList.get(0).getAuthor();
                    assertNotNull(authorName);
                    assertAll("Author name",
                            () -> assertTrue(authorName.startsWith("F")),
                            () -> assertTrue(authorName.endsWith("t"))
                    );
                },
                () -> {
                    double bookPrice = bookList.get(0).getPrice();
                    assertNotNull(bookPrice);
                    assertAll("Book price",
                            () -> assertNotEquals(0, bookList.get(0).getPrice()),
                            () -> assertEquals(39.99, bookList.get(0).getPrice())
                    );
                }
        );
    }
    
    /**
     * Verifies purchaseBook method creates a valid purchase.
     */
    @Test
    public void purchaseAssertions(){
        List<BooksEntry> purchased = bs.purchaseBook("S0001");
        assertAll("Purchase a book",
              () -> assertNotNull(purchased),
              () -> assertEquals("S0001",purchased.get(0).getItemCode()),
              () -> assertEquals("Science Fiction",purchased.get(0).getCategory().getName())
        ); 
    }
    
     /**
     * Verifies order creation and details.
     */
    @Test
    public void ordersAssertions(){
        BooksEntry book =new BooksEntry(1, "S0001", "Dune", categoryList.get(1), "Frank Herbert", 39.99);
        order = bs.createOrder(book); 
        
        
        assertAll("Create Order",
              () -> assertNotNull(order),
              () -> assertEquals("S0001",order.order_details.get(0).getItemCode()),
              () -> assertEquals("Dune",order.order_details.get(0).getName()),
              () -> assertEquals(39.99,order.order_details.get(0).getPrice()),
              () -> assertEquals(1,order.order_details.get(0).getQuantity())
        );
    }
    
    /**
     * Tests sales reporting functionality.
     */
    @Test
    public void salesAssertions(){
       
        BooksEntry[] book =
        { 
            new BooksEntry(1, "S0001", "Dune", categoryList.get(1), "Frank Herbert", 39.99),
            new BooksEntry(2, "M0001", "The Girl with the Dragon Tattoo", categoryList.get(2), "Stieg Larsson", 45.50),
            new BooksEntry(3, "H0001", "Atomic Habits", categoryList.get(3), "James Clear", 29.99),                 
            new BooksEntry(4, "S0002", "Sapiens: A Brief History of Humankind", categoryList.get(1), "Yuval Noah Harari", 50.00),
            new BooksEntry(5, "M0002", "Gone Girl", categoryList.get(2), "Gillian Flynn", 41.99),
            new BooksEntry(6, "H0002", "The Power of Habit", categoryList.get(3), "Charles Duhigg", 31.50)
        };
        for(int idx = 0; idx <= book.length-1; idx ++){
            order = bs.createOrder(book[idx]);
        }
        assertAll("Sales report",
              () -> assertNotNull(bs.getTotalQuantityPerProduct()),
              () -> assertEquals("H0002", order.order_details.get(0).getItemCode()),
              () -> assertEquals("The Power of Habit",order.order_details.get(0).getName()),
              () -> assertEquals(238.97000000000003,bs.orderList.get(0).getTotalPrice(bookList)),
              () -> assertEquals(1, order.order_details.get(0).getQuantity())
        );
    }

}