<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Search Results</title>
</head>
<body>
    <h1>Search Results</h1>
    <c:if test="${empty books}">
        <p>No books found for your search.</p>
    </c:if>
    <c:forEach var="book" items="${books}">
        <p>
            <strong>${book.name}</strong> by ${book.author} <br>
            Category: ${book.category} | Price: $${book.price} <br>
            <a href="orders/create?bookCode=${book.itemCode}">Add to Cart</a>
        </p>
        <hr>
    </c:forEach>

    <p><a href="index.jsp">Back to Home</a></p>
</body>
</html>
