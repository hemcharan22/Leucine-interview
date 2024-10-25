<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("role") == null || !"Employee".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Request Access</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Request Software Access</h2>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
        
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="success">Request submitted successfully!</div>
        <% } %>
        
        <form action="RequestServlet" method="post">
            <div class="form-group">
                <label for="software">Select Software:</label>
                <select id="software" name="softwareId" required>
                    <%
                    try (Connection conn = com.useraccess.util.DatabaseUtil.getConnection()) {
                        String sql = "SELECT id, name FROM software";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                    %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                    <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="accessType">Access Type:</label>
                <select id="accessType" name="accessType" required>
                    <option value="Read">Read</option>
                    <option value="Write">Write</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            <div class="form-group">
                <label for="reason">Reason:</label>
                <textarea id="reason" name="reason" required></textarea>
            </div>
            <button type="submit">Submit Request</button>
        </form>
    </div>
</body>
</html>