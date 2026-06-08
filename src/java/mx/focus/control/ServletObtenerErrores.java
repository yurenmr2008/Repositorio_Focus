package mx.focus.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ServletObtenerErrores", urlPatterns = {"/ServletObtenerErrores"})
public class ServletObtenerErrores extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String usuario = request.getParameter("usuario");
        String tema = request.getParameter("tema");

        int idEst = -1;
        try { idEst = Integer.parseInt(usuario); } catch (Exception e) { /* ignore */ }

        StringBuilder sb = new StringBuilder();
        sb.append('[');
        boolean firstElement = true;

        String sql = "SELECT ri.detalle, t.tit_tem FROM RespuestaIncorrecta ri LEFT JOIN Tema t ON ri.id_tem = t.id_tem WHERE 1=1 ";
        if (idEst > 0) sql += " AND ri.id_est = ? ";
        if (tema != null && !tema.isEmpty()) sql += " AND t.tit_tem = ? ";
        sql += " ORDER BY ri.fecha DESC LIMIT 200";

        try (Connection conn = ConexionBD.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (idEst > 0) ps.setInt(idx++, idEst);
            if (tema != null && !tema.isEmpty()) ps.setString(idx++, tema);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String detalle = rs.getString("detalle");
                    if (detalle == null) continue;
                    detalle = detalle.trim();
                    if (detalle.isEmpty()) continue;
                    if (detalle.startsWith("[")) {
                        String inner = detalle.substring(1, detalle.length() - 1).trim();
                        if (!inner.isEmpty()) {
                            if (!firstElement) sb.append(',');
                            sb.append(inner);
                            firstElement = false;
                        }
                    } else if (detalle.startsWith("{")) {
                        if (!firstElement) sb.append(',');
                        sb.append(detalle);
                        firstElement = false;
                    }
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"error\",\"message\":\"" + escapeJson(ex.getMessage()) + "\"}");
            }
            return;
        }

        sb.append(']');
        try (PrintWriter out = response.getWriter()) { out.print(sb.toString()); }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
