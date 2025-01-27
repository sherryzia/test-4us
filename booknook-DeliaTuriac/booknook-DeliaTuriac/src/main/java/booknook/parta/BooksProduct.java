

package booknook.parta;

import java.util.ArrayList;

/**
 * Represents a generic product in the BookNook system.
 * This class serves as a base for all products, including books and other items.
 * It contains fundamental attributes such as ID, item code, name, price, and category,
 * which are shared across various types of products.
 * The class also provides methods to access and modify these attributes,
 * ensuring that product details can be managed efficiently.
 *
 * @author Delia Turiac
 */
public class BooksProduct {
    int id; // Unique identifier for the product
    private String ItemCode; // Unique code representing the product
    String name; // Name of the product
    double price; // Price of the product
    BooksCategory category; // Category of the product
   
    
    // Default constructor
    public BooksProduct() {
    }

    // Constructs a product with specific details
    public BooksProduct(String ItemCode, String name, double price, BooksCategory category) {
        this.ItemCode = ItemCode;
        this.name = name;
        this.price = price;
        this.category = category;
    }

    public BooksCategory getCategory() {
        return category;
    }

    public void setCategory(BooksCategory category) {
        this.category = category;
    }



    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    
    public String getItemCode() {
        return ItemCode;
    }

    public void setItemCode(String ItemCode) {
        this.ItemCode = ItemCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }


    /**
     * Generates a string representation of the product.
     * This method formats the product's details, including its ID, item code, name, and price,
     * into a readable string format. It can be used for logging, debugging, or displaying
     * product information in user interfaces.
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Product{");
        sb.append("id=").append(id);
        sb.append(", ItemCode=").append(ItemCode);
        sb.append(", name=").append(name);
        sb.append(", price=").append(price);
        sb.append(", category=").append(category);
        sb.append('}');
        return sb.toString();
    }
   

    
    

}
