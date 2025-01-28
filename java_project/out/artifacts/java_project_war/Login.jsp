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
        MEMBER NAME:<br>
        <input type="text" name="member" /><br>
        PASSWORD:<br>
        <input type="password" name="password" /><br><br>
        <input type="submit" name="submit" value="Login">
    </form>

    <%
        String event = request.getParameter("submit");
        if (event != null) {
            String memberName = request.getParameter("member");
            String password = request.getParameter("password");

            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/WEB-INF/booknook.db"));
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE name = ? AND password = ?");
                stmt.setString(1, memberName);
                stmt.setString(2, password);

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    // Successful login
                    response.sendRedirect("button.jsp");
                } else {
                    // Invalid login
                    out.println("<p style='color: red;'>Invalid username or password</p>");
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
