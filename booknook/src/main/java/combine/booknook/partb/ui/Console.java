
package combine.booknook.partb.ui;

import booknook.partb.BooksEntry;
import booknook.partb.BooksCategory;
import booknook.partb.User;

import de.vandermeer.asciitable.AsciiTable;
import de.vandermeer.skb.interfaces.transformers.textformat.TextAlignment;
import java.util.ArrayList;
import java.util.List;

/*
 * Console Class
 * Handles the user interface by displaying information in a tabular format using AsciiTable.
 * Provides methods for displaying books, categories, users, and messages.
 */

public class Console {
    
    /*
 * Displays a table with search results for books.
 * If no results are found, an error message is displayed.
 *
 * @param book A list of BooksEntry objects representing search results
 * @param term The search term used
 */

    public void displaySearchTable(List<BooksEntry> book, String term) {
        System.out.println("\n\n\n");
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();

        if (!book.isEmpty()) {
            infoMessage(term, book.size());
            asciiTable.addRow("Book Code", "Book Name", "Book Author", "Book Price");
            asciiTable.addRule();
            for (BooksEntry b : book) {
                asciiTable.addRow(b.getItemCode(), b.getName(), b.getAuthor(), b.getPrice());
                asciiTable.addRule();
            }
            asciiTable.setTextAlignment(TextAlignment.CENTER);

        } else {
            asciiTable.addRow("Search Term", "Result");
            asciiTable.addRule();
            asciiTable.addRow(term, "Ups!! An unexpected error ocurred!");
            asciiTable.addRule();
        }

        String render = asciiTable.render();
        System.out.println(render);
        System.out.println("\n\n\n");
    }

    
    /*
 * Displays a summary message with the search term and the number of items found.
 *
 * @param term The search term used
 * @param size The number of items found
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

    /*
 * Displays a table with the list of books.
 * If the list is not empty, a success message is displayed.
 *
 * @param nbookList A list of BooksEntry objects to be displayed
 */

    public void displayBooks(List<BooksEntry> nbookList){
       
        String bookname ="" ;
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();

        if (!nbookList.isEmpty()) {
            asciiTable.addRow("Book Code", "Book Name", "Book Author", "Category","Book Price");
            asciiTable.addRule();
            for (BooksEntry b : nbookList) {
                asciiTable.addRow(b.getItemCode(), b.getName(), b.getAuthor(),b.getCategory(), b.getPrice());
                asciiTable.addRule();
                bookname = b.getName();
            }
            asciiTable.setTextAlignment(TextAlignment.LEFT);
            String render = asciiTable.render();
            System.out.println(render);

            this.generalMessage(bookname + " Well Done! Successfully created!.");
            System.out.println("\n");

        }
    }
    /*
 * Displays a table with the list of categories.
 * If the list is not empty, a success message is displayed for the last created category.
 *
 * @param catList A list of BooksCategory objects to be displayed
 */

    public void displayCategory(List<BooksCategory> catList){
        String cname ="" ;
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow(null, " List of Categories");
        asciiTable.addRule();
        if (!catList.isEmpty()) {
           asciiTable.addRow("Category ID", "Category Name");
           asciiTable.addRule();
            for (BooksCategory cat : catList) {
                asciiTable.addRow(cat.getId(),cat.getName());
                asciiTable.addRule();
                cname = cat.getName();
            }
            String render = asciiTable.render();
            System.out.println(render);

            this.generalMessage("Category "+cname + " has been created successfully!");
            System.out.println("\n");

        }
    }
    
    /*
 * Displays a table with the list of all users.
 *
 * @param usr A list of User objects to be displayed
 */

    public void displayUsers(List<User> usr) {
        List<User> userList = new ArrayList<>(usr);

        System.out.println("List of all users");
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("User Name", "User Email", "User Role");
        asciiTable.addRule();
        for (User user : userList) {
            asciiTable.addRow(user.getName(), user.getEmail(), user.getUser_role());
            asciiTable.addRule();
        }
        String render = asciiTable.render();
        System.out.println(render);

    }
    /*
 * Displays a table with the list of currently logged-in users.
 *
 * @param usr A list of logged-in User objects to be displayed
 */

    public void displayLoginUsers(List<User> usr) {
        List<User> userList = new ArrayList<>(usr);

        System.out.println("List of login users");
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("Username", "User Email Address", "User Role", "Login Status");
        asciiTable.addRule();
        for (User user : userList) {
            asciiTable.addRow(user.getName(), user.getEmail(), user.getUser_role(), true);
            asciiTable.addRule();
        }
        String render = asciiTable.render();
        System.out.println(render);

    }

    /**
     *
     * @param action
     * @param message
     */
    public void deleteInfoMessage(String action, String message) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("Action", "Result");
        asciiTable.addRule();
        asciiTable.addRow(action,message);
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.LEFT);
        String render = asciiTable.render();
        System.out.println(render);
    }

   /**
    * 
    * @param user 
    */
    public void viewUsers(List<User> user) {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("User Name", "User Type", "Logged In");
        asciiTable.addRule();
        for(User usr: user){
            asciiTable.addRow(usr.getName(), usr.getUser_role(), true);
        }
        
        asciiTable.addRule();
        String render = asciiTable.render();
        System.out.println(render);
    }

 

    /**
     *
     * @param title
     * @param result
     * @param term
     * @param size
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

    /*
 * Displays a general message in a tabular format.
 *
 * @param message The message to be displayed
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
     *
     * @param message
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

    /*
 * Displays the main menu for Group B tasks.
 * Provides options for actions like creating categories, inserting books, logging in, and more.
 */

    public void createStartMenu() {
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("  Group B Tasks");
        asciiTable.addRule();
        asciiTable.addRow("[1]        Create New Category");
        asciiTable.addRow("[2]        Insert New Book");
        asciiTable.addRow("[3]        Login User");
        asciiTable.addRow("[4]        Display User List");
        asciiTable.addRow("[5]        Modify User Details");
        asciiTable.addRow("[6]        Remove User");
        asciiTable.addRow("[7]        Refresh Screen");
        asciiTable.addRow("[8]        Exit");
        asciiTable.addRule();
        asciiTable.addRow("  Select an option [1 ... 8]");
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.JUSTIFIED_LEFT);
        String render = asciiTable.render();
        System.out.println(render);
        
    }

}
