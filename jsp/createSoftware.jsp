<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Software</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Create New Software</h2>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
        
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="success">Software created successfully!</div>
        <% } %>
        
        <form action="SoftwareServlet" method="post">
            <div class="form-group">
                <label for="name">Software Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" required></textarea>
            </div>
            <div class="form-group">
                <label>Access Levels:</label>
                <div class="checkbox-group">
                    <input type="checkbox" name="accessLevels" value="Read"> Read
                    <input type="checkbox" name="accessLevels" value="Write"> Write
                    <input type="checkbox" name="accessLevels" value="Admin"> Admin
                </div>
            </div>
            <button type="submit">Create Software</button>
        </form>
    </div>
</body>
</html>