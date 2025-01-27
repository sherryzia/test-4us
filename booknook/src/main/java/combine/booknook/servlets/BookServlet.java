package combine.booknook.servlets;

import combine.booknook.parta.BookManagement;
import combine.booknook.parta.BooksEntry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/books/search")
public class BookServlet extends HttpServlet {
    private final BookManagement bookManagement = new BookManagement();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String query = request.getParameter("query");
        List<BooksEntry> results = bookManagement.searchBook(query);
        request.setAttribute("books", results);
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }

}
