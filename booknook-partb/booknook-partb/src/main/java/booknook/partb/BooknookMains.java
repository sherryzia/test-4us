/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
/**
/**
 *  Team Member B Responsibilities:
 *
 *  1. Administrators can manage the addition of books, literary items, and book categories.
 *  2. Users have access to log in by providing their username and password.
 *     - The application differentiates between regular users and admin roles.
 *  3. Administrators have the capability to view all registered users in the system.
 *  4. Admins can modify or remove user data by providing a username and updated details.
 *
 */
package booknook.partb;

import booknook.partb.ui.Console;
import booknook.partb.ui.GuiController;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/*
 * BooknookMains Class
 * This class serves as the entry point for the application.
 * It initializes the system, displays the main menu, and manages high-level interactions
 * between the user and the backend services.
 */

public class BooknookMains {

    public static List<User> loginList = new ArrayList<>();
    public static List<User> userList = new ArrayList<>();

    /*
 * The main method of the application.
 * This method initializes the application by creating an instance of GuiController
 * and displaying the welcome message to the user.
 *
 * @param args Command-line arguments passed to the application
 */


    public static void main(String[] args) {
        GuiController gui = new GuiController();
        System.out.println("\n");
        gui.appStart("Welcome to the Library Management System \n Explore our collection and manage your library with ease.");

    }

 
}
   //end