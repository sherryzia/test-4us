<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Sales Report</title>
</head>
<body>
    <h1>Sales Report</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Book Code</th>
                <th>Name</th>
                <th>Quantity Sold</th>
                <th>Total Revenue</th>
            </tr>
        </thead>
        <tbody>
            <%
                Map<String, Integer> salesData = (Map<String, Integer>) request.getAttribute("sales");
                if (salesData != null) {
                    double totalRevenue = 0;
                    for (Map.Entry<String, Integer> entry : salesData.entrySet()) {
                        String bookCode = entry.getKey();
                        int quantity = entry.getValue();
                        double price = 0; // Fetch book price based on bookCode
                        totalRevenue += quantity * price;
            %>
            <tr>
                <td><%= bookCode %></td>
                <td>Fetch Name</td>
                <td><%= quantity %></td>
                <td><%= quantity * price %></td>
            </tr>
            <%
                    }
            %>
            <tr>
                <td colspan="3"><strong>Total Revenue</strong></td>
                <td><%= totalRevenue %></td>
            </tr>
            <%
                } else {
            %>
            <tr>
                <td colspan="4">No sales data available</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
