<!DOCTYPE html>
<html>
<head>
    <title>BookNook - Register</title>
</head>
<body>
    <h1>Register</h1>
<form action="user/register" method="post">
        <label for="name">Name:</label>
        <input type="text" name="name" id="name" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>
        <br>
        <button type="submit">Register</button>
    </form>

    <c:if test="${not empty message}">
        <p style="color: green;">${message}</p>
    </c:if>

    <p>Already have an account? <a href="login.jsp">Login</a></p>
</body>
</html>
