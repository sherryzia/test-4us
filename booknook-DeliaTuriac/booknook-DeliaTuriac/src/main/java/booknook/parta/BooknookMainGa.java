/**
 *  Member A's Responsibilities:
 *  1. Enable users to search for books by either the title or the author's name.
 *  2. Provide functionality for users to purchase single or multiple books or accessories.
 *      - This feature should also update sales records for purchased items.
 *      - It relies on the search functionality mentioned above.
 *  3. Allow users to view their order history with details of previous purchases.
 */
package booknook.parta;

import booknook.parta.ui.GuiController;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.UUID;

/**
 * Entry point for the BookNook application, where users can interact with the system.
 * This class includes the main method that initializes and launches the application interface.
 *
 * @author Delia Turiac
 */
public class BooknookMainGa {

    // Scanner instance for user input (if needed for console-based interactions)
    Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        // Initialize the graphical user interface for the application
        GuiController gui = new GuiController();
        
        // Display a welcome message to the users upon starting the application
        System.out.println("\n");
        gui.appStart("Greetings from BookNook! \n Explore a wide range of books and literary accessories.");
        
         


    }

    
}
