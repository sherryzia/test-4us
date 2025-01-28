package combine.booknook.partb.ui;

import combine.booknook.partb.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/*
 * GuiController Class
 * Acts as a controller that mediates between the user interface (Console class) and the backend services.
 * Handles user actions, passes data to service classes, and displays results on the console.
 */

public class GuiController {

    Console console = new Console();

    BooksCustomer cust = new BooksCustomer();
    BookManagement bs = new BookManagement();

    /*
 * Displays a welcome message and initiates the application menu.
 *
 * @param message A string containing the welcome message to display
 */

    public void appStart(String message) {
        this.clearScreen();
        console.appStart(message);
        this.processMenu();

    }

    /*
 * Utility method to clear the console screen.
 * Works for both Windows and Mac systems.
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

    /*
 * Collects user input to add a new book and displays the updated list of books.
 *
 * Interacts with the BookManagement service to handle book addition.
 */

    public void addBook() {
        this.clearScreen();
        List<BooksEntry> nbookList = new ArrayList<>();
        Scanner scanner = new Scanner(System.in);
        try {
            System.out.println("-".repeat(80));
            System.out.println("\tBOOK DETAILS");
            System.out.println("-".repeat(80));
            System.out.println("Please enter the unique code for the book:");
            String code = scanner.nextLine();
            System.out.println("Please enter the title of the book:");
            String name = scanner.nextLine();
            System.out.println("Please provide the author's full name:");
            String author = scanner.nextLine();
            System.out.println("Please specify the category for the book:");
            String category = scanner.nextLine();
            System.out.println("Please enter the price of the book (numeric value):");
            double price = scanner.nextDouble();
            System.out.println("-".repeat(80));
            bs.addCategory(category);
            BooksCategory categoryName = new BooksCategory(1, category);
            BooksEntry book = new BooksEntry(code, name, author, categoryName, price);

            nbookList = bs.addBook(book);

            if (!nbookList.isEmpty()) {
                console.displayBooks(nbookList);
            }

        } catch (Exception ex) {
            System.out.println("-".repeat(80));
            console.generalMessage("Invalid input. Please ensure the price is entered as a numeric value.");

        }

    }
    
     /*
 * Collects user input to add a new category and displays the updated list of categories.
 *
 * Interacts with the BookManagement service to handle category addition.
 */

    public void addCategory() {
        this.clearScreen();
        List<BooksCategory> catList = new ArrayList<>();
        Scanner scanner = new Scanner(System.in);
        try {
            System.out.println("=".repeat(80));
            System.out.println("Add new Category");
            System.out.println("-".repeat(80));
            System.out.println("Enter category name");
            String name = scanner.next();
            
            catList = bs.addCategory(name);
            if (!catList.isEmpty()) {
                console.displayCategory(catList);
            }
        } catch (Exception ex) {
            System.out.println("-".repeat(80));
            console.generalMessage("Only characters allowed");
        }

    }

     /*
 * Allows an admin to update the details of an existing user.
 * Displays the updated user details if the operation is successful.
 */

    public void updateUser() {
        this.clearScreen();
        
        if (cust.isAdmin && cust.isLoggedIn) {
            Scanner scanner = new Scanner(System.in);
            System.out.println("-".repeat(80));
            System.out.println("Enter the email address or username of the user to update:");
            String username_ex = scanner.nextLine();
            this.getUser(username_ex);
        } else {
            console.generalMessage("You do not have the necessary permissions to modify user details.");
        }

    }

    /*
 * Handles user login by collecting credentials and validating them.
 * Displays the list of logged-in users if successful or an error message otherwise.
 *
 * Interacts with the BooksCustomer service for authentication.
 */

    public void loginUser() {
        this.clearScreen();
        List<User> loginList = new ArrayList<>();
        Scanner scanner = new Scanner(System.in);
        System.out.println("-".repeat(80));
        System.out.println("Enter name or email");
        String email = scanner.nextLine();
        System.out.println("Enter password");
        String password = scanner.nextLine();

        loginList = cust.LoginUser(email, password);
        if (!loginList.isEmpty()) {
            console.displayLoginUsers(loginList);
        } else {
            console.generalMessage("Login credentials are invalid.");
        }
    }
    
    public void getUser(String name){
        Scanner scanner = new Scanner(System.in);
        List<User> userList = new ArrayList<>();
        List<User> updatedList = new ArrayList<>();
        userList = cust.getUser(name);
        if (!userList.isEmpty()) {
            console.displayUsers(userList);
            
            System.out.println("Enter new username");
            String newName = scanner.nextLine();
            System.out.println("Enter email ");
            String email = scanner.nextLine();
            System.out.println("Enter User"
                    + " Role");
            String role = scanner.nextLine();
            System.out.println("-".repeat(80));
            System.out.println("\n");
            
            String[] newData = {name, newName, email, role};
            updatedList = cust.updateUser(newData);
            if (!updatedList.isEmpty()) {
                console.displayUsers(updatedList);
            }else{
                System.out.println("An issue occurred while updating the user. Please try again.");
            }
        } else{
            console.generalMessage("No user was found with the provided details.");
        }
        
    }

    /*
 * Displays a list of all registered users in the system.
 * This method is accessible only to admin users who are logged in.
 */

    public void viewUsers() {
        this.clearScreen();
        // check if user logged in and user is admin
        List<User> userList = new ArrayList<>();
        if (cust.isAdmin && cust.isLoggedIn) {
            userList = cust.viewUsers();
            if (!userList.isEmpty()) {
                console.displayUsers(userList);
            }
        } else {
            console.generalMessage("You do not have permission to view user information.");
        }
    }

    /*
 * Deletes a user from the system based on their email.
 * Displays a confirmation message if the deletion is successful.
 * This method is accessible only to admin users who are logged in.
 */

    public void deleteUser() {
        this.clearScreen();
        Scanner scanner = new Scanner(System.in);
        if (cust.isAdmin && cust.isLoggedIn) {
            System.out.println("Enter email");
            String email = scanner.nextLine();
            String response = cust.deleteUser(email);
            console.deleteInfoMessage("Delete User", response);
        } else {
            console.generalMessage("You do not have permission to delete users.");
        }
    }

    /*
 * Displays the main menu and processes user input to execute actions.
 *
 * Includes options for adding books, managing categories, and user operations.
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
                        this.addCategory();
                        break;
                    case 2:
                        this.addBook();
                        break;
                    case 3:
                        this.loginUser();
                        break;
                    case 4:
                        this.viewUsers();
                        break;
                    case 5:
                        this.updateUser();
                        break;
                    case 6:
                        this.deleteUser();
                        break;
                    case 7:
                        this.clearScreen();
                        break;
                    case 8:
                        user_action = false;
                    default:
                        break;
                }

            } catch (Exception e) {
                System.out.println("Please input numeric values only");
            }

        }

    }

}
