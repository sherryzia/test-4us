<%@ page import="java.util.List" %>
<%@ page import="combine.booknook.parta.BooksEntry" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Books</title>
</head>
<body>
    <h1>Available Books</h1>
<form action="books/search" method="get">
        <label for="search">Search Books:</label>
        <input type="text" id="search" name="query" placeholder="Enter book title or author" />
        <button type="submit">Search</button>
    </form>

    <table border="1">
        <thead>
            <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Author</th>
                <th>Category</th>
                <th>Price</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<BooksEntry> books = (List<BooksEntry>) request.getAttribute("books");
                if (books != null) {
                    for (BooksEntry book : books) {
            %>
            <tr>
                <td><%= book.getItemCode() %></td>
                <td><%= book.getName() %></td>
                <td><%= book.getAuthor() %></td>
                <td><%= book.getCategory().getName() %></td>
                <td><%= book.getPrice() %></td>
                <td>
                    <form action="OrderServlet" method="post">
                        <input type="hidden" name="bookCode" value="<%= book.getItemCode() %>" />
                        <button type="submit">Purchase</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="6">No books available</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
