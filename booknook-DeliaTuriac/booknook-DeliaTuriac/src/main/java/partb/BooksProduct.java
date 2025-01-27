/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package partb;

/*
 * BooksProduct Class
 * Represents a generic product in the book system.
 * This class includes attributes such as ID, item code, name, price, and category.
 */

public class BooksProduct {
    int id;
    private String ItemCode;
    String name;
    double price;
    BooksCategory category;
   
    
/*
 * Default constructor for BooksProduct.
 * Initializes a new instance of BooksProduct with default values.
 */

    public BooksProduct() {
    }
/*
 * Constructor for BooksProduct with basic details.
 *
 * @param ItemCode The unique code of the product
 * @param name     The name of the product
 * @param price    The price of the product
 * @param category The category of the product
 */

    public BooksProduct(String ItemCode, String name, double price, BooksCategory category) {
        this.ItemCode = ItemCode;
        this.name = name;
        this.price = price;
        this.category = category;
    }
/*
 * Retrieves the category of the product.
 *
 * @return The category of the product
 */

    public BooksCategory getCategory() {
        return category;
    }
/*
 * Updates the category of the product.
 *
 * @param category The new category of the product
 */

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


/*
 * Converts the product to a string representation.
 *
 * @return A string representation of the product
 */

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Product{");
        sb.append("id=").append(id);
        sb.append(", ItemCode=").append(ItemCode);
        sb.append(", name=").append(name);
        sb.append(", price=").append(price);
        //sb.append(", category=").append(category);
        sb.append('}');
        return sb.toString();
    }

    
    
    

}
