package combine.booknook.parta.ui;

import booknook.parta.BooksCategory;
import booknook.parta.BooksEntry;
import booknook.parta.BooksOrder;
import de.vandermeer.asciitable.AsciiTable;
import de.vandermeer.skb.interfaces.transformers.textformat.TextAlignment;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Scanner;


/**
 * Console class provides user interaction menus and formatted outputs.
 * It uses ASCII tables to display structured information for tasks like book search,
 * order viewing, and sales reporting.
 *
 * @author Delia Turiac
 */
public class Console {

    
    BooksOrder order = new BooksOrder();
    /**
     * Displays search results in a table format.
     *
     * @param book List of books matching the search term.
     * @param term The search keyword used by the user.
     */
    public void displaySearchResult(List<BooksEntry> book, String term) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        this.generalMessage("Searching for " + term);
        this.generalMessage("Found " + book.size() + " item(s)");
        asciiTable.addRow("Book Code", "Book Name", "Book Author", "Book Price", "Category");
        asciiTable.addRule();
        for (BooksEntry b : book) {
            asciiTable.addRow(b.getItemCode(), b.getName(), b.getAuthor(), b.getPrice(), b.getCategory());
            asciiTable.addRule();
        }
        asciiTable.setTextAlignment(TextAlignment.LEFT);

        String render = asciiTable.render();
        System.out.println(render);

    }

    /**
     * Fetches the current date and time in a formatted string.
     *
     * @return The current date and time in "dd-MM-yyyy HH:mm:ss" format.
     */
    public String getTodaysData() {
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
        return myDateObj.format(myFormatObj);
    }


    /**
     * Displays a user's order in a structured table format.
     *
     * @param book List of books included in the user's order.
     */
    public void displayOrders(List<BooksEntry> book) {
        double total = 0.00;
        AsciiTable at = new AsciiTable();
        at.addRule();
        at.addRow(null, null, null, null, "Order Data"); // header row
        at.addRow(null, null, null, null, getTodaysData()); // value row
        at.addRule();
        at.addRow("Book Code", null, "Book Name", "Book Author", "Category", "Book Price");
        at.addRule();
        for (BooksEntry b : book) {
            at.addRow(b.getItemCode(), null, b.getName(), b.getAuthor(), b.getCategory(), String.format("%,.2f",b.getPrice()));
        }
        at.addRule();
        at.addRow("-", "-", "-", "Order Total", String.format("%,.2f",total += order.getTotalPrice(book)));
        at.addRule();
        at.setTextAlignment(TextAlignment.LEFT);
        System.out.println(at.render(80));
    }
   

    /**
     * Displays a summary message showing a search term and the number of results.
     *
     * @param term The term searched by the user.
     * @param size Number of matching results.
     */
    public void infoMessage(String term, int size) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("Search Term", "Result");
        asciiTable.addRule();
        asciiTable.addRow(term, size + " item(s)");
        asciiTable.addRule();
        String render = asciiTable.render();
        System.out.println(render);
    }

    /**
     * Displays a deletion action summary with the performed action and its result.
     *
     * @param action The action performed (e.g., "Delete").
     * @param message The result or feedback for the action.
     */
    public void deleteInfoMessage(String action, String message) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("Action", "Result");
        asciiTable.addRule();
        asciiTable.addRow(action, message);
        asciiTable.addRule();
        String render = asciiTable.render();
        System.out.println(render);
    }

    /**
     * Displays a customized action message with additional details.
     *
     * @param title The title of the action performed.
     * @param result The result or outcome of the action.
     * @param term The search or action term related to the operation.
     * @param size The number of affected items.
     */
    public void actionMessage(String title, String result, String term, int size) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow(title, result);
        asciiTable.addRule();
        asciiTable.addRow(term, size + " item(s)");
        asciiTable.addRule();
        String render = asciiTable.render();
        System.out.println(render);
    }

    /**
     * Prints a general informational message in a formatted table.
     *
     * @param message The message to display to the user.
     */
    public void generalMessage(String message) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow(message);
        asciiTable.addRule();
        String render = asciiTable.render();
        System.out.println(render);

    }

    /**
     * Displays the startup message in a centred table format.
     *
     * @param message Welcome message shown at application startup.
     */
    public void appStart(String message) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow(message);
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.CENTER);
        String render = asciiTable.render();
        System.out.println(render);
    }

    /**
     * Creates a user-friendly main menu for navigation and displays options.
     */
    public void createStartMenu() {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("   BookNook Main Ga Menu");
        asciiTable.addRule();
        asciiTable.addRow("[1] Search for a Book");
        asciiTable.addRow("[2] Purchase a Book");
        asciiTable.addRow("[3] View Your Orders");
        asciiTable.addRow("[4] Check Sales Reports");
        asciiTable.addRow("[5] Clear Screen");
        asciiTable.addRow("[6] Exit Application");
        asciiTable.addRule();
        asciiTable.addRow("  Select an option [1 ... 6]");
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.JUSTIFIED_LEFT);
        String render = asciiTable.render();
        System.out.println(render);
        
    }
    
    
    

}
