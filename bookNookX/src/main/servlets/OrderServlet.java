package combine.booknook.servlets;

import combine.booknook.parta.BookManagement;
import combine.booknook.parta.BooksEntry;
import combine.booknook.parta.BooksOrder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders/create", "/orders/view"})
public class OrderServlet extends HttpServlet {
    private final BookManagement bookManagement = new BookManagement();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/orders/create".equals(action)) {
            handleOrderCreation(request, response);
        }
    }

    private void handleOrderCreation(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String bookCode = request.getParameter("bookCode");
        BooksEntry book = bookManagement.purchaseBook(bookCode).get(0); // Assume book exists and take the first match

        HttpSession session = request.getSession();
        BooksOrder order = new BooksOrder();
        order.addBookToOrder(book);

        session.setAttribute("order", order); // Save the order in the session
        response.sendRedirect("orders/view"); // Redirect to order view
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getServletPath();
        if ("/orders/view".equals(action)) {
            handleOrderView(request, response);
        }
    }


    private void handleOrderView(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        BooksOrder order = (BooksOrder) session.getAttribute("order");

        if (order != null) {
            request.setAttribute("order", order);
            request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
        } else {
            response.sendRedirect("index.jsp"); // Redirect to home if no orders exist
        }
    }
}
