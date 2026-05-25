<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,java.util.*" %>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
%>
<%
    String materia = request.getParameter("materia");
    String unidad = request.getParameter("unidad");
    String tema = request.getParameter("tema");
    String dificultad = request.getParameter("dificultad");
    String modo = request.getParameter("modo");

    if (materia == null || unidad == null || tema == null || dificultad == null || modo == null) {
        response.sendRedirect(request.getContextPath() + "/seleccionar.jsp");
        return;
    }

    Object idObj = session.getAttribute("id_est");
    String idEst = (idObj != null) ? idObj.toString() : "1";

    String materiaJs = esc(materia);
    String unidadJs = esc(unidad);
    String temaJs = esc(tema);
    String dificultadJs = esc(dificultad);
    String modoJs = esc(modo);
    String idEstJs = esc(idEst);
    String contextPath = request.getContextPath();
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Cuestionario</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/theme.css">
    <link rel="stylesheet" href="../css/estilos_general.css">
    <link rel="stylesheet" href="../css/semestres.css">
    <link rel="stylesheet" href="../css/calculoIntegral.css">
</head>
<body>

<header>
  <div class="logo">
    <a href="inicio.jsp">
        <img src="logo.png" alt="logo">
    </a>
</div>


  <nav class="navs">
    
    <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuEstudia')">Estudia</div>
      <div class="submenu" id="menuEstudia">
        <a href="../html/cuestionarios.html">Cuestionarios</a>
        <a href="#">Matemáticas interactivas</a>
        <a href="../html/modoConcentracion.html"> Modo concentración</a>
      </div>
    </div>

    <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuRecursos')">Recursos académicos</div>
      <div class="submenu" id="menuRecursos">
        <a href="#">Contenido de apoyo</a>
      </div>
    </div>

    <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuComunidad')">Comunidad</div>
      <div class="submenu" id="menuComunidad">
        <a href="#">Apoyo entre estudiantes</a>
        <a href="#">Eventos</a>
        <a href="#">Proyectos estudiantiles</a>
      </div>
    </div>

    <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuProgreso')">Mi progreso</div>
      <div class="submenu" id="menuProgreso">
        
        <a href="../CalendarioGeneral.jsp">Calendario</a>
        <a href="#">Panel de progreso</a>
      </div>
    </div>

  </nav>

  <div class="cuenta">
    <div class="icono-cuenta" onclick="abrirMenu('menuCuenta')">U</div>
    <div class="submenu-cuenta" id="menuCuenta">
      <a href="#">Mi cuenta</a>
      <a href="#">Ayuda</a>
      <a href="#">Cerrar sesión</a>
    </div>
  </div>
</header>

    <center>
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h2>Cuestionario: <%= materia %> - Unidad <%= unidad %> - <%= tema %></h2>
                    <div><span id="temporizador" class="badge"></span></div>
                </div>
                <div class="card-body">
                    <div id="areaPreguntas"></div>
                    <div style="margin-top:12px;">
                        <button id="btnAnterior" class="btn secondary small">Anterior</button>
                        <button id="btnSiguiente" class="btn small">Siguiente</button>
                        <button id="btnTerminar" class="btn ghost small">Terminar</button>
                    </div>
                </div>
            </div>
        </div>
    </center>

    <script src="<%= contextPath %>/js/preguntas.js"></script>
    <script src="<%= contextPath %>/js/temporizador.js"></script>

    <script>
        'use strict';

        const materia = '<%= materiaJs %>';
        const unidad = parseInt('<%= unidadJs %>', 10);
        const tema = '<%= temaJs %>';
        const dificultad = '<%= dificultadJs %>';
        const modo = '<%= modoJs %>';
        const idEst = '<%= idEstJs %>';
        const basePath = '<%= contextPath %>';

        const area = document.getElementById('areaPreguntas');
        const temporizadorSpan = document.getElementById('temporizador');
        const btnSiguiente = document.getElementById('btnSiguiente');
        const btnAnterior = document.getElementById('btnAnterior');
        const btnTerminar = document.getElementById('btnTerminar');

        function escapeHtml(str) {
            if (str === null || str === undefined) return '';
            return String(str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        const conjunto = (window.preguntas &&
                          window.preguntas[materia] &&
                          window.preguntas[materia][unidad] &&
                          window.preguntas[materia][unidad][tema] &&
                          window.preguntas[materia][unidad][tema][dificultad])
            ? window.preguntas[materia][unidad][tema][dificultad]
            : [];

        let indice = 0;
        let respuestas = new Array(conjunto.length).fill(null);

        function mostrarPregunta(i) {
            if (!conjunto || conjunto.length === 0) {
                area.innerHTML = '<p>No hay preguntas para esta selección.</p>';
                btnSiguiente.disabled = true;
                btnAnterior.disabled = true;
                btnTerminar.disabled = true;
                return;
            }

            const q = conjunto[i];

            let html = '<div class="exercise-area"><div class="problem"><strong>Pregunta ' + (i+1) + ':</strong> ' + escapeHtml(q.pregunta) + '</div>';
            html += '<div id="opciones">';
            q.opciones.forEach(function(op, idx) {
                const checked = respuestas[i] === idx ? 'checked' : '';
                html += '<label style="display:block; margin-bottom:8px;"><input type="radio" name="r' + i + '" value="' + idx + '" ' + checked + '> ' + escapeHtml(op) + '</label>';
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

        btnTerminar.addEventListener('click', terminarCuestionario);

        function terminarCuestionario() {
            if (!conjunto || conjunto.length === 0) {
                alert('No hay preguntas para evaluar.');
                return;
            }

            let aciertos = 0;
            const retroalimentaciones = [];
            for (let i = 0; i < conjunto.length; i++) {
                if (respuestas[i] === conjunto[i].correcta) {
                    aciertos++;
                } else {
                    retroalimentaciones.push({ pregunta: i+1, texto: conjunto[i].retro });
                }
            }

            const score = Math.round((aciertos / conjunto.length) * 100);

            const body = new URLSearchParams();
            body.append('id_est', idEst);
            body.append('materia', materia);
            body.append('unidad', unidad);
            body.append('tema', tema);
            body.append('dificultad', dificultad);
            body.append('modo', modo);
            body.append('calificacion', score);

            fetch(basePath + '/ServletGuardarResultado', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: body.toString()
            })
            .then(function(response) {
                if (!response.ok) throw new Error('HTTP ' + response.status);
                try {
                    sessionStorage.setItem('retro', JSON.stringify(retroalimentaciones));
                } catch (e) {
                    console.warn('No se pudo guardar retro en sessionStorage', e);
                }
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
                window.location.href = basePath + '/jsp/resultado.jsp?' + params.toString();
            })
            .catch(function(err) {
                console.error('Error al guardar resultado:', err);
                alert('Ocurrió un error al guardar el resultado. Intenta de nuevo.');
            });
        }

        if (modo === 'contrarreloj') {
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
                temporizadorSpan.textContent = '00:00';
            }
        } else {
            temporizadorSpan.style.display = 'none';
        }

        mostrarPregunta(0);

        console.log('Cuestionario cargado:', { materia, unidad, tema, dificultad, modo, totalPreguntas: conjunto.length });

        function abrirMenu(id){
            let menu = document.getElementById(id);
            menu.style.display = (menu.style.display === "block") ? "none" : "block";
        }
    </script>
</body>
</html>