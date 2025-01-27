package booknook.partb;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/*
 * BookManagement Class
 * This class is responsible for managing books and their categories in the system.
 * It provides methods to add books, add categories, retrieve book lists, and retrieve category lists.
 */

public class BookManagement implements ProductManagement {

     // List of book categories available in the library
    public List<BooksCategory> categoryList = new ArrayList<>();
    // List of all books available in the library
    public List<BooksEntry> bookList = new ArrayList<>();

    public BookManagement() {
        this.startservice();
    }

    public void startservice() {
        
        // Predefined categories for the library system
        
        BooksCategory[] categories = {
    new BooksCategory(1, "Programming"),
    new BooksCategory(2, "Science Fiction"),
    new BooksCategory(3, "History")
   
};

         // Adding categories to the category list
        categoryList.addAll(Arrays.asList(categories));

        // Predefined books for the library system
        
        BooksEntry[] books = {
    new BooksEntry(1, "T001", "Java Foundations", categoryList.get(0), "Alice Johnson", 39.99),
    new BooksEntry(2, "N001", "Ruby Tales", categoryList.get(1), "Michael Carter", 42.75),
    new BooksEntry(3, "T002", "Advanced Java Concepts", categoryList.get(0), "David Green", 49.99),
    new BooksEntry(4, "NF002", "The Art of Software", categoryList.get(2), "Sarah Thompson", 45.25),
    new BooksEntry(5, "N002", "The Code Chronicles", categoryList.get(1), "Emily Davis", 46.50),
    new BooksEntry(6, "T003", "Clean Code Practices", categoryList.get(0), "Robert Martin", 41.80)
};

        // Adding books to the book list
        bookList.addAll(Arrays.asList(books));

    }

    /*
 * Adds a new book to the system.
 * This method takes a BooksEntry object as input, adds it to the book list,
 * and ensures that the book is properly categorized.
 *
 * @param book The book to be added
 * @return The updated list of books
 */

    public List<BooksEntry> addBook(BooksEntry book) {
        bookList.add(book);
        return bookList;

    }
/*
 * Adds a new category to the system.
 * This method takes a category name as input, creates a new BooksCategory object,
 * and adds it to the category list.
 *
 * @param categoryName The name of the category to be added
 * @return The updated list of categories
 */

    
    public List<BooksCategory> addCategory(String name) {
        // Dynamically generates a new ID based on the current size of the category list
        int id = categoryList.size() + 1;
        // Creates a new category object and adds it to the category list
        BooksCategory category = new BooksCategory(id, name);
        categoryList.add(category);
        // Returns the updated list of categories
        return categoryList;
    }

    /*
 * Retrieves the list of books in the system.
 * This method returns all books currently stored in the book list.
 *
 * @return A list of books
 */
// Returns the list of categories

/*
 * Retrieves the list of categories in the system.
 * This method returns all categories currently stored in the category list.
 *
 * @return A list of categories
 */

    public List<BooksCategory> getCategories() {
        return categoryList;
    }

}

//end