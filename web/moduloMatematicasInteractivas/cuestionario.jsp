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
  <title>Cuestionario</title>
  <link rel="stylesheet" href="<%= contextPath %>/css/theme.css?v=1.2">
  <style>
    .controls{display:flex;gap:10px;align-items:center;margin-top:12px}
    .counter{font-weight:700;color:var(--primary)}
  </style>
</head>
<body>
<script>
  const BASE = '<%= request.getContextPath() %>';
  window.__BASE = BASE;
  window.__ID_EST = '<%= (session.getAttribute("id_est") != null) ? session.getAttribute("id_est").toString() : "" %>';
</script>


  <!-- 
<div class="app-topbar" role="banner">
  <div class="brand">
    <div class="logo-badge">F</div>
    <div>
      <div style="font-size:13px;opacity:0.9">Focus</div>
      <div style="font-weight:800">Matemáticas</div>
    </div>
  </div>
  <div style="display:flex;gap:10px;align-items:center">
    <a class="btn ghost" href="<%= contextPath %>/index.jsp">Inicio</a>
    <a class="btn ghost" href="<%= contextPath %>/seleccionar.jsp">Seleccionar</a>
    <a class="btn secondary-solid" href="<%= contextPath %>/perfil.jsp">Mi avance</a>
  </div>
