/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */

package combine.booknook.partb;

import java.util.List;

/*
 * UserManagement Interface
 * Defines the operations for managing user accounts within the system.
 * Provides methods for login, deletion, updating, and viewing user accounts.
 *
 * Created by Team B.
 */

public interface UserManagement {

        // GroupB
    /*
 * Authenticates a user based on their email and password.
 * If authentication is successful, the user's login status is updated.
 *
 * @param email    The user's email or username
 * @param password The user's password
 * @return A list containing the authenticated user
 */

        public List<User> LoginUser(String email, String password);
        /*
 * Deletes a user from the system based on their email.
 * If the user is found, they are removed from the user list.
 *
 * @param email The email of the user to delete
 * @return A message indicating success or failure
 */

        public String deleteUser(String email);
        /*
 * Updates the details of an existing user in the system.
 * Modifies fields such as username, email, or role based on input data.
 *
 * @param data An array containing the updated user details
 * @return A list of users with the updated information
 */

        public List<User> updateUser(String[] data);
        /*
 * Retrieves and returns a list of all registered users in the system.
 * This method can be used to display user information.
 *
 * @return A list of all registered users
 */

        public List<User> viewUsers();
        /*
 * Searches for a user in the system based on their username or email.
 * Returns a list containing the matching user or an empty list if no match is found.
 *
 * @param username The username or email of the user to retrieve
 * @return A list containing the matching user
 */

        public List<User> getUser(String username);
}
