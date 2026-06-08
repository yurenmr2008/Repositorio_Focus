<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*,mx.focus.control.ConexionBD" %>
<%@ page session="true" %>


<%
  Object idObj = session.getAttribute("id_est");
  if (idObj == null) {
      response.sendRedirect(request.getContextPath() + "/jsp/iniciar.jsp");
      return;
  }
  Integer idEst = null;
  try { idEst = Integer.parseInt(idObj.toString()); } catch (Exception e) { idEst = null; }
  double promedio = 0;
  int conteo = 0;
  java.util.List<String> filas = new java.util.ArrayList<>();
  try (Connection con = ConexionBD.obtenerConexion()) {
    String sql = "SELECT materia, unidad, tema, dificultad, modo, calificacion, fecha FROM Resultado WHERE id_est = ? ORDER BY fecha DESC";
    try (PreparedStatement ps = con.prepareStatement(sql)) {
      ps.setInt(1, idEst);
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          Timestamp ts = rs.getTimestamp("fecha");
          String fechaStr = (ts != null) ? ts.toString() : "";
          filas.add(fechaStr + " - " + rs.getString("materia") + " U" + rs.getInt("unidad") + " - " + rs.getString("tema") + " : " + rs.getInt("calificacion") + "%");
          promedio += rs.getInt("calificacion");
          conteo++;
        }
      }
    }
  } catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("perfilError", "No se pudo conectar a la base de datos: " + e.getMessage());
  }
  if (conteo > 0) promedio = promedio / conteo;
%>


<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Mi avance</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/moduloCuestionarios/css/theme.css?v=1.2">
</head>
<body>
  <div class="container">
    <div class="card">
      <div class="card-header"><h2>Mi avance</h2></div>
      <div class="card-body">
        <div class="profile-header">
          <div class="avatar" aria-hidden="true">
            <% String nombre = (String) session.getAttribute("nombre"); 
               String inicial = (nombre != null && nombre.length()>0) ? nombre.substring(0,1).toUpperCase() : "A"; %>
            <%= inicial %>
          </div>
          <div>
            <p><strong>Usuario:</strong> <%= session.getAttribute("nombre") %></p>
            <p><strong>Promedio:</strong> <span class="stat"><%= (conteo>0) ? String.format("%.1f", promedio) + "%" : "Sin resultados aún" %></span></p>
          </div>
        </div>

        <div class="profile-illustration" aria-hidden="true">
          <img src="${pageContext.request.contextPath}/moduloCuestionarios/images/card-illustration.png" alt="Ilustración perfil">
        </div>

        <p>
          <strong>Mensaje:</strong>
          <% if (request.getAttribute("perfilError") != null) { %>
            <span style="color:#b45309;"><%= request.getAttribute("perfilError") %></span>
          <% } else if (conteo==0) { %>
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
        <div class="history-wrap">
          <table>
            <thead><tr><th>Registro</th></tr></thead>
            <tbody>
              <% if (!filas.isEmpty()) {
                   for (String f : filas) { %>
                     <tr><td><%= f %></td></tr>
              <%     }
                 } else { %>
                   <tr><td>No hay resultados registrados.</td></tr>
              <% } %>
            </tbody>
          </table>
        </div>

        <div style="margin-top:12px">
          <a href="${pageContext.request.contextPath}/moduloCuestionarios/index.jsp" class="btn primary-solid">Volver</a>
        </div>
      </div>
    </div>
  </div>

</body>
</html>

