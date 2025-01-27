package combine.booknook.parta;




/**
 * This class defines a BookEntry, a specialized type of Product.
 * It includes attributes unique to books, such as the author and category.
 * The Book class provides constructors, getters, and a custom string representation.
 * 
 * This code has been customized to include additional functionality and descriptive comments.
 * @author Delia Turiac 
 */
public class BooksEntry  extends BooksProduct  {
    // Stores the name of the author of the book
    private String author;
    // Represents the category or genre of the book 
    private BooksCategory category;
   
     
    public BooksEntry() {
    }
    public BooksEntry(String ItemCode, String name, double price, BooksCategory category) {
        super(ItemCode, name, price, category);
        this.category = category;
    }
   
    
     
    public BooksEntry(int id, String ItemCode, String name, BooksCategory category, String author, double price) {
        super(ItemCode, name, price, category);  // Call the constructor of the parent class
        this.author = author;  // Set the author's name
        this.category = category; // Set the book's category
    }


    /**
     * Retrieves the name of the book's author.
     * 
     * @return A string containing the author's name
     */
    public String getAuthor() {
        return author;
    }
    
    /**
     * Updates the author's name for this BooksEntry object.
     * 
     * @param author A string representing the author's full name
     */
    public void setAuthor(String author) {
        this.author = author; // Assign the new author's name
    }
    
    
    /**
     * Provides a detailed summary of the BooksEntry object, formatted as a string.
     * 
     * @return A string describing the book's attributes, including item code, name, 
     *         author, category, and price
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Book{");
        sb.append("ItemCode=").append(this.getItemCode()); // Access item code from the parent class
        sb.append(", name=").append(this.getName());   // Access name from the parent class
        sb.append(", author=").append(author);  // Include the author attribute
        sb.append(", category=").append(category); // Include the category attribute
        sb.append(", price=").append(this.price);  // Access price from the parent class
        sb.append('}');
        return sb.toString();
    }

    

    

    
    
    

}
