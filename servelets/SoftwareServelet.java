@WebServlet("/SoftwareServlet")
public class SoftwareServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (!"Admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] accessLevels = request.getParameterValues("accessLevels");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "INSERT INTO software (name, description, access_levels) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, name);
                pstmt.setString(2, description);
                // Convert array to PostgreSQL array format
                Array accessArray = conn.createArrayOf("varchar", accessLevels);
                pstmt.setArray(3, accessArray);
                
                pstmt.executeUpdate();
                response.sendRedirect("createSoftware.jsp?success=true");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}