<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Login</title>
</head>
<body>
    <h1>Login</h1>
    <form action="login" method="post">
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>
        <br>
        <button type="submit">Login</button>
    </form>

    <c:if test="${not empty error}">
        <p style="color: red;">${error}</p>
    </c:if>

    <p>Don't have an account? <a href="register.jsp">Register</a></p>
</body>
</html>
