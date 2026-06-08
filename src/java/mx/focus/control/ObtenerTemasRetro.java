package mx.focus.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ObtenerTemasRetro", urlPatterns = {"/ObtenerTemasRetro"})
public class ObtenerTemasRetro extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String usuario = request.getParameter("usuario");
        int idEst = -1;
        try { idEst = Integer.parseInt(usuario); } catch (Exception e) { /* ignore */ }

        // Map key = materia|unidad|tema  value = count
        Map<String,Integer> counts = new HashMap<>();
        Map<String,String[]> meta = new HashMap<>();

        String sql = "SELECT ri.detalle, t.tit_tem, t.id_tem FROM RespuestaIncorrecta ri LEFT JOIN Tema t ON ri.id_tem = t.id_tem WHERE 1=1 ";
        if (idEst > 0) sql += " AND ri.id_est = ? ";
        sql += " ORDER BY ri.fecha DESC LIMIT 1000";

        try (Connection conn = ConexionBD.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (idEst > 0) ps.setInt(1, idEst);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String detalle = rs.getString("detalle");
                    if (detalle == null) continue;
                    detalle = detalle.trim();
                    // Intentar extraer materia, unidad, tema desde JSON textual
                    // Buscamos patrones simples: "materia":"...","unidad":N,"tema":"..."
                    String materia = null;
                    String temaTxt = null;
                    Integer unidad = null;
                    try {
                        // búsqueda simple sin dependencia JSON
                        int im = detalle.indexOf("\"materia\"");
                        if (im >= 0) {
                            int c = detalle.indexOf(':', im);
                            int q1 = detalle.indexOf('"', c+1);
                            int q2 = detalle.indexOf('"', q1+1);
                            materia = detalle.substring(q1+1, q2);
                        }
                        int iu = detalle.indexOf("\"unidad\"");
                        if (iu >= 0) {
                            int c = detalle.indexOf(':', iu);
                            int comma = detalle.indexOf(',', c+1);
                            String num = (comma>0) ? detalle.substring(c+1, comma).trim() : detalle.substring(c+1).trim();
                            unidad = Integer.parseInt(num.replaceAll("[^0-9-]",""));
                        }
                        int it = detalle.indexOf("\"tema\"");
                        if (it >= 0) {
                            int c = detalle.indexOf(':', it);
                            int q1 = detalle.indexOf('"', c+1);
                            int q2 = detalle.indexOf('"', q1+1);
                            temaTxt = detalle.substring(q1+1, q2);
                        }
                    } catch (Exception ex) {
                        // ignore parsing errors; fallback below
                    }

                    // fallback: si t.tit_tem existe, usarlo
                    if ((materia == null || temaTxt == null) && rs.getString("tit_tem") != null) {
                        temaTxt = rs.getString("tit_tem");
                        // materia y unidad desconocidos en este caso
                    }

                    String key = (materia==null?"_":materia) + "|" + (unidad==null?0:unidad) + "|" + (temaTxt==null?"_":temaTxt);
                    counts.put(key, counts.getOrDefault(key,0) + 1);
                    meta.put(key, new String[]{ materia==null?"":materia, String.valueOf(unidad==null?0:unidad), temaTxt==null?"":temaTxt });
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

        // Construir JSON array
        StringBuilder sb = new StringBuilder();
        sb.append('[');
        boolean first = true;
        for (Map.Entry<String,Integer> e : counts.entrySet()) {
            if (!first) sb.append(',');
            first = false;
            String k = e.getKey();
            String[] m = meta.get(k);
            int cnt = e.getValue();
            String mat = m[0].replace("\"","\\\"");
            String uni = m[1];
            String tem = m[2].replace("\"","\\\"");
            sb.append("{");
            sb.append("\"materia\":\"").append(mat).append("\",");
            sb.append("\"unidad\":").append(uni).append(",");
            sb.append("\"tema\":\"").append(tem).append("\",");
            sb.append("\"count\":").append(cnt);
            sb.append("}");
        }
        sb.append(']');

        try (PrintWriter out = response.getWriter()) {
            out.print(sb.toString());
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
