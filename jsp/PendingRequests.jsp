<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("role") == null || !"Manager".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Requests</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Pending Access Requests</h2>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
        
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="success">Request processed successfully!</div>
        <% } %>
        
        <table class="requests-table">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Software</th>
                    <th>Access Type</th>
                    <th>Reason</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                try (Connection conn = com.useraccess.util.DatabaseUtil.getConnection()) {
                    String sql = "SELECT r.id, u.username, s.name as software_name, " +
                               "r.access_type, r.reason " +
                               "FROM requests r " +
                               "JOIN users u ON r.user_id = u.id " +
                               "JOIN software s ON r.software_id = s.id " +
                               "WHERE r.status = 'PENDING'";
                    
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("software_name") %></td>
                        <td><%= rs.getString("access_type") %></td>
                        <td><%= rs.getString("reason") %></td>
                        <td class="action-buttons">
                            <form action="ProcessRequestServlet" method="post" class="inline-form">
                                <input type="hidden" name="requestId" value="<%= rs.getInt("id") %>">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="approve-btn">Approve</button>
                            </form>
                            <form action="ProcessRequestServlet" method="post" class="inline-form">
                                <input type="hidden" name="requestId" value="<%= rs.getInt("id") %>">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="reject-btn">Reject</button>
                            </form>
                        </td>
                    </tr>
                <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="5" class="error">Error loading requests. Please try again later.</td>
                    </tr>
                    <%
                }
                %>
            </tbody>
        </table>
        
        <div class="navigation">
            <a href="dashboard.jsp" class="back-btn">Back to Dashboard</a>
        </div>
    </div>
    
    <style>
        .inline-form {
            display: inline-block;
            margin: 0 5px;
        }
        .approve-btn {
            background-color: #4CAF50;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .reject-btn {
            background-color: #f44336;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .requests-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .requests-table th, .requests-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .requests-table th {
            background-color: #f5f5f5;
        }
        .navigation {
            margin-top: 20px;
            text-align: center;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #666;
            color: white;
            text-decoration: none;
            border-radius: 3px;
        }
        .success {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 10px;
            margin: 10px 0;
            border-radius: 3px;
        }
        .error {
            background-color: #f2dede;
            color: #a94442;
            padding: 10px;
            text-align: center;
        }
    </style>
</body>
</html>