</div>
-->
  <div class="container">
    <div class="card">
      <div class="card-header">
        <h2 id="tituloCuestionario">Cuestionario</h2>
      </div>
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

  <script src="<%= contextPath %>/js/preguntas.js"></script>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const materia = urlParams.get('materia') || '';
    const unidad = parseInt(urlParams.get('unidad') || '1', 10);
    const tema = urlParams.get('tema') || '';
    const dificultad = urlParams.get('dificultad') || 'medio';
    const modo = urlParams.get('modo') || 'practica';
    const idEst = '<%= idEst %>';

    // --- Priorizar mi_cuestionario_personal si existe (origen=interactivo) ---
    function obtenerConjunto() {
      try {
        const origen = urlParams.get('origen') || '';
        const stored = sessionStorage.getItem('mi_cuestionario_personal');
        if (stored && (origen === 'interactivo' || stored.trim().length > 0)) {
          try {
            const arr = JSON.parse(stored);
            if (Array.isArray(arr) && arr.length > 0) {
              // opcional: eliminar para evitar reuso accidental
              // sessionStorage.removeItem('mi_cuestionario_personal');
              return arr;
            }
          } catch (e) { console.warn('mi_cuestionario_personal inválido', e); }
        }
      } catch (e) { console.warn('Error leyendo mi_cuestionario_personal', e); }

      // Fallback a preguntas.js
      try {
        const conjuntoLocal = (window.preguntas &&
          window.preguntas[materia] &&
          window.preguntas[materia][unidad] &&
          window.preguntas[materia][unidad][tema] &&
          window.preguntas[materia][unidad][tema][dificultad])
          ? window.preguntas[materia][unidad][tema][dificultad]
          : [];
        return Array.isArray(conjuntoLocal) ? conjuntoLocal : [];
      } catch (e) {
        console.warn('Error construyendo conjunto desde preguntas.js', e);
        return [];
      }
    }

    const conjunto = obtenerConjunto();

    // Si venimos de interactivo, opcionalmente limpiar el storage
    try {
      const origen = urlParams.get('origen') || '';
      if (origen === 'interactivo') sessionStorage.removeItem('mi_cuestionario_personal');
    } catch(e){}

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
        area.innerHTML = '<p>No hay preguntas para esta selección.</p>';
        btnSiguiente.disabled = true;
        btnAnterior.disabled = true;
        btnTerminar.disabled = true;
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

    // Guarda un objeto de error en sessionStorage.retro (estructura que espera GuardarRetro)
    function registrarErrorPregunta(objPregunta) {
      try {
        const raw = sessionStorage.getItem('retro');
        let arr = [];
        if (raw) {
          arr = JSON.parse(raw);
          if (!Array.isArray(arr)) arr = [];
        }
        arr.push(objPregunta);
        sessionStorage.setItem('retro', JSON.stringify(arr));
      } catch (e) {
        console.warn('No se pudo guardar retro en sessionStorage', e);
      }
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

    btnTerminar.addEventListener('click', terminarCuestionario);

    function terminarCuestionario() {
  if (!conjunto || conjunto.length === 0) {
    alert('No hay preguntas para evaluar.');
    return;
  }

  let aciertos = 0;
  const retroalimentaciones = []; // entries con seleccionTexto, correctaTexto, preguntaCompleta
  const preguntasParaServidor = []; // array de preguntaCompleta que enviaremos a GuardarRetro

  for (let i = 0; i < conjunto.length; i++) {
    const correctaIdx = conjunto[i].correcta;
    const elegidoIdx = respuestas[i];

    if (elegidoIdx === correctaIdx) {
      aciertos++;
    } else {
      const seleccionTexto = (typeof elegidoIdx === 'number' && conjunto[i].opciones && conjunto[i].opciones[elegidoIdx] !== undefined)
        ? conjunto[i].opciones[elegidoIdx]
        : '(sin respuesta)';
      const correctaTexto = (conjunto[i].opciones && conjunto[i].opciones[correctaIdx]) ? conjunto[i].opciones[correctaIdx] : '';

      // preguntaCompleta que el servidor espera (y que guardamos en "retro")
      const preguntaCompleta = {
        pregunta: conjunto[i].pregunta || '',
        opciones: conjunto[i].opciones || [],
        correcta: typeof correctaIdx === 'number' ? correctaIdx : 0,
        retro: conjunto[i].retro || '',
        materia: materia || conjunto[i].materia || '',
        unidad: Number(unidad || conjunto[i].unidad || 0),
        tema: tema || conjunto[i].tema || '',
        dificultad: dificultad || conjunto[i].dificultad || ''
      };

      // entry extendida para mostrar en resultado.jsp (incluye la selección del usuario)
      const entryFull = {
        pregunta: conjunto[i].pregunta || '',
        opciones: conjunto[i].opciones || [],
        correctaIdx: typeof correctaIdx === 'number' ? correctaIdx : 0,
        seleccionIdx: (typeof elegidoIdx === 'number') ? elegidoIdx : null,
        seleccionTexto: seleccionTexto,
        correctaTexto: correctaTexto,
        explicacion: conjunto[i].retro || '',
        materia: preguntaCompleta.materia,
        unidad: preguntaCompleta.unidad,
        tema: preguntaCompleta.tema,
        dificultad: preguntaCompleta.dificultad
      };

      retroalimentaciones.push(entryFull);
      preguntasParaServidor.push(preguntaCompleta);
    }
  }

  const score = Math.round((aciertos / conjunto.length) * 100);

  // Guardar resultado en servidor
  const bodyResultado = new URLSearchParams();
  bodyResultado.append('id_est', idEst);
  bodyResultado.append('materia', materia);
  bodyResultado.append('unidad', unidad);
  bodyResultado.append('tema', tema);
  bodyResultado.append('dificultad', dificultad);
  bodyResultado.append('modo', modo);
  bodyResultado.append('calificacion', score);

  fetch('<%= contextPath %>/ServletGuardarResultado', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
    body: bodyResultado.toString()
  })
  .then(r => {
    if (!r.ok) throw new Error('HTTP ' + r.status);
    return r.text();
  })
  .then(resultTxt => {
    console.log('DEBUG: ServletGuardarResultado response:', resultTxt);

    // Guardar en sessionStorage:
    // - retro_full: para mostrar en resultado.jsp (contiene seleccionTexto y correctaTexto)
    // - retro: array de preguntaCompleta que se enviará al servidor (y que el servlet espera)
    try {
      sessionStorage.setItem('retro_full', JSON.stringify(retroalimentaciones));
      sessionStorage.setItem('retro', JSON.stringify(preguntasParaServidor));
    } catch (e) {
      console.warn('No se pudo guardar retro en sessionStorage', e);
    }

    // Preparar y enviar GuardarRetro (solo preguntasParaServidor)
    try {
      const rawRetro = sessionStorage.getItem('retro') || JSON.stringify(preguntasParaServidor || []);
      console.log('DEBUG: enviarRetro - raw length:', rawRetro ? rawRetro.length : 0, 'raw sample:', rawRetro ? rawRetro.substring(0,200) : null);

      const body2 = new URLSearchParams();
      body2.append('retro', rawRetro);
      if (idEst) body2.append('id_est', idEst);

      return fetch('<%= contextPath %>/GuardarRetro', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: body2.toString()
      });
    } catch (e) {
      console.warn('DEBUG: error preparando retro para envío:', e);
      // devolvemos una respuesta simulada para continuar el flujo
      return Promise.resolve(new Response('{"status":"no-retro"}', { status: 200, headers: { 'Content-Type': 'application/json' } }));
    }
  })
  .then(resp => resp.text())
  .then(txt => {
    console.log('DEBUG: GuardarRetro response:', txt);
    try {
      // Solo eliminar la clave 'retro' si NO vamos a mostrar retro en resultado.jsp
      if (txt && txt.indexOf('"status":"ok"') !== -1) {
        if (modo !== 'retroalimentacion') {
          sessionStorage.removeItem('retro');
          sessionStorage.removeItem('retro_full');
        } else {
          console.log('DEBUG: modo retroalimentacion — manteniendo sessionStorage.retro_full para resultado.jsp');
        }
      }
    } catch(e){}

    // Construir params para la redirección final
    const params = new URLSearchParams({
      score: score,
      aciertos: aciertos,
      total: conjunto.length,
      materia: materia,
      unidad: unidad,
      tema: tema,
      dificultad: dificultad,
      modo: modo
    });

    // Si modo retroalimentacion: esperar 6000ms para que el usuario vea la retro en la misma página (si quieres)
    // Aquí redirigimos inmediatamente; resultado.jsp leerá sessionStorage.retro_full y mostrará la retro.
    window.location.href = '<%= contextPath %>/moduloCuestionarios/resultado.jsp?' + params.toString();
  })
  .catch(err => {
    console.error('Error guardando resultado o retro:', err);
    alert('Ocurrió un error al guardar el resultado. Intenta de nuevo.');
  });
}


    mostrarPregunta(0);
  </script>
</body>
</html>
