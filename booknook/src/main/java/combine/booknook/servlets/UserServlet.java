package combine.booknook.servlets;

import combine.booknook.partb.BooksCustomer;
import combine.booknook.partb.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserServlet", urlPatterns = {"/login", "/logout", "/register"})
public class UserServlet extends HttpServlet {
    private final BooksCustomer booksCustomer = new BooksCustomer();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/login".equals(action)) {
            handleLogin(request, response);
        } else if ("/register".equals(action)) {
            handleRegistration(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        List<User> loggedInUsers = booksCustomer.LoginUser(email, password);

        if (!loggedInUsers.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("user", loggedInUsers.get(0)); // Store the logged-in user in the session
            response.sendRedirect("index.jsp"); // Redirect to the home page
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response); // Reload login page with error
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

//        User newUser = new User(booksCustomer.userList.size() + 1, name, email, password, "user");
//        booksCustomer.userList.add(newUser);

        request.setAttribute("message", "Registration successful! Please log in.");
        request.getRequestDispatcher("/login.jsp").forward(request, response); // Redirect to login page
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if ("/logout".equals(action)) {
            assert session != null;
            session.invalidate();
            response.sendRedirect("login.jsp");
        }
    }

}
