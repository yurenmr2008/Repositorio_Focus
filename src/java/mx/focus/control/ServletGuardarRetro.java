package mx.focus.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.Instant;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ServletGuardarRetro", urlPatterns = {"/GuardarRetro"})
public class ServletGuardarRetro extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String retroRaw = request.getParameter("retro");
        String idEstStr = request.getParameter("id_est");

        if (retroRaw == null || retroRaw.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"error\",\"message\":\"No hay retro proporcionada\"}");
            }
            return;
        }

        int idEst = -1;
        try { idEst = Integer.parseInt(idEstStr); } catch (Exception e) { /* ignore */ }

        try (Connection conn = ConexionBD.obtenerConexion()) {
            String sql = "INSERT INTO RespuestaIncorrecta (id_est, id_pre, id_tem, detalle, fecha) VALUES (?, NULL, NULL, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                String s = retroRaw.trim();
                if (s.startsWith("[")) s = s.substring(1, s.length() - 1).trim();
                int depth = 0;
                StringBuilder cur = new StringBuilder();
                for (int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    cur.append(c);
                    if (c == '{') depth++;
                    else if (c == '}') depth--;
                    if (depth == 0 && cur.length() > 0) {
                        String obj = cur.toString().trim();
                        if (!obj.isEmpty()) {
                            ps.setObject(1, idEst > 0 ? idEst : null);
                            ps.setString(2, obj);
                            ps.setTimestamp(3, Timestamp.from(Instant.now()));
                            ps.addBatch();
                        }
                        cur.setLength(0);
                    }
                }
                ps.executeBatch();
            }
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"ok\"}");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"error\",\"message\":\"" + escapeJson(ex.getMessage()) + "\"}");
            }
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
