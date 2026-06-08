package mx.focus.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.Instant;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

@WebServlet(name = "ServletGuardarResultado", urlPatterns = {"/ServletGuardarResultado"})
public class ServletGuardarResultado extends HttpServlet {

    private DataSource ds = null;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/miPool");
        } catch (NamingException e) {
            ds = null;
            log("DataSource no encontrado (continuando sin pool): " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String idEstStr = request.getParameter("id_est");
        String materia = request.getParameter("materia");
        String unidadStr = request.getParameter("unidad");
        String tema = request.getParameter("tema");
        String dificultad = request.getParameter("dificultad");
        String modo = request.getParameter("modo");
        String calificacionStr = request.getParameter("calificacion");

        if (materia == null || unidadStr == null || tema == null || dificultad == null || calificacionStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"error\",\"message\":\"Faltan parámetros obligatorios.\"}");
            }
            return;
        }

        int unidad = safeParseInt(unidadStr, -1);
        int idEst = safeParseInt(idEstStr, -1);
        int calificacion = safeParseInt(calificacionStr, -1);

        if (unidad < 0 || calificacion < 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"error\",\"message\":\"Parámetros numéricos inválidos.\"}");
            }
            return;
        }

        Timestamp enviadoEn = Timestamp.from(Instant.now());
        boolean guardado = false;
        String errorMsg = null;

        if (ds != null) {
            String sql = "INSERT INTO Resultado (id_est, materia, unidad, tema, dificultad, modo, calificacion, fecha) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (Connection conn = ds.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                if (idEst > 0) ps.setInt(1, idEst);
                else ps.setNull(1, Types.INTEGER);
                ps.setString(2, materia);
                ps.setInt(3, unidad);
                ps.setString(4, tema);
                ps.setString(5, dificultad);
                ps.setString(6, modo);
                ps.setInt(7, calificacion);
                ps.setTimestamp(8, enviadoEn);
                ps.executeUpdate();
                guardado = true;
            } catch (SQLException ex) {
                log("Error al insertar resultado en BD: " + ex.getMessage(), ex);
                errorMsg = ex.getMessage();
            }
        } else {
            try {
                HttpSession session = request.getSession();
                @SuppressWarnings("unchecked")
                java.util.List<java.util.Map<String,Object>> lista =
                    (java.util.List<java.util.Map<String,Object>>) session.getAttribute("resultados_guardados");
                if (lista == null) {
                    lista = new java.util.ArrayList<>();
                }
                java.util.Map<String,Object> fila = new java.util.HashMap<>();
                fila.put("id_est", idEst > 0 ? idEst : null);
                fila.put("materia", materia);
                fila.put("unidad", unidad);
                fila.put("tema", tema);
                fila.put("dificultad", dificultad);
                fila.put("modo", modo);
                fila.put("calificacion", calificacion);
                fila.put("fecha", enviadoEn);
                lista.add(fila);
                session.setAttribute("resultados_guardados", lista);
                guardado = true;
            } catch (Exception ex) {
                log("Error al guardar en sesión: " + ex.getMessage(), ex);
                errorMsg = ex.getMessage();
            }
        }

        try (PrintWriter out = response.getWriter()) {
            if (guardado) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"status\":\"ok\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\":\"error\",\"message\":\"No se pudo guardar resultado\",\"detail\":\"" + escapeJson(errorMsg) + "\"}");
            }
        }
    }

    private int safeParseInt(String s, int defaultValue) {
        if (s == null) return defaultValue;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return defaultValue; }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
