<%@ page import="java.util.Map" %>
<%@ page import="panelProgreso.PanelProgresoDAO" %>

<%
    PanelProgresoDAO dao = new PanelProgresoDAO();
    Map<String, Double> promedios = dao.obtenerPromediosGlobales();
%>

<section class="panel-grafica">
  <h2>Promedio Global de Calificaciones por Materia</h2>
  <div class="grafica-container">
    <canvas id="graficaPromedios"></canvas>
  </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const labels = [
        <% for(String materia : promedios.keySet()) { %>
            "<%= materia %>",
        <% } %>
    ];

    const data = [
        <% for(Double promedio : promedios.values()) { %>
            <%= promedio %>,
        <% } %>
    ];

    const ctx = document.getElementById('graficaPromedios').getContext('2d');
    const graficaPromedios = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Promedio de Calificaciones',
                data: data,
                backgroundColor: 'rgba(46, 93, 63, 0.7)',
                borderColor: 'rgba(46, 93, 63, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    max: 10 // si tus calificaciones son de 0 a 10
                }
            }
        }
    });
</script>


