<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%@ page session="true" %>



<%-- Helper para escapar en servidor (declarado una sola vez) --%>



<%!
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#39;");
  }
%>

<%
  // Comprobación de sesión (única declaración)
  Object idObj = session.getAttribute("id_est");
  if (idObj == null) {
      response.sendRedirect(request.getContextPath() + "/jsp/iniciar.jsp");
      return;
  }
  String idEst = idObj.toString();
  String contextPath = request.getContextPath();
%>


<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Cuestionario</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">

  <!-- Estilos -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos_general.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/moduloCuestionarios/css/theme.css?v=1.2">

  <style>
    .controls{display:flex;gap:10px;align-items:center;margin-top:12px}
    .counter{font-weight:700;color:var(--primary)}
    .exercise-area .problem{white-space:pre-wrap;font-family:"Courier New",monospace;background:var(--card);padding:14px;border-radius:10px;margin-bottom:12px;border:1px dashed rgba(0,0,0,0.04)}
    .opciones-wrap label{display:block;margin-bottom:10px;padding:12px;border-radius:10px;transition:background .12s,transform .08s;cursor:pointer;border:1px solid rgba(0,0,0,0.03)}
    .opciones-wrap input[type="radio"]{margin-right:10px}
    .hint-mini{font-size:0.95rem;color:rgba(33,48,42,0.6)}
    .timer-pill{background:rgba(0,0,0,0.06);padding:6px 10px;border-radius:999px;font-weight:700}
    .btn.positioned{position:relative;overflow:hidden}
  </style>
