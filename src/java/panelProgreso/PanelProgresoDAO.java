package panelProgreso;


import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
public class PanelProgresoDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/focus";
    private static final String USER = "root";
    private static final String PASS = "n0m3l0";

public List<Progreso> obtenerProgreso(int idEstudiante) {
    List<Progreso> lista = new ArrayList<>();
    String query = "SELECT c.dif_cue, m.nom_mat, ca.id_cal, ca.cal " +
                   "FROM cuestionario c " +
                   "JOIN tema t ON c.id_tem = t.id_tem " +
                   "JOIN materia m ON t.id_mat = m.id_mat " +
                   "JOIN calificacion ca ON ca.id_cue = c.id_cue " +
                   "WHERE ca.id_est = ?";

    try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setInt(1, idEstudiante);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Progreso p = new Progreso(
                rs.getString("dif_cue"),
                rs.getString("nom_mat"),
                rs.getInt("id_cal"),
                rs.getInt("cal")
            );
            lista.add(p);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return lista;
}


public List<Meta> obtenerMetasPendientes(int idEst) {
    List<Meta> metas = new ArrayList<>();
    String query = "SELECT m.id_met, m.nom_met, m.des_met " +
                   "FROM metas m " +
                   "WHERE m.id_est = ? " +
                   "AND m.id_met NOT IN (SELECT id_met FROM metas_completadas WHERE id_est = ?)";

    try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setInt(1, idEst);
        ps.setInt(2, idEst);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            metas.add(new Meta(
                rs.getInt("id_met"),
                rs.getString("nom_met"),
                rs.getString("des_met")
            ));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return metas;
}

public Map<String, Double> obtenerPromediosGlobales() {
    Map<String, Double> promedios = new HashMap<>();
    String query = "SELECT m.nom_mat, AVG(ca.cal) AS promedio " +
                   "FROM cuestionario c " +
                   "JOIN tema t ON c.id_tem = t.id_tem " +
                   "JOIN materia m ON t.id_mat = m.id_mat " +
                   "JOIN calificacion ca ON ca.id_cue = c.id_cue " +
                   "GROUP BY m.nom_mat";

    try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
         PreparedStatement ps = conn.prepareStatement(query)) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            promedios.put(rs.getString("nom_mat"), rs.getDouble("promedio"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return promedios;
}

public void insertarMetaCompletada(int idEst, int idMet) {
        String sql = "INSERT INTO metas_completadas (id_est, id_met) VALUES (?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idEst);
            ps.setInt(2, idMet);
            ps.executeUpdate();

            System.out.println("Meta registrada como completada: id_est=" + idEst + ", id_met=" + idMet);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

public void eliminarMetaCompletada(int idEst, int idMet) {
        String sql = "DELETE FROM metas_completadas WHERE id_est = ? AND id_met = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idEst);
            ps.setInt(2, idMet);
            int filas = ps.executeUpdate();

            System.out.println("Filas eliminadas de metas_completadas: " + filas);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


public List<Meta> obtenerMetasCompletadas(int idEst) {
    List<Meta> metas = new ArrayList<>();
    String query = "SELECT m.id_met, m.nom_met, m.des_met " +
                   "FROM metas_completadas mc " +
                   "JOIN metas m ON mc.id_met = m.id_met " +
                   "WHERE mc.id_est = ?";

    try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setInt(1, idEst);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            metas.add(new Meta(
                rs.getInt("id_met"),
                rs.getString("nom_met"),
                rs.getString("des_met")
            ));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return metas;
}
public void insertarMeta(int idEst, String nomMet, String desMet) {
        String query = "INSERT INTO metas (id_est, nom_met, des_met) VALUES (?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, idEst);
            ps.setString(2, nomMet);
            ps.setString(3, desMet);
            ps.executeUpdate();

            System.out.println("Meta insertada: " + nomMet + " - " + desMet);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }




}
