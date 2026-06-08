<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>



<%-- Helper to escape HTML safely on server side --%>
<%! 
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;")
            .replace("<","&lt;")
            .replace(">","&gt;")
            .replace("\"","&quot;")
            .replace("'","&#39;");
  }
%>

<%
  // Seguridad: comprobar sesión antes de enviar cualquier HTML
  Object idObj = session.getAttribute("id_est");
  if (idObj == null) {
      response.sendRedirect(request.getContextPath() + "/jsp/iniciar.jsp");
      return;
  }

  // Parámetros (pueden venir por query string)
  String score = request.getParameter("score");
  String aciertos = request.getParameter("aciertos");
  String total = request.getParameter("total");
  String materia = request.getParameter("materia");

  // Valores por defecto legibles
  if (score == null) score = "";
  if (aciertos == null) aciertos = "";
  if (total == null) total = "";
  if (materia == null) materia = "";
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Resultado</title>

  <!-- Estilos globales del proyecto principal -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos_general.css">
  <!-- Estilos específicos del módulo (opcional) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/moduloCuestionarios/css/theme.css?v=1.2">

  <style>
    .retro-list{margin-top:12px;display:grid;gap:10px}
    .retro-item{border:1px solid rgba(33,48,42,0.06);padding:12px;border-radius:10px;background:var(--card)}
    .retro-pregunta{font-weight:800;margin-bottom:6px;color:var(--primary)}
    .respuesta-usuario{color:#b00020;background:#fff0f0;padding:6px;border-radius:6px;display:inline-block;margin-bottom:6px}
    .respuesta-correcta{color:#0b6623;background:#f0fff4;padding:6px;border-radius:6px;display:inline-block;margin-left:8px}
    .retro-text{margin-top:8px;color:var(--text)}
    .summary{display:flex;gap:12px;align-items:center;flex-wrap:wrap}
    .hint-mini{font-size:0.95rem;color:rgba(33,48,42,0.6)}
    .result-illustration-wrap{display:flex;align-items:center;justify-content:center;margin-top:18px}
    .result-illustration-wrap img{width:320px;max-width:92%;height:auto;border-radius:12px;box-shadow:0 12px 30px rgba(0,0,0,0.08)}
  </style>
</head>
<body>


  <div class="container" style="padding-top:18px;padding-bottom:40px">
    <div class="card">
      <div class="card-header"><h2>Resultado: <%= esc(materia) %></h2></div>
      <div class="card-body">
        <div class="summary">
          <div class="score-bubble"><%= esc(score) %>%</div>
          <div>
            <p>Obtuviste <strong><%= esc(score) %>%</strong> (<%= esc(aciertos) %> de <%= esc(total) %>).</p>
            <p class="hint-mini">Si seleccionaste "Con retroalimentación", verás explicaciones detalladas abajo.</p>
          </div>
          <div style="margin-left:auto">
            <a href="${pageContext.request.contextPath}/moduloCuestionarios/seleccionar.jsp" class="btn primary-solid">Volver a seleccionar</a>
            <a href="${pageContext.request.contextPath}/jsp/inicio.jsp" class="btn ghost">Inicio</a>
          </div>
        </div>

        <div class="result-illustration-wrap" aria-hidden="true">
          <img src="${pageContext.request.contextPath}/moduloCuestionarios/images/result-illustration.png" alt="Ilustración resultado">
        </div>

        <div id="retroArea" style="margin-top:14px"></div>
      </div>
    </div>
  </div>



<script>
(function() {
  // Helper: escapar HTML
  function escapeHtml(str) {
    if (str === null || str === undefined) return '';
    return String(str)
      .replace(/&/g,'&amp;')
      .replace(/</g,'&lt;')
      .replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;')
      .replace(/'/g,'&#39;');
  }

  const urlParams = new URLSearchParams(window.location.search);
  const modo = urlParams.get('modo') || '';

  // Asegurar que existe un contenedor para la retroalimentación
  let area = document.getElementById('retroArea');
  if (!area) {
    const main = document.getElementById('main') || document.getElementById('areaPreguntas') || document.body;
    area = document.createElement('div');
    area.id = 'retroArea';
    area.style.marginTop = '18px';
    area.style.padding = '12px';
    area.style.borderRadius = '8px';
    area.style.background = 'var(--card)';
    if (main && main.parentNode) main.parentNode.insertBefore(area, main.nextSibling);
    else document.body.appendChild(area);
  }

  if (modo !== 'retroalimentacion') {
    area.innerHTML = '<p class="feedback good">Modo: ' + escapeHtml(modo || 'práctica') + '. No se solicitó retroalimentación.</p>';
    try { sessionStorage.removeItem('retro'); sessionStorage.removeItem('retro_full'); } catch(e) {}
    return;
  }

  // Intentar leer retro_full (preferido), si no existe, intentar retro (menos info)
  let rawFull = '[]';
  try { rawFull = sessionStorage.getItem('retro_full') || '[]'; } catch(e) { rawFull = '[]'; }
  let retroFull;
  try { retroFull = JSON.parse(rawFull); } catch(e) { retroFull = []; }

  // Si no hay retro_full, intentar leer retro (array de preguntaCompleta)
  if ((!Array.isArray(retroFull) || retroFull.length === 0)) {
    let raw = '[]';
    try { raw = sessionStorage.getItem('retro') || '[]'; } catch(e) { raw = '[]'; }
    let retro;
    try { retro = JSON.parse(raw); } catch(e) { retro = []; }

    if (!Array.isArray(retro) || retro.length === 0) {
      area.innerHTML = '<p class="feedback good">¡Buen trabajo! No hay errores para retroalimentar.</p>';
      try { sessionStorage.removeItem('retro'); sessionStorage.removeItem('retro_full'); } catch(e) {}
      return;
    }

    // Construir una versión simple de retroFull a partir de retro (no tenemos seleccion del usuario)
    retroFull = retro.map((p, idx) => {
      const correctaIdx = (typeof p.correcta === 'number') ? p.correcta : 0;
      const correctaTexto = (Array.isArray(p.opciones) && p.opciones[correctaIdx]) ? p.opciones[correctaIdx] : '';
      return {
        pregunta: p.pregunta || '',
        opciones: p.opciones || [],
        correctaIdx: correctaIdx,
        seleccionIdx: null,
        seleccionTexto: '(sin registro de selección)',
        correctaTexto: correctaTexto,
        explicacion: p.retro || '',
        materia: p.materia || '',
        unidad: p.unidad || '',
        tema: p.tema || '',
        dificultad: p.dificultad || ''
      };
    });
  }

  // Filtrar solo las preguntas en las que el usuario se equivocó (si seleccionIdx es null, asumimos que fue error)
  const falladas = retroFull.filter(item => {
    // Si seleccionIdx is null -> no info del usuario; consideramos que fue fallada (ya que se guardó solo cuando hubo error)
    if (item.seleccionIdx === null || typeof item.seleccionIdx === 'undefined') return true;
    return Number(item.seleccionIdx) !== Number(item.correctaIdx);
  });

  if (!Array.isArray(falladas) || falladas.length === 0) {
    area.innerHTML = '<p class="feedback good">¡Buen trabajo! No hay errores para retroalimentar.</p>';
    try { sessionStorage.removeItem('retro'); sessionStorage.removeItem('retro_full'); } catch(e) {}
    return;
  }

  // Construir HTML mostrando la respuesta del usuario en rojo y la correcta en verde
  let html = '<div class="retro-list"><h3>Retroalimentación</h3>';
  falladas.forEach((item, idx) => {
    const num = idx + 1;
    html += '<div class="retro-item" style="margin-bottom:12px;padding:10px;border-radius:6px;background:#fff;">';
    html += '<div class="retro-pregunta" style="font-weight:600;margin-bottom:6px;">Pregunta ' + num + ': ' + escapeHtml(item.pregunta || '') + '</div>';

    // Mostrar opciones con marcado de selección y correcta
    if (Array.isArray(item.opciones) && item.opciones.length > 0) {
      html += '<ul class="retro-opciones" style="list-style:none;padding-left:0;margin:0 0 8px 0;">';
      item.opciones.forEach((opt, iOpt) => {
        const isUser = (item.seleccionIdx !== null && Number(item.seleccionIdx) === iOpt);
        const isCorrect = (Number(item.correctaIdx) === iOpt);
        let style = 'padding:6px 8px;border-radius:4px;margin-bottom:6px;display:block;';
        if (isCorrect) style += 'background:#e6ffed;color:#0b6623;border:1px solid #b7f0c6;'; // verde suave
        else if (isUser) style += 'background:#ffecec;color:#8b0000;border:1px solid #f5bcbc;'; // rojo suave
        else style += 'background:transparent;color:inherit;border:1px solid transparent;';
        html += '<li style="' + style + '">' + escapeHtml(opt) + '</li>';
      });
      html += '</ul>';
    } else {
      // Si no hay opciones, mostrar la selección y la correcta textual
      html += '<div><span style="color:#8b0000;font-weight:600;">Tu respuesta: </span>' + escapeHtml(item.seleccionTexto || '(sin respuesta)') + '</div>';
      html += '<div><span style="color:#0b6623;font-weight:600;">Respuesta correcta: </span>' + escapeHtml(item.correctaTexto || '') + '</div>';
    }

    // Explicación / retro
    if (item.explicacion) {
      html += '<div class="retro-text" style="margin-top:6px;color:#333;">' + escapeHtml(item.explicacion) + '</div>';
    }

    html += '</div>';
  });
  html += '</div>';

  area.innerHTML = html;

  // Después de mostrar, eliminar las claves para no repetir la retro en futuras visitas
  try { sessionStorage.removeItem('retro'); sessionStorage.removeItem('retro_full'); } catch(e) {}
})();
</script>

</body>
</html>

