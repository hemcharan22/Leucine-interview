package com.useraccess.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import com.useraccess.util.DatabaseUtil;

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Check if username already exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                if (rs.getInt(1) > 0) {
                    request.setAttribute("error", "Username already exists");
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                    return;
                }
            }
            
            // Insert new user
            String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'Employee')";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, password); // In production, hash the password
                pstmt.executeUpdate();
                
                response.sendRedirect("login.jsp");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}