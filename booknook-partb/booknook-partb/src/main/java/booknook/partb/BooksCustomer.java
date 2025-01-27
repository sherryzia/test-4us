/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booknook.partb;

import booknook.partb.ui.Console;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

/**
 * This class handles operations specific to customers and their interactions
 * within the library system. It includes functionalities such as login, 
 * managing user accounts, and retrieving user data.
 *
 * Tasks for Group B:
 * - Implement features for customers extending the User class.
 * - Initialize the system with a default list of users.
 * - Perform all actions based on the userList initialized at the start.
 *
 * Developed by: Team B
 */

public class BooksCustomer implements UserManagement {

    Scanner scanner = new Scanner(System.in);
    Console console = new Console();
    public List<User> userList = new ArrayList<>();
    public List<User> loggedInList = new ArrayList<>();
    public String username;
    public boolean isLoggedIn = false;
    public boolean isAdmin = false;

    public BooksCustomer() {

        this.loadUsers();

    }

    /*
 * Utility function to initialize the system with a default list of users.
 * Adds predefined user accounts to the user list for testing and operations.
 */

    private void loadUsers() {
        // create user
        User[] users = {
    new User(1, "admin", "admin@library.com", "admin123", "admin"),
    new User(2, "Alice Smith", "alice@library.com", "pass123", "customer"),
    new User(3, "Bob Johnson", "bob@library.com", "pass123", "customer"),
    new User(4, "Charlie Brown", "charlie@library.com", "pass123", "customer"),
    new User(5, "Diana Prince", "diana@library.com", "pass123", "customer")
};


        userList.addAll(Arrays.asList(users));

    }

/*
 * Authenticates a user based on their email and password.
 * If authentication is successful, the user's login status is updated,
 * and the user is added to the logged-in list.
 *
 * @param email    The user's email or name
 * @param password The user's password
 * @return A list containing the authenticated user
 */

    @Override
    public List<User> LoginUser(String email, String password) {
        for (User user : this.userList) {
            boolean isEmail = false;
            boolean isPassword = false;
            if (user.getEmail().equalsIgnoreCase(email) || user.getName().contains(email)) {
                isEmail = true;
            }
            if (user.getPassword().equalsIgnoreCase(password)) {
                isPassword = true;
            }
            if (isEmail && isPassword) {
                if (user.getUser_role().toLowerCase().equalsIgnoreCase("admin")) {
                    this.isAdmin = true;
                }
                this.isLoggedIn = true;
                this.loggedInList.add(user);
            }
        }
        return loggedInList;

    }

    /*
 * Deletes a user from the system based on their email.
 * If the user is found, they are removed from the user list,
 * and a success message is returned. Otherwise, a failure message is returned.
 *
 * @param email The email of the user to delete
 * @return A success or failure message
 */

    @Override
    public String deleteUser(String email) {
        String message;
        int index = -1;
        String name = "";
        for (User user : this.userList) {
            if (user.getEmail().contentEquals(email)) {
                index = this.userList.indexOf(user);
                name = user.getName();
            }
        }
        if (index != -1) {
            userList.remove(index);
            message = name + " with email [" + email + "] has been deleted.";
        } else {
            message = " User not found with email: [ " + email + "] ";
        }
        return message;
    }

    /*
 * Updates the details of an existing user in the system.
 * Allows modifications to the user's name, email, role, and password.
 *
 * @param data An array containing the updated user details
 * @return The updated list of users
 */

    @Override
    public List<User> updateUser(String[] data) {
        
        int index = -1;
        String password = null;
        String email = null;
        String role = null;
        String name = data[0];
        for (User usr : this.userList) {
            if (usr.getName().toLowerCase().contains(name.toLowerCase())) {
                index = userList.indexOf(usr);
                password = usr.getPassword();
            }
        }
        if (index != -1) {
            if (data.length > 2) {
                if ("".equals(data[1])) {
                    name = this.userList.get(index).getName();
                } else {
                    name = data[1];
                }
                if ("".equals(data[2])) {
                    email = this.userList.get(index).getEmail();
                } else {
                    email = data[2];
                }
                if ("".equals(data[3])) {
                    role = this.userList.get(index).getUser_role();
                } else {
                    role = data[3];
                }
            }else{
                email = this.userList.get(index).getEmail();
                role = this.userList.get(index).getUser_role();
            }

            User updateUser = new User(this.userList.get(index).getId(), name, email, password, role);
            userList.set(index, updateUser);
        } 

        return userList;

    }

    /*
 * Retrieves and returns the list of all registered users in the system.
 * This method can be used to display user information.
 *
 * @return A list of all users
 */

    @Override
    public List<User> viewUsers() {
        return this.userList;

    }

    /*
 * Retrieves a specific user from the system based on their username or email.
 * This method searches the user list for a match and returns the user as a list.
 *
 * @param username The username or email of the user to retrieve
 * @return A list containing the matching user, or an empty list if no match is found
 */

    @Override
    public List<User> getUser(String username) {
        List<User> singleUser = new ArrayList<>();
        for (User usr : this.userList) {
            if (usr.getName().contains(username) || usr.getEmail().equalsIgnoreCase(username)) {
                singleUser.add(usr);
            }
        }

        return singleUser;

    }

}
