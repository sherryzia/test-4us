<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <h1>LOGIN FORM</h1>
    <form action="Login.jsp" method="POST">
        EMAIL:<br>
        <input type="email" name="email" /><br>
        PASSWORD:<br>
        <input type="password" name="password" /><br><br>
        <input type="submit" name="submit" value="Login">
    </form>

    <%
        String event = request.getParameter("submit");
        if (event != null) {
            String email = request.getParameter("email").trim();
            String password = request.getParameter("password").trim();

            try {
                Class.forName("org.sqlite.JDBC");
                String dbPath = application.getRealPath("/WEB-INF/booknook.db");
                out.println("Database path: " + dbPath); // Debugging path
                Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ?");
                stmt.setString(1, email);
                stmt.setString(2, password);

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    response.sendRedirect("button.jsp");
                } else {
                    out.println("<p style='color: red;'>Invalid email or password</p>");
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
