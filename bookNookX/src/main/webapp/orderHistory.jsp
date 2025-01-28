<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Order History</title>
</head>
<body>
    <h1>Your Order</h1>
    <c:if test="${empty order.books}">
        <p>Your order is empty.</p>
    </c:if>
    <c:forEach var="book" items="${order.books}">
        <p>
            <strong>${book.name}</strong> by ${book.author} <br>
            Price: $${book.price} <br>
        </p>
        <hr>
    </c:forEach>

    <p>Total Price: $${order.totalPrice}</p>
    <p><a href="index.jsp">Back to Home</a></p>
</body>
</html>
