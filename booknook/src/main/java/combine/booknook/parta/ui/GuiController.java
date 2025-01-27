package combine.booknook.parta.ui;

import combine.booknook.parta.BookManagement;
import combine.booknook.parta.BooksEntry;
import combine.booknook.parta.BooksOrder;
import de.vandermeer.asciitable.AsciiTable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

/**
 * The GuiController class acts as a central hub for user interactions.
 * It connects the user interface with the service layer, handling inputs and displaying outputs.
 */
public class GuiController {

    Scanner scanner = new Scanner(System.in);
    Console console = new Console();
    BookManagement bs = new BookManagement();
    List<BooksEntry> pBooks = new ArrayList<>();
    BooksOrder order = new BooksOrder();

     /**
     * Starts the application by clearing the screen and presenting the main menu.
     *
     * @param message Welcome message displayed on startup.
     */
    public void appStart(String message) {
        this.clearScreen();
        console.appStart(message);
        this.processMenu();
    }

     /**
     * Clears the console screen depending on the operating system.
     */
    public void clearScreen() {
        final String os = System.getProperty("os.name");
        try {
            if (os.contains("Windows")) {
                new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
            } else if (os.contains("Mac")) {
                new ProcessBuilder("sh", "-c", "clear").inheritIO().start().waitFor();
            }
        } catch (IOException | InterruptedException e) {
            System.out.println(e);
        }
    }

    /**
     * Allows the user to search for books by author or title.
     */
    public void searchBook() {
        this.clearScreen();
        //List<Book> bookList = new ArrayList<>();
        System.out.println("=".repeat(80));
        System.out.println("SEARCH BOOK");

        System.out.println("-".repeat(80));
        System.out.println("Please enter the name of the author or book:");
        String input = scanner.nextLine();
        System.out.println("-".repeat(80));
        System.out.println("\n");
        List<BooksEntry> bookList = bs.searchBook(input);
        if (!bookList.isEmpty()) {
            console.displaySearchResult(bookList, input);
        } else {
            console.generalMessage("Searching for " + input);
            console.generalMessage("Oops! No results were found for your query: [ " + input + " ]");
        }
    }

    /**
     * Displays a report of all sales, including quantities and total revenue.
     */
    public void viewSales() {
        this.clearScreen();
        Map<String, Integer> totalQuantityPerProduct = bs.getTotalQuantityPerProduct();
        if (!totalQuantityPerProduct.isEmpty()) {
            double price = 0;
            double totalPrice = 0;
            String name = null;

            System.out.println("=".repeat(80));
            System.out.println("VIEW SALES");
            System.out.println("-".repeat(80));

            AsciiTable asciiTable = new AsciiTable();
            asciiTable.addRule();
            asciiTable.addRow(null, null, null, "Sales report");
            asciiTable.addRule();
            asciiTable.addRow("Book Code", " book Name", "Quantity", "Item Total Sale");
            asciiTable.addRule();

            for (String productCode : totalQuantityPerProduct.keySet()) {
                for (BooksEntry b : bs.bookList) {
                    if (b.getItemCode().contains(productCode)) {
                        price = b.getPrice();
                        name = b.getName();
                    }
                }
                totalPrice += totalQuantityPerProduct.get(productCode) * price;
                asciiTable.addRow(productCode, name, totalQuantityPerProduct.get(productCode), String.format("%,.2f", totalQuantityPerProduct.get(productCode) * price));
            }
            asciiTable.addRule();
            asciiTable.addRow("-", "-", "Over all Total", String.format("%,.2f", totalPrice));
            asciiTable.addRule();
            String render = asciiTable.render();
            System.out.println(render);
        } else {
            AsciiTable asciiTable = new AsciiTable();
            asciiTable.addRule();
            asciiTable.addRow( "Preparing the sales report...");
            asciiTable.addRule();
            asciiTable.addRow("No purchases have been made yet. ");
            asciiTable.addRule();
            String render = asciiTable.render();
            System.out.println(render);
        }

    }

    /**
     * Displays all orders placed by users.
     */
    public void viewOrders() {
    this.clearScreen();
    System.out.println("=".repeat(80));
    System.out.println("ORDER DETAILS");
    System.out.println("-".repeat(80));
    if (order.books.isEmpty()) {
        console.generalMessage("No orders have been placed yet.");
    } else {
        for (BooksEntry book : order.books) {
            System.out.println("Item Code: " + book.getItemCode());
            System.out.println("Name: " + book.getName());
            System.out.println("Author: " + book.getAuthor());
            System.out.println("Category: " + book.getCategory());
            System.out.println("Price: $" + book.getPrice());
            System.out.println("-".repeat(80));
        }
        console.displayOrders(order.books);
    }
}

    /**
     * Facilitates the process of searching, selecting, and purchasing books.
     */
    public void purchaseBook() {
        this.clearScreen();
        boolean isShopping = true;
        boolean searchBook = true;
        System.out.println("=".repeat(80));
        System.out.println("PURCHASE BOOK");
        System.out.println("-".repeat(80));

        while (isShopping) {

            int res = 0;
            String userInput = null;
            if (searchBook) {
                System.out.println("Start by searching for a book or author:");
                this.searchBook();
            }
            if (res != 0) {
                System.out.println("Start by searching for a book or author:");
                this.searchBook();
            }
            boolean itemFound = false;
            while (!itemFound) {
                System.out.printf("Please enter the code of the book you'd like to purchase:%n");
                userInput = scanner.next();
                pBooks = bs.purchaseBook(userInput);
                if (pBooks.isEmpty()) {
                    System.out.println("That book code doesn't seem to exist. Try again.");
                    itemFound = false;
                } else {
                    itemFound = true;
                    order.addBookToOrder(pBooks.get(0));
                }
            } // item found loop

            System.out.printf("Would you like to add more items to your purchase? [Y]/[N] %n");
            Character userChoiceChar = scanner.next().toUpperCase().charAt(0);
            String userChoice = userChoiceChar.toString();
            boolean userChoiceFlag = true;
            while (userChoiceFlag) {
                if (userChoice.equalsIgnoreCase("Y")) {
                    searchBook = false;
                    isShopping = true;
                    userChoiceFlag = false;
                } else if (userChoice.equalsIgnoreCase("N")) {
                    isShopping = false;
                    userChoiceFlag = false;
                    // If the user does not type Y or N, they will be in this loop until so.
                } else {
                    System.out.println("Invalid input. Please type [Y] or [N].");
                    isShopping = false;
                    userChoiceFlag = true;
                    userChoiceChar = scanner.next().charAt(0);
                    userChoice = userChoiceChar.toString();
                }
            }
        }// shopping loop

    }

    /**
     * Displays the main menu and processes user actions based on their selection.
     */
    public void processMenu() {

        Scanner scanner = new Scanner(System.in);
        boolean user_action = true;


        while (user_action) {
            int userInput = 0;
            console.createStartMenu();
            String key = scanner.next();
            try {
                userInput = Integer.parseInt(key);


                switch (userInput) {
                    case 1:
                        this.searchBook();
                        break;
                    case 2:
                        this.purchaseBook();
                        break;
                    case 3:
                        this.viewOrders();
                        break;
                    case 4:
                        this.viewSales();
                        break;
                    case 5:
                        this.clearScreen();
                        break;
                    case 6:
                        //console.generalMessage("Thank you for using BookNook.");
                        //System.exit(0);
                        user_action = false;
                    default:
                        break;
                }

            } catch (Exception e) {
                System.out.println("Please Enter numbers only");
            }
        }

    }

}
