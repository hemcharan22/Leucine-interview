@WebServlet("/RequestServlet")
public class RequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (!"Employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        int softwareId = Integer.parseInt(request.getParameter("softwareId"));
        String accessType = request.getParameter("accessType");
        String reason = request.getParameter("reason");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "INSERT INTO requests (user_id, software_id, access_type, reason, status) " +
                        "VALUES (?, ?, ?, ?, 'Pending')";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, userId);
                pstmt.setInt(2, softwareId);
                pstmt.setString(3, accessType);
                pstmt.setString(4, reason);
                
                pstmt.executeUpdate();
                response.sendRedirect("requestAccess.jsp?success=true");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
