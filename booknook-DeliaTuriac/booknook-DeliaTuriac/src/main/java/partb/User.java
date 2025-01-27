/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package partb;

/*
 * User Class
 * Represents a user in the system, including attributes for ID, name, email, password, and role.
 * This class is used to manage both customer and admin users.
 */

public class User {
    int id;
    String name;
    String email;
    String password;
    String user_role;  // will use for either Admin or Customer [user, admin]
/*
 * Default constructor for User.
 * Initializes a new instance of User with default values.
 */

    public User() {
    }
/*
 * Constructor for User with detailed attributes.
 *
 * @param id        The unique identifier of the user
 * @param name      The name of the user
 * @param email     The email of the user
 * @param password  The password of the user
 * @param user_role The role of the user (e.g., admin or customer)
 */

    public User(int id, String name, String email, String password,  String user_role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.user_role = user_role;
    }
/*
 * Retrieves the unique identifier of the user.
 *
 * @return The ID of the user
 */

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

   

    public String getUser_role() {
        return user_role;
    }

    public void setUser_role(String user_role) {
        this.user_role = user_role;
    }
/*
 * Converts the user object to a string representation.
 * This is useful for debugging or logging purposes.
 *
 * @return A string representation of the user
 */

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("UserDao{");
        sb.append("id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", email=").append(email);
        sb.append(", password=").append(password);
        sb.append(", user_role=").append(user_role);
        sb.append('}');
        return sb.toString();
    }
    
   
    

}
