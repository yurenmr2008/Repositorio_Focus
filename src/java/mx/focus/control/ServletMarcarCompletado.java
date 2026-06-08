package mx.focus.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.Normalizer;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ServletMarcarCompletado", urlPatterns = {"/MarcarCompletado"})
public class ServletMarcarCompletado extends HttpServlet {

    // Método utilitario para normalizar texto: quitar acentos, pasar a minúsculas y trim
    private static String normalize(String s) {
        if (s == null) return "";
        String n = Normalizer.normalize(s, Normalizer.Form.NFD);
        return n.replaceAll("\\p{M}", "").toLowerCase().trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String tema = request.getParameter("tema");
        String usuario = request.getParameter("usuario");

        int idEst = -1;
        try { idEst = Integer.parseInt(usuario); } catch (Exception e) { /* ignore */ }

        if (tema == null || tema.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"error\",\"message\":\"Falta tema\"}");
            }
            return;
        }

        // Normalizar tema recibido
        String temaNorm = normalize(tema);

        int deleted = 0;
        try (Connection conn = ConexionBD.obtenerConexion()) {

            // 1) Intentar borrar por coincidencia con la tabla Tema (normalizando)
            try {
                // Normalizamos t.tit_tem en SQL con funciones simples (sin depender de JSON)
                // Usamos LOWER + REPLACE para quitar acentos comunes en la comparación
                String sqlJoin = "DELETE ri FROM RespuestaIncorrecta ri " +
                                 "LEFT JOIN Tema t ON ri.id_tem = t.id_tem " +
                                 "WHERE LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.tit_tem,'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u')) = ?";

                if (idEst > 0) sqlJoin += " AND ri.id_est = " + idEst;

                try (PreparedStatement ps = conn.prepareStatement(sqlJoin)) {
                    ps.setString(1, temaNorm);
                    deleted = ps.executeUpdate();
                }
            } catch (SQLException exJoin) {
                // Si falla el intento por JOIN, lo capturamos y seguimos al fallback
                deleted = 0;
            }

            // 2) Si no borró nada, intentar borrar buscando dentro del campo detalle (más tolerante)
            if (deleted == 0) {
                try {
                    // Buscamos la cadena "tema":"<valor>" dentro de detalle (normalizando acentos)
                    // Hacemos un LIKE sobre una versión simplificada de detalle (reemplazando acentos)
                    String sqlLike = "DELETE FROM RespuestaIncorrecta " +
                                     "WHERE LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(detalle,'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u')) LIKE ?";

                    if (idEst > 0) sqlLike += " AND id_est = " + idEst;

                    try (PreparedStatement ps2 = conn.prepareStatement(sqlLike)) {
                        // buscamos la clave "tema":"<temaNorm>" dentro del texto normalizado
                        ps2.setString(1, "%\"tema\":\"" + temaNorm + "\"%");
                        deleted = ps2.executeUpdate();

                        // Si aún no se borró, intentar una búsqueda más amplia (solo presencia del texto del tema)
                        if (deleted == 0) {
                            try (PreparedStatement ps3 = conn.prepareStatement(sqlLike)) {
                                ps3.setString(1, "%" + temaNorm + "%");
                                deleted = ps3.executeUpdate();
                            }
                        }
                    }
                } catch (SQLException exLike) {
                    // si falla, dejamos deleted como 0 y reportamos más abajo
                    deleted = 0;
                }
            }

            // Responder JSON con el número de filas borradas
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"status\":\"ok\",\"deleted\":" + deleted + "}");
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