</head>
<body>

  <div class="container" style="padding-top:18px;padding-bottom:40px">
    <div class="card">
      <div class="card-header">
        <div style="display:flex;flex-direction:column;gap:6px;">
          <h2 id="tituloCuestionario">Cuestionario</h2>
          <div class="question-meta" style="display:flex;justify-content:space-between;align-items:center;gap:12px">
            <div style="flex:1;display:flex;align-items:center;gap:12px">
              <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="flex:1">
                <div id="progressFill" class="progress-fill" style="width:0%"></div>
              </div>
              <div class="counter" id="counterText">Pregunta 0 / 0</div>
            </div>
            <div style="display:flex;flex-direction:column;align-items:flex-end">
              <div class="hint-mini">Modo: <strong id="modoLabel">práctica</strong></div>
              <div><span id="temporizador" class="timer-pill" style="display:none">00:00</span></div>
            </div>
          </div>
        </div>
      </div>

      <div class="card-body">
        <div id="areaPreguntas"></div>

        <div class="controls" style="margin-top:14px">
          <button id="btnAnterior" class="btn ghost small positioned">Anterior</button>
          <button id="btnSiguiente" class="btn primary-solid small positioned">Siguiente</button>
          <button id="btnTerminar" class="btn secondary-solid small positioned">Terminar</button>
        </div>
      </div>
    </div>
  </div>

  <div class="blob b1" aria-hidden="true"></div>
  <div class="blob b2" aria-hidden="true"></div>

  <script>
    const BASE = '<%= contextPath %>';
    window.__BASE = BASE;
    window.__ID_EST = '<%= esc(idEst) %>';
  </script>

  <script src="${pageContext.request.contextPath}/moduloCuestionarios/js/preguntas.js"></script>
  <script src="${pageContext.request.contextPath}/moduloCuestionarios/js/temporizador.js"></script>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const materia = urlParams.get('materia') || 'Calculo Integral';
    const unidad = parseInt(urlParams.get('unidad') || '1', 10);
    const tema = urlParams.get('tema') || '';
    const dificultad = urlParams.get('dificultad') || 'medio';
    const modo = urlParams.get('modo') || 'practica';
    const idEst = window.__ID_EST || '';
    document.getElementById('modoLabel').textContent = modo;

    const conjunto = (window.preguntas &&
                     window.preguntas[materia] &&
                     window.preguntas[materia][unidad] &&
                     window.preguntas[materia][unidad][tema] &&
                     window.preguntas[materia][unidad][tema][dificultad])
      ? window.preguntas[materia][unidad][tema][dificultad]
      : [];

    let indice = 0;
    let respuestas = new Array(conjunto.length).fill(null);

    const area = document.getElementById('areaPreguntas');
    const btnSiguiente = document.getElementById('btnSiguiente');
    const btnAnterior = document.getElementById('btnAnterior');
    const btnTerminar = document.getElementById('btnTerminar');
    const progressFill = document.getElementById('progressFill');
    const counterText = document.getElementById('counterText');
    const temporizadorSpan = document.getElementById('temporizador');

    function escapeHtml(str) {
      if (str === null || str === undefined) return '';
      return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
    }

    function actualizarProgreso(i) {
      const total = conjunto.length || 1;
      const pct = Math.round(((i+1) / total) * 100);
      progressFill.style.width = pct + '%';
      counterText.textContent = 'Pregunta ' + (i+1) + ' / ' + total;
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

      actualizarProgreso(i);
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
          const preguntaCompleta = {
            pregunta: conjunto[i].pregunta,
            opciones: conjunto[i].opciones,
            correcta: correctaIdx,
            retro: conjunto[i].retro || '',
            materia: materia,
            unidad: unidad,
            tema: tema,
            dificultad: dificultad
          };

          retroalimentaciones.push({
            pregunta: i+1,
            seleccionTexto: seleccionTexto,
            correctaTexto: correctaTexto,
            texto: conjunto[i].retro || '',
            materia: materia,
            unidad: unidad,
            tema: tema,
            dificultad: dificultad,
            preguntaCompleta: preguntaCompleta
          });

          // Guardar en sessionStorage.retro de forma acumulativa
          try {
            const rawR = sessionStorage.getItem('retro');
            let arrR = rawR ? JSON.parse(rawR) : [];
            if (!Array.isArray(arrR)) arrR = [];
            arrR.push(preguntaCompleta);
            sessionStorage.setItem('retro', JSON.stringify(arrR));
          } catch (e) {
            console.warn('No se pudo guardar retro en sessionStorage', e);
          }
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

        // Preparar y enviar retro al servlet GuardarRetro
        try {
          const stored = sessionStorage.getItem('retro');
          const rawRetro = (stored && stored.length > 2) ? stored : JSON.stringify(retroalimentaciones);

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
          return Promise.resolve(new Response('{"status":"no-retro"}', { status: 200, headers: { 'Content-Type': 'application/json' } }));
        }
      })
      .then(resp => resp.text())
      .then(txt => {
        console.log('DEBUG: GuardarRetro response:', txt);
        try {
  if (txt && txt.indexOf('"status":"ok"') !== -1) {
    // No eliminar retro si vamos a mostrar retroalimentación en resultado.jsp
    if (modo !== 'retroalimentacion') {
      sessionStorage.removeItem('retro');
    } else {
      // dejamos retro en sessionStorage para que resultado.jsp lo muestre
      console.log('DEBUG: modo retroalimentacion — manteniendo sessionStorage.retro para resultado.jsp');
    }
  }
} catch(e){}

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
        window.location.href = '<%= contextPath %>/moduloCuestionarios/resultado.jsp?' + params.toString();
      })
      .catch(err => {
        console.error('Error guardando resultado o retro:', err);
        alert('Ocurrió un error al guardar el resultado. Intenta de nuevo.');
      });
    }

    // Temporizador (si aplica)
    if (modo === 'contrarreloj') {
      temporizadorSpan.style.display = 'inline-block';
      let segs = 0;
      if (dificultad === 'facil') segs = 5 * 60;
      else if (dificultad === 'medio') segs = 15 * 60;
      else if (dificultad === 'dificil') segs = 25 * 60;

      if (typeof iniciarTemporizador === 'function') {
        iniciarTemporizador(segs, function(t) {
          const m = Math.floor(t/60).toString().padStart(2,'0');
          const s = (t%60).toString().padStart(2,'0');
          temporizadorSpan.textContent = m + ':' + s;
        }, function() {
          alert('Tiempo agotado. Se terminará el cuestionario.');
          terminarCuestionario();
        });
      } else {
        const m = Math.floor(segs/60).toString().padStart(2,'0');
        const s = (segs%60).toString().padStart(2,'0');
        temporizadorSpan.textContent = m + ':' + s;
      }
    } else {
      temporizadorSpan.style.display = 'none';
    }

    mostrarPregunta(0);

    // Ripple visual (decorativo)
    document.querySelectorAll('.btn.positioned').forEach(btn => {
      btn.addEventListener('click', function(e){
        const rect = this.getBoundingClientRect();
        const circle = document.createElement('span');
        const size = Math.max(rect.width, rect.height);
        circle.style.width = circle.style.height = size + 'px';
        circle.style.position = 'absolute';
        circle.style.borderRadius = '50%';
        circle.style.left = (e.clientX - rect.left - size/2) + 'px';
        circle.style.top = (e.clientY - rect.top - size/2) + 'px';
        circle.style.background = 'rgba(255,255,255,0.12)';
        circle.style.transform = 'scale(0)';
        circle.style.transition = 'transform .5s ease, opacity .6s ease';
        circle.style.pointerEvents = 'none';
        this.appendChild(circle);
        requestAnimationFrame(()=> circle.style.transform = 'scale(1)');
        setTimeout(()=> { circle.style.opacity = '0'; }, 350);
        setTimeout(()=> { try { this.removeChild(circle); } catch(e){} }, 900);
      });
    });
  </script>

</body>
</html>
