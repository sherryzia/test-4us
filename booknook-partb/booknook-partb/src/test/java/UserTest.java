
import booknook.partb.BooksCustomer;
import booknook.partb.User;
import java.util.ArrayList;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/**
 * Test class for user
 *
 * @author
 */
public class UserTest {

    BooksCustomer customer = new BooksCustomer();
    List<User> userTestList = new ArrayList<>();
    List<User> loggedInUser;

    @BeforeEach
    public void setup() {
        // took same users from customer classs
        userTestList = customer.userList;
    }

    @Test
    public void loginUserAssertions() {
        assertAll("User login",
                () -> assertNotNull(customer.LoginUser(userTestList.get(1).getEmail(), userTestList.get(1).getPassword())),
                () -> assertEquals("Jone Doe", customer.LoginUser(userTestList.get(1).getEmail(), userTestList.get(1).getPassword()).get(0).getName()),
                () -> assertEquals("jone@dev.com", customer.LoginUser(userTestList.get(1).getEmail(), userTestList.get(1).getPassword()).get(0).getEmail())
        );
    }

    @Test
    public void adminUserAssertions() {
        loggedInUser = customer.LoginUser(userTestList.get(0).getEmail(), userTestList.get(0).getPassword());
        assertAll("Admin User",
                () -> assertEquals("admin@dev.com", loggedInUser.get(0).getEmail()),
                () -> assertEquals("admin", loggedInUser.get(0).getName()),
                () -> assertEquals("admin", loggedInUser.get(0).getUser_role()),
                () -> assertEquals(true, customer.isLoggedIn),
                () -> assertEquals(true, customer.isAdmin)
        );
    }

    @Test
    public void customerAssertions() {
        loggedInUser = customer.LoginUser(userTestList.get(4).getEmail(), userTestList.get(4).getPassword());
        assertAll("Customer User",
                () -> assertEquals("Max Parker", loggedInUser.get(0).getName()),
                () -> assertEquals("max@dev.com", loggedInUser.get(0).getEmail()),
                () -> assertEquals("customer", loggedInUser.get(0).getUser_role()),
                () -> assertEquals(true, customer.isLoggedIn),
                () -> assertEquals(false, customer.isAdmin)
        );
    }

    @Test
    public void updateUserNameOnlyAssertions() {
        String search   = "james";
        String name     =  "jakey";
        String email    =  "";
        String role     =  "";
        String[] newData = {search, name, email, role};
        loggedInUser = customer.LoginUser(userTestList.get(0).getEmail(), userTestList.get(0).getPassword());
        assertAll("Update name only",
                () -> assertNotNull(customer.updateUser(newData)),
                () -> assertNotEquals("james", customer.userList.get(3).getEmail()),
                () -> assertEquals(name, customer.userList.get(3).getName())
        );
        
    }
    @Test
    public void updateUserEmailOnlyAssertions() {
        String search   = "james";
        String name     =  "";
        String email    =  "adams@gmail.com";
        String role     =  "";
        String[] newData = {search, name, email, role};
        loggedInUser = customer.LoginUser(userTestList.get(0).getEmail(), userTestList.get(0).getPassword());
        assertAll("Update email only",
                () -> assertNotNull(customer.updateUser(newData)),
                () -> assertNotEquals("james@dev.com", customer.userList.get(3).getEmail()),
                () -> assertEquals(email, customer.userList.get(3).getEmail())
        );
    }

    @Test
    public void deleteUserAssertions() {
        String email    =  "james@dev.com";
        loggedInUser = customer.LoginUser(userTestList.get(0).getEmail(), userTestList.get(0).getPassword());
        assertAll("Delete",
                () -> assertNotNull(customer.deleteUser(email)),
                () -> assertNotEquals( email, customer.userList.get(3).getEmail())
        );
    }

    @Test
    public void getUserByEmailAssertions() {
        String email    =  "james@dev.com";
        loggedInUser = customer.LoginUser(userTestList.get(0).getEmail(), userTestList.get(0).getPassword());
        assertAll("Get user data by email",
                () -> assertNotNull(customer.getUser(email)),
                () -> assertEquals( email, customer.userList.get(3).getEmail())
        );
    }
    @Test
    public void getUserByNameAssertions() {
        String name    =  "James Adams";
        loggedInUser = customer.LoginUser(userTestList.get(0).getEmail(), userTestList.get(0).getPassword());
        assertAll("Get user data by email",
                () -> assertNotNull(customer.getUser(name)),
                () -> assertEquals( name, customer.userList.get(3).getName())
        );
    }

}
