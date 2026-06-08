<%@ page import="java.util.List" %>
<%@ page import="panelProgreso.PanelProgresoDAO" %>
<%@ page import="panelProgreso.Meta" %>

<%
    PanelProgresoDAO dao = new PanelProgresoDAO();
    int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
    List<Meta> metasCompletadas = dao.obtenerMetasCompletadas(idEstudiante);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Metas Completadas</title>
    <link rel="stylesheet" type="text/css" href="panelProgreso.css">
</head>
<body>
    <section class="meta-box">
        <h2>Metas Completadas</h2>
        <% if(metasCompletadas.isEmpty()) { %>
            <p>No hay metas completadas aún.</p>
        <% } else { %>
            <table border="1" cellpadding="8" cellspacing="0">
                <thead>
                    <tr>
                        <th>Nombre de la Meta</th>
                        <th>Descripción</th>
                        
                    </tr>
                </thead>
                <tbody>
                    <% for(Meta m : metasCompletadas) { %>
                        <tr>
                            <td><%= m.getNomMet() %></td>
                            <td><%= m.getDesMet() %></td>
                            <td>
<form action="<%= request.getContextPath() %>/DesmarcarMetaCompletada" method="post">
    <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
    <input type="hidden" name="id_met" value="<%= m.getIdMet() %>">
    <button type="submit" class="btn-desmarcar">Desmarcar</button>
</form>

                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
        
    </section>
        <section class="meta-box">
            <form action="PanelProgreso.jsp" method="post">
    <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
      <input class="secondary" type="submit"  value="Regresar al panel de progreso">
      <!-- <button type="submit">Regresar al panel de progreso</button> -->        
</form>
        </section>
</body>
</html>
