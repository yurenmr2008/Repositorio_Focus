<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>


<%
  Object idObj = session.getAttribute("id_est");
  String idEst = (idObj != null) ? idObj.toString() : "";
  String contextPath = request.getContextPath();
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Matemáticas Interactivas</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="<%= contextPath %>/css/theme.css?v=1.2">
</head>
<body style="background:linear-gradient(180deg,var(--bg), #F6EFC0);">
<script>
  const BASE = '<%= request.getContextPath() %>';
  window.__BASE = BASE;
  window.__ID_EST = '<%= (session.getAttribute("id_est") != null) ? session.getAttribute("id_est").toString() : "" %>';
</script>

  <div class="container" style="padding-top:20px;">
    <div class="card">
      <div class="card-header">
        <h2 class="hero-title">Practica lo que fallaste</h2>
      </div>

      <div class="card-body">
        <div class="hero-compact">
          <div class="left">
            <p class="hero-sub">Aquí verás los temas donde tuviste errores y podrás practicar con cuestionarios hechos para ti.</p>
            <div style="margin-top:10px;display:flex;gap:10px;flex-wrap:wrap">
              <button class="btn peach">Practica lo que fallaste</button>
              <button class="btn lavanda">Refuerza tus temas débiles</button>
              <button class="btn mint">Pequeños pasos, gran progreso</button>
            </div>
          </div>
          <div class="right">
            <img src="<%= contextPath %>/images/hero-study.png" alt="Ilustración Matemáticas">
          </div>
        </div>

        <div style="display:flex;gap:18px;align-items:flex-start;flex-wrap:wrap">
          <div style="flex:1;min-width:320px">
            <div class="card" style="padding:12px;">
              <h3 style="margin:0 0 8px 0">Temas con errores</h3>
              <div class="hint">Selecciona un tema para practicar con un cuestionario personalizado</div>
              <div id="topicsGrid" class="topics-grid" style="margin-top:12px"></div>
            </div>
          </div>

          <div style="width:360px;min-width:260px">
            <div class="card" style="padding:14px;">
              <h4 style="margin:0 0 8px 0">Tu espacio de práctica</h4>
              <div class="hint">Accede a cuestionarios personalizados, revisa retroalimentación y marca temas completados.</div>
              <div style="margin-top:12px;display:flex;gap:8px;flex-wrap:wrap">
                <button class="btn peach">Practicar ahora</button>
                <button class="btn lavanda">Ver retroalimentación</button>
                <button class="btn mint">Ver progreso</button>
              </div>
              <div style="margin-top:12px;text-align:center" class="center-img">
                <img src="<%= contextPath %>/images/card-illustration.png" alt="Ilustración">
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

  <script src="<%= contextPath %>/js/preguntas.js"></script>
  <script src="<%= contextPath %>/js/matematicas_interactivas.js"></script>
  <script> window.__ID_EST = "<%= idEst %>"; </script>
</body>
</html>
