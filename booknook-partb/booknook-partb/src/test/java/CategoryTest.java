
import booknook.partb.BooksEntry;
import booknook.partb.BookManagement;
import booknook.partb.BooksCategory;
//import com.solent.booknook.gb.Order;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import org.junit.jupiter.api.BeforeEach;

import org.junit.jupiter.api.Test;

/**
 *
 * @author
 */
public class CategoryTest {

    public static List<BooksCategory> categoryList = new ArrayList<>();
    public List<BooksEntry> bookList = new ArrayList<>();
    //public Order order;

    @BeforeEach
    public void setup() {
        BooksCategory[] categories = {
            new BooksCategory(1, "Programing"),
            new BooksCategory(2, "Fiction"),
            new BooksCategory(3, "Non-Fiction")
        };

        categoryList.addAll(Arrays.asList(categories));

        BooksEntry[] books = {
            new BooksEntry(1, "P0001", "Thinking in Java", categoryList.get(1), "Bruce Eckel", 43.50),
            new BooksEntry(2, "F0001", "Hello Ruby", categoryList.get(2), "Carlos Bueno", 44.50),
            new BooksEntry(3, "P0002", "Effective Java", categoryList.get(1), "Joshua Bloch", 49.50),
            new BooksEntry(4, "NF001", "Brown Dogs & Barbers", categoryList.get(2), "Karl Beecher", 45.50),
            new BooksEntry(5, "F0002", "Lauren Ipsum", categoryList.get(2), "Carlos Bueno", 47.50),
            new BooksEntry(6, "P0003", "Design Patterns", categoryList.get(1), "Erich Gamma", 42.50)
        };
        bookList.addAll(Arrays.asList(books));
    }

    @Test
    public void categoryListNotEmptyAssertions() {
        assertNotEquals(0, categoryList.size());

    }

    @Test
    public void categoryListHasIdAssertions() {
        assertEquals(1, categoryList.get(0).getId());

    }

    @Test
    public void categoryListHasNameAssertions() {
        assertEquals("Programing", categoryList.get(0).getName());

    }

    @Test
    public void addNewCategoryAssertions() {
        BookManagement bs = new BookManagement();
        int size = bs.getCategories().size();
        bs.addCategory("Social");
        assertEquals("Social", bs.getCategories().get(size).getName());

    }

}
