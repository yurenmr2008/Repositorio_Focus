
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="panelProgreso.PanelProgresoDAO" %>
<%@ page import="panelProgreso.Progreso" %>
<%@ page import="panelProgreso.Meta" %>

<%
    int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
    
    PanelProgresoDAO dao = new PanelProgresoDAO();
    List<Progreso> progresos = dao.obtenerProgreso(idEstudiante); // ejemplo id_est = 1
    List<Meta> metas = dao.obtenerMetasPendientes(idEstudiante);
%>
<head>
    <meta charset="UTF-8">
    <title>Panel de Progreso</title>
    <link rel="stylesheet" type="text/css" href="panelProgreso.css">
</head>

<section class="panel-progreso">
  <h2>Panel de Progreso</h2>

   <!-- Progreso por cuestionarios -->
  <div class="grid-progreso">
    <% for(Progreso p : progresos) { %>
      <div class="card-progreso">
        <h3><%= p.getNomMat() %></h3>
        <table class="meta-table">
            <tr>
                <td class="meta-nombre"><Strong>No</Strong></td>
                <td class="meta-descripcion"><Strong>Dificultad del cuestionario</Strong></td>
                <td class="meta-descripcion"><strong>Calificacion</strong></td>
            </tr>
            <tr>
                <td><p><strong> <%= p.getIdCal() %></strong></p></td>
                <td><p><strong> <%= p.getDifCue() %></strong></p></td>
                <td><p><strong><%= p.getCal() %></strong></p></td>
        </tr>
          </table>
      </div>
    <% } %>
  </div>
  <br><br>
  <!-- Metas: se muestran todas -->
<div class="meta-box">
    <h3>Metas del estudiante</h3>
    <% for(Meta m : metas) { %>
      <div class="meta-item">
        <table class="meta-table">
            <tr>
                <td class="meta-nombre"><strong>Nombre:</strong></td> 
                <td class="meta-descripcion"><strong>Descripción:</strong></td>
            </tr>
            <tr>
                <td class="meta-nombre"><%= m.getNomMet() %></td>
                <td class="meta-descripcion"><%= m.getDesMet() %></td>
                
                <!-- Aqui hay que checar para que cuando el boton se presione se actualice -->
                <td>
                    
                    
    <form action="<%= request.getContextPath() %>/RegistrarMetaCompletada" method="post">
        <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
        <input type="hidden" name="id_met" value="<%= m.getIdMet() %>">
        <input class="btn-completar" type="submit"  value="Marcar como completada">
    <!-- <button type="submit" class="btn-completar">Marcar como completada</button> -->

    </form>

</td>
            </tr>
        </table>
     
        <hr>

      </div>
    <% } %>
</div>


  <form action="RegistrarMeta.jsp" method="post">
      <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
      <input class="secondary" type="submit"  value="Registrar una nueva meta">
  </form>

<form action="MetasCompletadas.jsp" method="post">
<input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
      <input class="secondary" type="submit"  value="Ver Metas completadas">
</form>


<form action="PanelProgresoGlobal.jsp" method="get">
        <button type="submit">Panel de Progreso Global</button>
    </form>

 
</section>