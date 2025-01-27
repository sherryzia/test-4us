
package booknook.parta;

import java.util.ArrayList;

/**
 * Represents the details of a specific order item, extending the BooksProduct class.
 * This includes the product, its quantity, and related attributes.
 *
 * @author Delia Turiac
 */
public class BooksOrderDetails  extends BooksProduct{

    private int id, quantity; // Unique ID and quantity for the order item
    BooksProduct product; // Product associated with this order detail
   
    
    /**
     * Default constructor for initializing an empty order detail.
     */
    public BooksOrderDetails() {
        super();
    }


    /**
     * Constructs order details with specific product information and quantity.
     *
     * @param ItemCode Unique code for the item.
     * @param name Name of the product.
     * @param price Price of the product.
     * @param category Category of the product.
     * @param quantity Quantity of the product ordered.
     */
     public BooksOrderDetails(String ItemCode, String name, double price, BooksCategory category, int quantity) {
        super(ItemCode, name, price, category);
        this.quantity = quantity;
    }

     /**
     * Constructs order details using an ID and quantity.
     *
     * @param id Unique identifier for the order detail.
     * @param quantity Quantity of the product ordered.
     */
    public BooksOrderDetails(int id, int quantity) {
        this.id = id;
        this.quantity = quantity;
    }

    // Getter and setter methods for ID and quantity
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BooksProduct getProduct() {
        return product;
    }

    public void setProduct(BooksProduct product) {
        this.product = product;
    }

    // Getter and setter methods for name and price, inherited from BooksProduct
    
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
     * Provides a string representation of the order details, including product information and quantity.
     *
     * @return A formatted string summarizing the order details.
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("OrderDetails{");
        sb.append("ItemCode=").append(this.getItemCode());
        sb.append(", ItemName=").append(this.getName());
        sb.append(", ItemCategory=").append(this.getCategory());
        sb.append(", quantity=").append(quantity);
       
        sb.append('}');
        return sb.toString();
    }

}
