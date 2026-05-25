<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*,control.ConexionBD" %>
<%
  Integer idEst = (Integer) session.getAttribute("id_est");
  if (idEst == null) idEst = 1;
  double promedio = 0;
  int conteo = 0;
  java.util.List<String> filas = new java.util.ArrayList<>();
  try (Connection con = ConexionBD.obtenerConexion()) {
    String sql = "SELECT materia, unidad, tema, dificultad, modo, calificacion, fecha FROM Resultado WHERE id_est = ? ORDER BY fecha DESC";
    try (PreparedStatement ps = con.prepareStatement(sql)) {
      ps.setInt(1, idEst);
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          filas.add(rs.getString("fecha") + " - " + rs.getString("materia") + " U" + rs.getInt("unidad") + " - " + rs.getString("tema") + " : " + rs.getInt("calificacion") + "%");
          promedio += rs.getInt("calificacion");
          conteo++;
        }
      }
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  if (conteo > 0) promedio = promedio / conteo;
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Mi avance</title>
  <link rel="stylesheet" href="css/theme.css">
</head>
<body>
  <div class="container">
    <div class="card">
      <div class="card-header"><h2>Mi avance</h2></div>
      <div class="card-body">
        <p><strong>Usuario:</strong> <%= session.getAttribute("nombre") %></p>
        <p><strong>Promedio:</strong> <%= (conteo>0) ? String.format("%.1f", promedio) + "%" : "Sin resultados aún" %></p>
        <p>
          <strong>Mensaje:</strong>
          <% if (conteo==0) { %>
            Sigue practicando para ver tu progreso. ¡Tú puedes!
          <% } else if (promedio >= 85) { %>
            Excelente trabajo, sigue así.
          <% } else if (promedio >= 65) { %>
            Buen progreso, con un poco más de práctica mejorarás.
          <% } else { %>
            No te desanimes, revisa los temas con más errores y practica con calma.
          <% } %>
        </p>

        <h3>Historial</h3>
        <table>
          <thead><tr><th>Registro</th></tr></thead>
          <tbody>
            <% for (String f : filas) { %>
              <tr><td><%= f %></td></tr>
            <% } %>
            <% if (filas.isEmpty()) { %>
              <tr><td>No hay resultados registrados.</td></tr>
            <% } %>
          </tbody>
        </table>

        <div style="margin-top:12px;">
          <a href="index.jsp" class="btn">Volver</a>
        </div>
      </div>
    </div>
  </div>
</body>
</html>