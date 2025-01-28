<%@ page import="java.util.List" %>
<%@ page import="combine.booknook.parta.BooksOrder" %>
<%@ page import="combine.booknook.parta.BooksOrderDetails" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Your Orders</title>
</head>
<body>
    <h1>Your Orders</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Book Name</th>
                <th>Author</th>
                <th>Quantity</th>
                <th>Total Price</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<BooksOrder> orders = (List<BooksOrder>) request.getAttribute("orders");
                if (orders != null) {
                    for (BooksOrder order : orders) {
                        for (BooksOrderDetails details : order.getOrderDetails()) {
            %>
            <tr>
                <td><%= order.getId() %></td>
                <td><%= details.getName() %></td>
                <td><%= details.getProduct().getAuthor() %></td>
                <td><%= details.getQuantity() %></td>
                <td><%= details.getPrice() * details.getQuantity() %></td>
            </tr>
            <%
                        }
                    }
                } else {
            %>
            <tr>
                <td colspan="5">No orders placed yet</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
