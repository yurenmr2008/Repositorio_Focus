<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>


<%
  // Comprobación de sesión (redirige al login si no hay usuario)
  Object idObj = session.getAttribute("id_est");
  if (idObj == null) {
      response.sendRedirect(request.getContextPath() + "/jsp/iniciar.jsp");
      return;
  }
  String idEst = idObj.toString();
%>


<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Seleccionar cuestionario</title>

  <!-- Estilos globales del proyecto principal -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos_general.css">
  <!-- Estilos específicos del módulo (opcional) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/moduloCuestionarios/css/theme.css?v=1.2">

  <style>
    .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
    @media (max-width:720px){.form-grid{grid-template-columns:1fr}}
    .card-body form{max-width:720px;margin:0 auto}
    .select-illustration { display:flex; align-items:center; justify-content:center; margin-top:20px; }
    .select-illustration img { width:260px; max-width:90%; height:auto; border-radius:12px; box-shadow:0 12px 30px rgba(0,0,0,0.08); }
    .accent-subtitle { font-family: "Dancing Script", cursive; font-size:18px; color:var(--mint); }
    .small-note{font-size:0.9rem;color:rgba(33,48,42,0.6);margin-top:6px}
  </style>
</head>
<body>
  <div class="container" style="padding-top:18px;padding-bottom:40px">
    <div class="card">
      <div class="card-header">
        <h2>Selecciona tu cuestionario</h2>
        <div class="hint">Rellena las opciones y pulsa Iniciar</div>
      </div>

      <div class="card-body">
        <form id="formSeleccion" autocomplete="off" novalidate>
          <div class="form-grid">
            <div>
              <label for="materia">Materia</label>
              <select id="materia" required>
                <option value="">-- Selecciona --</option>
                <option>Calculo Diferencial</option>
                <option>Calculo Integral</option>
              </select>
            </div>

            <div>
              <label for="unidad">Unidad</label>
              <select id="unidad" required>
                <option value="">-- Selecciona --</option>
                <option value="1">Unidad 1</option>
                <option value="2">Unidad 2</option>
                <option value="3">Unidad 3</option>
              </select>
            </div>

            <div>
              <label for="tema">Tema</label>
              <select id="tema" required>
                <option value="">-- Selecciona materia y unidad --</option>
              </select>
            </div>

            <div>
              <label for="dificultad">Dificultad</label>
              <select id="dificultad" required>
                <option value="">-- Selecciona --</option>
                <option value="facil">Fácil</option>
                <option value="medio">Medio</option>
                <option value="dificil">Difícil</option>
              </select>
            </div>

            <div>
              <label for="modo">Modo</label>
              <select id="modo" required>
                <option value="">-- Selecciona --</option>
                <option value="practica">Práctica</option>
                <option value="contrarreloj">Contrarreloj</option>
                <option value="retroalimentacion">Con retroalimentación</option>
              </select>
              <div class="small-note">Contrarreloj activa temporizador; retroalimentación muestra explicaciones.</div>
            </div>

            <div style="display:flex;align-items:flex-end;gap:10px">
              <div style="width:100%">
                <label style="visibility:hidden">placeholder</label>
                <div style="display:flex;gap:8px">
                  <button type="button" class="btn primary-solid positioned" id="btnIniciar">Iniciar</button>
                  <a href="${pageContext.request.contextPath}/moduloCuestionarios/index.jsp" class="btn ghost positioned">Cancelar</a>
                </div>
                <div class="small-note">Tip: prueba "Contrarreloj" para medir tu velocidad.</div>
              </div>
            </div>
          </div>
        </form>

        <!-- Ilustración centrada y más grande -->
        <div class="select-illustration" aria-hidden="true">
          <img src="${pageContext.request.contextPath}/moduloCuestionarios/images/card-illustration.png" alt="Ilustración tema">
        </div>

        <div style="margin-top:12px;text-align:center">
          <div class="accent-subtitle">Elige con calma</div>
          <div class="hint">Cada tema tiene ejercicios organizados por dificultad.</div>
        </div>
      </div>
    </div>
  </div>

  <!-- Scripts: usar rutas absolutas dentro del contexto -->
  <script>
    const BASE = '<%= request.getContextPath() %>';
    window.__BASE = BASE;
    window.__ID_EST = '<%= idEst %>';
  </script>

  <script src="${pageContext.request.contextPath}/moduloCuestionarios/js/preguntas.js"></script>
  <script>
    const materiaSel = document.getElementById('materia');
    const unidadSel = document.getElementById('unidad');
    const temaSel = document.getElementById('tema');
    const btnIniciar = document.getElementById('btnIniciar');

    function actualizarTemas() {
      const materia = materiaSel.value;
      const unidad = unidadSel.value ? parseInt(unidadSel.value) : null;
      temaSel.innerHTML = '<option value="">-- Selecciona --</option>';
      if (!materia || !unidad) {
        temaSel.innerHTML = '<option value="">-- Selecciona materia y unidad --</option>';
        return;
      }
      // obtenerTemas debe estar definido en preguntas.js; si no, usar fallback
      const temas = (typeof window.obtenerTemas === 'function') ? window.obtenerTemas(materia, unidad) : [];
      if (!temas || temas.length === 0) {
        temaSel.innerHTML = '<option value="">No hay temas para esta selección</option>';
        return;
      }
      temas.forEach(t => {
        const opt = document.createElement('option');
        opt.value = t;
        opt.textContent = t;
        temaSel.appendChild(opt);
      });
    }

    materiaSel.addEventListener('change', actualizarTemas);
    unidadSel.addEventListener('change', actualizarTemas);

    btnIniciar.addEventListener('click', function() {
      const materia = materiaSel.value;
      const unidad = unidadSel.value;
      const tema = temaSel.value;
      const dificultad = document.getElementById('dificultad').value;
      const modo = document.getElementById('modo').value;
      if (!materia || !unidad || !tema || !dificultad || !modo) {
        alert('Completa todas las selecciones.');
        return;
      }
      // Redirigir al cuestionario dentro del mismo contexto
      const params = new URLSearchParams({materia, unidad, tema, dificultad, modo});
      window.location.href = BASE + '/moduloCuestionarios/cuestionario.jsp?' + params.toString();
    });

    document.addEventListener('DOMContentLoaded', function() {
      actualizarTemas();
    });

    // Ripple visual para botones (decorativo)
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
