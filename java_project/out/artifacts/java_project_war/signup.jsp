<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
</head>
<body>
    <h1>SIGN UP FORM</h1>
    <form action="signup.jsp" method="POST">
        NAME:<br>
        <input type="text" name="name" /><br>
        EMAIL:<br>
        <input type="email" name="email" /><br>
        PASSWORD:<br>
        <input type="password" name="password" /><br>
        ROLE:<br>
        <input type="text" name="role" /><br><br>
        <input type="submit" name="submit" value="Sign Up">
    </form>

    <%
        String event = request.getParameter("submit");
        if (event != null) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/WEB-INF/booknook.db"));

                PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, password);
                stmt.setString(4, role);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    out.println("<p style='color: green;'>User registered successfully!</p>");
                } else {
                    out.println("<p style='color: red;'>Failed to register user.</p>");
                }

                conn.close();
            } catch (Exception e) {
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
