<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Home</title>
</head>
<body>
    <h1>Welcome to BookNook!</h1>
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <p>Hello, ${sessionScope.user.name}!</p>
            <a href="logout">Logout</a>
        </c:when>
        <c:otherwise>
            <p><a href="login.jsp">Login</a> or <a href="register.jsp">Register</a></p>
        </c:otherwise>
    </c:choose>

    <h2>Categories</h2>
    <ul>
        <li><a href="books/search?query=Science Fiction">Science Fiction</a></li>
        <li><a href="books/search?query=Self-Help">Self-Help</a></li>
        <li><a href="books/search?query=Mystery">Mystery</a></li>
    </ul>
</body>
</html>
