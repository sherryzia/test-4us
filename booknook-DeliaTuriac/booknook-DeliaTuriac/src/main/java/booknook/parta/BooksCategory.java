

package booknook.parta;

/**
 * Represents a category for books, allowing for classification and organization.
 * Each category has a unique ID and a name.
 *
 * @author Delia Turiac 
 */
public class BooksCategory {
    // Unique identifier for the category
    int id;
    // Name of the category
    String name;
    
    /**
     * Default constructor.
     * Creates an instance of BooksCategory with no initial values.
     */
    public BooksCategory() {
    }
    
    /**
     * Parameterized constructor.
     * Allows creating a category with a specified ID and name.
     *
     * @param id The unique ID of the category.
     * @param name The name of the category.
     */
    public BooksCategory(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    /**
     * Retrieves the ID of the category.
     *
     * @return The unique identifier of the category.
     */
    public int getId() {
        return id;
    }
    
    /**
     * Sets a new ID for the category.
     *
     * @param id The unique identifier to assign to the category.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Retrieves the name of the category.
     *
     * @return The name of the category.
     */
    public String getName() {
        return name;
    }

     /**
     * Sets a new name for the category.
     *
     * @param name The name to assign to the category.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Provides a string representation of the category.
     *
     * @return A string containing the category's ID and name.
     */
    @Override
public String toString() {
    return name; // Directly return the category name
}

    

}
