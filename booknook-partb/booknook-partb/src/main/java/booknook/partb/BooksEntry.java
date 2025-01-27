/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package booknook.partb;


/*
 * BooksEntry Class
 * Represents a specific entry in the book system, extending BooksProduct.
 * This class includes additional attributes such as author and category.
 */

public class BooksEntry  extends BooksProduct  {
    
    private String author;
    private BooksCategory category;
   
/*
 * Default constructor for BooksEntry.
 * Initializes a new instance of BooksEntry with default values.
 */

    public BooksEntry() {
    }
   
    /*
 * Constructor for BooksEntry with basic details.
 *
 * @param ItemCode The unique code of the book
 * @param name     The name of the book
 * @param price    The price of the book
 * @param category The category of the book
 */

    public BooksEntry(String ItemCode, String name, double price, BooksCategory category) {
        super(ItemCode, name, price, category);
         this.category = category;
    }
     /*
 * Constructor for BooksEntry including the author.
 *
 * @param ItemCode The unique code of the book
 * @param name     The name of the book
 * @param author   The author of the book
 * @param category The category of the book
 * @param price    The price of the book
 */
    public BooksEntry(String ItemCode, String name, String author,  BooksCategory category, double price) {
        super(ItemCode, name, price, category);
        this.author = author; 
        this.category = category;
    }
    
    /*
 * Constructor for BooksEntry with detailed attributes.
 *
 * @param id       The unique identifier of the book entry
 * @param ItemCode The unique code of the book
 * @param name     The name of the book
 * @param category The category of the book
 * @param author   The author of the book
 * @param price    The price of the book
 */


    public BooksEntry(int id, String ItemCode, String name, BooksCategory category, String author,double price) {
        super(ItemCode, name, price, category);
        this.author = author;
        this.category = category;
    }
/*
 * Retrieves the author of the book entry.
 *
 * @return The author of the book
 */

    public String getAuthor() {
        return author;
    }
/*
 * Updates the author of the book entry.
 *
 * @param author The new author of the book
 */

    public void setAuthor(String author) {
        this.author = author;
    }
    /*
 * Converts the book entry into a string representation.
 *
 * @return A string representation of the book entry
 */

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Book{");
        sb.append("ItemCode=").append(this.getItemCode());
        sb.append(", name=").append(this.getName());
        sb.append(", author=").append(author);
        sb.append(", category=").append(category);
        sb.append(", price=").append(this.price);
        sb.append('}');
        return sb.toString();
    }

    

    

}
