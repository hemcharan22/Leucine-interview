@WebServlet("/ApprovalServlet")
public class ApprovalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (!"Manager".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action"); // "approve" or "reject"
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "UPDATE requests SET status = ? WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, "approve".equals(action) ? "Approved" : "Rejected");
                pstmt.setInt(2, requestId);
                
                pstmt.executeUpdate();
                response.sendRedirect("pendingRequests.jsp");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}