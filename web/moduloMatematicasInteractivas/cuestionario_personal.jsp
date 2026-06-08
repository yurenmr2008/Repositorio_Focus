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
  <title>Cuestionario Personalizado</title>
  <link rel="stylesheet" href="<%= contextPath %>/css/theme.css?v=1.2">
</head>
<body>
<script>
  const BASE = '<%= request.getContextPath() %>';
  window.__BASE = BASE;
  window.__ID_EST = '<%= (session.getAttribute("id_est") != null) ? session.getAttribute("id_est").toString() : "" %>';
</script>
  <div class="container">
    <div class="card">
      <div class="card-header"><h2>Cuestionario personalizado</h2><div class="hint">Basado en tus errores previos</div></div>
      <div class="card-body">
        <div id="areaPreguntas"></div>
        <div class="controls">
          <button id="btnAnterior" class="btn ghost small positioned">Anterior</button>
          <button id="btnSiguiente" class="btn primary-solid small positioned">Siguiente</button>
          <button id="btnTerminar" class="btn secondary-solid small positioned">Terminar</button>
        </div>
      </div>
    </div>
  </div>
  <script>
    const raw = sessionStorage.getItem('mi_cuestionario_personal');
    let conjunto = [];
    try { conjunto = raw ? JSON.parse(raw) : []; } catch(e) { conjunto = []; }
    if (!Array.isArray(conjunto) || conjunto.length === 0) {
      alert('No hay preguntas personalizadas disponibles.');
      window.location.href = '<%= contextPath %>/moduloMatematicasInteractivas/matematicas_interactivas.jsp';
    }
  </script>
  <script>
    let indice = 0;
    let respuestas = new Array(conjunto.length).fill(null);
    const area = document.getElementById('areaPreguntas');
    const btnSiguiente = document.getElementById('btnSiguiente');
    const btnAnterior = document.getElementById('btnAnterior');
    const btnTerminar = document.getElementById('btnTerminar');
    function escapeHtml(str) {
      if (str === null || str === undefined) return '';
      return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
    }
    function mostrarPregunta(i) {
      if (!conjunto || conjunto.length === 0) {
        area.innerHTML = '<p>No hay preguntas.</p>';
        return;
      }
      const q = conjunto[i];
      let html = '<div class="exercise-area fade-in"><div class="problem"><strong>Pregunta ' + (i+1) + ':</strong> ' + escapeHtml(q.pregunta) + '</div>';
      html += '<div id="opciones" class="opciones-wrap">';
      q.opciones.forEach(function(op, idx) {
        const checked = respuestas[i] === idx ? 'checked' : '';
        html += '<label><input type="radio" name="r' + i + '" value="' + idx + '" ' + checked + '> <span>' + escapeHtml(op) + '</span></label>';
      });
      html += '</div></div>';
      area.innerHTML = html;
      const radios = Array.from(document.getElementsByName('r' + i));
      radios.forEach(function(r) {
        r.addEventListener('change', function() {
          respuestas[i] = parseInt(this.value, 10);
        });
      });
      btnAnterior.disabled = (i === 0);
      btnSiguiente.disabled = (i >= conjunto.length - 1);
    }
    btnSiguiente.addEventListener('click', function() {
      if (indice < conjunto.length - 1) {
        indice++;
        mostrarPregunta(indice);
      }
    });
    btnAnterior.addEventListener('click', function() {
      if (indice > 0) {
        indice--;
        mostrarPregunta(indice);
      }
    });
    btnTerminar.addEventListener('click', function() {
      let aciertos = 0;
      const retroalimentaciones = [];
      for (let i = 0; i < conjunto.length; i++) {
        const correctaIdx = conjunto[i].correcta;
        const elegidoIdx = respuestas[i];
        if (elegidoIdx === correctaIdx) {
          aciertos++;
        } else {
          const seleccionTexto = (typeof elegidoIdx === 'number' && conjunto[i].opciones[elegidoIdx] !== undefined)
            ? conjunto[i].opciones[elegidoIdx]
            : '(sin respuesta)';
          const correctaTexto = conjunto[i].opciones[correctaIdx] || '';
          retroalimentaciones.push({
            pregunta: i+1,
            seleccionTexto: seleccionTexto,
            correctaTexto: correctaTexto,
            texto: conjunto[i].retro || '',
            materia: conjunto[i].materia,
            unidad: conjunto[i].unidad,
            tema: conjunto[i].tema,
            dificultad: conjunto[i].dificultad
          });
          // registrar error en sessionStorage.retro para persistir
          try {
            const rawR = sessionStorage.getItem('retro');
            let arrR = rawR ? JSON.parse(rawR) : [];
            if (!Array.isArray(arrR)) arrR = [];
            arrR.push(conjunto[i]); // guardamos la estructura completa
            sessionStorage.setItem('retro', JSON.stringify(arrR));
          } catch(e){ console.warn('No se pudo guardar retro', e); }
        }
      }
      const score = Math.round((aciertos / conjunto.length) * 100);
      const body = new URLSearchParams();
      body.append('id_est', '<%= idEst %>');
      body.append('materia', conjunto[0].materia || '');
      body.append('unidad', conjunto[0].unidad || '');
      body.append('tema', conjunto[0].tema || '');
      body.append('dificultad', 'personalizado');
      body.append('modo', 'practica');
      body.append('calificacion', score);
      fetch('<%= contextPath %>/ServletGuardarResultado', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: body.toString()
      })
      .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        try { sessionStorage.setItem('retro', JSON.stringify(retroalimentaciones)); } catch(e) {}
        const params = new URLSearchParams({
          score: score,
          aciertos: aciertos,
          total: conjunto.length,
          materia: conjunto[0].materia || '',
          unidad: conjunto[0].unidad || '',
          tema: conjunto[0].tema || '',
          dificultad: 'personalizado',
          modo: 'practica'
        });
        window.location.href = '<%= contextPath %>/resultado.jsp?' + params.toString();
      })
      .catch(err => {
        console.error('Error guardando resultado:', err);
        alert('Ocurrió un error al guardar el resultado.');
      });
    });
    mostrarPregunta(0);
  </script>
</body>
</html>
