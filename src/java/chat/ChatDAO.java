package chat;

import java.sql.*;
import java.util.*;

public class ChatDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/focus";
    private static final String USER = "root";
    private static final String PASS = "n0m3l0";

    public void insertarMensaje(int idEst, String contenido) {
        String sql = "INSERT INTO mensajes (id_est, contenido, fecha) VALUES (?, ?, NOW())";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEst);
            ps.setString(2, contenido);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<String> obtenerMensajes() {
        List<String> mensajes = new ArrayList<>();
        String sql = "SELECT e.nom_est, m.contenido, m.fecha " +
                     "FROM mensajes m JOIN estudiante e ON m.id_est = e.id_est " +
                     "ORDER BY m.fecha DESC";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                mensajes.add(rs.getString("nom_est") + ": " +
                             rs.getString("contenido") + " (" +
                             rs.getTimestamp("fecha") + ")");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mensajes;
    }
}
