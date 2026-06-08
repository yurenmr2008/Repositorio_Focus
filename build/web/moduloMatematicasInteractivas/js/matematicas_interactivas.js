// Web: moduloMatematicasInteractivas/js/matematicas_interactivas.js
(function(){
  const BASE = window.__BASE || '';
  const API_TEMAS = BASE + '/ObtenerTemasRetro';
  const API_OBTENER_ERRORES = BASE + '/ServletObtenerErrores';
  const API_MARCAR = BASE + '/MarcarCompletado';
  const idEst = window.__ID_EST || '';

  function cargarTemas() {
    const url = API_TEMAS + (idEst ? ('?usuario=' + encodeURIComponent(idEst)) : '');
    fetch(url)
      .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
      })
      .then(arr => {
        if (!arr || arr.length === 0) fallbackTemasDesdePreguntas();
        else renderTemas(arr);
      })
      .catch(err => {
        console.warn('Error al obtener temas (usar fallback):', err);
        fallbackTemasDesdePreguntas();
      });
  }

  function fallbackTemasDesdePreguntas() {
    try {
      const preguntasGlobal = window.preguntas || {};
      const temas = [];
      Object.keys(preguntasGlobal).forEach(materia => {
        const unidades = preguntasGlobal[materia];
        Object.keys(unidades).forEach(u => {
          const unidadObj = unidades[u];
          Object.keys(unidadObj).forEach(tema => {
            temas.push({ materia: materia, unidad: parseInt(u,10), tema: tema, count: 0 });
          });
        });
      });
      if (temas.length > 0) renderTemas(temas);
      else document.getElementById('topicsGrid').innerHTML = '<div class="hint">No tienes errores registrados. ¡Buen trabajo!</div>';
    } catch(e) {
      console.warn('fallbackTemas error', e);
      document.getElementById('topicsGrid').innerHTML = '<div class="hint">No hay temas disponibles.</div>';
    }
  }

  function renderTemas(temas) {
    const grid = document.getElementById('topicsGrid');
    if (!grid) return;
    grid.innerHTML = '';
    if (!Array.isArray(temas) || temas.length === 0) {
      grid.innerHTML = '<div class="hint">No tienes errores registrados. ¡Buen trabajo!</div>';
      return;
    }
    temas.forEach(t => {
      const card = document.createElement('div');
      card.className = 'topic-card';
      const title = document.createElement('h4'); title.textContent = t.materia + ' · Unidad ' + t.unidad;
      const temaEl = document.createElement('div'); temaEl.className = 'meta'; temaEl.textContent = t.tema;
      const errores = (typeof t.count === 'number' && t.count > 0) ? t.count : 0;
      const count = document.createElement('div'); count.className = 'count'; count.textContent = errores + (errores === 1 ? ' error' : ' errores');
      const actions = document.createElement('div'); actions.style.display='flex'; actions.style.gap='8px'; actions.style.marginTop='8px';
      const btnPracticar = document.createElement('button'); btnPracticar.className='btn primary-solid'; btnPracticar.textContent='Practicar';
      btnPracticar.addEventListener('click', () => iniciarCuestionario(t.materia, t.unidad, t.tema));
      const btnCompletar = document.createElement('button'); btnCompletar.className='btn crema'; btnCompletar.textContent='Marcar completado';
      btnCompletar.addEventListener('click', () => marcarCompletado(t.materia, t.unidad, t.tema));
      actions.appendChild(btnPracticar); actions.appendChild(btnCompletar);
      card.appendChild(title); card.appendChild(temaEl); card.appendChild(count); card.appendChild(actions);
      grid.appendChild(card);
    });
    document.querySelectorAll('.topic-card .btn.crema').forEach(btn => {
      btn.style.backgroundColor = '#FCFCE4';
      btn.style.color = '#ffffff';
      btn.style.border = 'none';
      btn.style.boxShadow = '0 8px 20px rgba(0,0,0,0.06)';
      btn.style.fontWeight = '700';
      btn.style.padding = '10px 14px';
      btn.style.borderRadius = '10px';
    });
  }

  function marcarCompletado(materia, unidad, tema) {
    if (!confirm('Marcar este tema como completado eliminará los errores guardados para él. ¿Continuar?')) return;
    const body = new URLSearchParams();
    body.append('materia', materia);
    body.append('unidad', unidad);
    body.append('tema', tema);
    if (idEst) body.append('usuario', idEst);
    fetch(API_MARCAR, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: body.toString()
    })
    .then(r => r.json())
    .then(j => {
      if (j && j.status === 'ok') { alert('Tema marcado como completado.'); cargarTemas(); }
      else alert('No se pudo marcar como completado.');
    })
    .catch(err => { console.error('Error marcando completado:', err); alert('Error al marcar completado.'); });
  }

  function iniciarCuestionario(materia, unidad, tema) {
    const params = new URLSearchParams({ materia: materia, unidad: unidad, tema: tema, usuario: idEst });
    const url = API_OBTENER_ERRORES + '?' + params.toString();
    fetch(url)
      .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
      })
      .then(arr => {
        if (Array.isArray(arr) && arr.length > 0) {
          sessionStorage.setItem('mi_cuestionario_personal', JSON.stringify(arr));
          window.location.href = (window.__BASE || '') + '/moduloCuestionarios/cuestionario.jsp?origen=interactivo&materia=' + encodeURIComponent(materia) + '&unidad=' + encodeURIComponent(unidad) + '&tema=' + encodeURIComponent(tema);
        } else {
          usarFallbackLocal(materia, unidad, tema);
        }
      })
      .catch(err => {
        console.warn('Error obteniendo preguntas falladas, usando fallback local:', err);
        usarFallbackLocal(materia, unidad, tema);
      });
  }

  function usarFallbackLocal(materia, unidad, tema) {
    const preguntasGlobal = window.preguntas || {};
    const unidadNum = parseInt(unidad, 10);
    const conjuntoTema = (preguntasGlobal[materia] &&
                     preguntasGlobal[materia][unidadNum] &&
                     preguntasGlobal[materia][unidadNum][tema]) ? preguntasGlobal[materia][unidadNum][tema] : null;
    if (!conjuntoTema) { alert('No hay preguntas disponibles para este tema.'); return; }
    const seleccion = [];
    Object.keys(conjuntoTema).forEach(dif => {
      const arrDif = conjuntoTema[dif];
      if (Array.isArray(arrDif)) {
        arrDif.forEach(q => {
          seleccion.push({
            pregunta: q.pregunta,
            opciones: q.opciones,
            correcta: q.correcta,
            retro: q.retro || '',
            materia: materia,
            unidad: unidadNum,
            tema: tema,
            dificultad: dif
          });
        });
      }
    });
    if (seleccion.length === 0) { alert('No hay preguntas en el cliente para este tema.'); return; }
    seleccion.sort(() => Math.random() - 0.5);
    sessionStorage.setItem('mi_cuestionario_personal', JSON.stringify(seleccion));
    window.location.href = (window.__BASE || '') + '/moduloCuestionarios/cuestionario.jsp?origen=interactivo&materia=' + encodeURIComponent(materia) + '&unidad=' + encodeURIComponent(unidad) + '&tema=' + encodeURIComponent(tema);
  }

  document.addEventListener('DOMContentLoaded', function(){ cargarTemas(); });

  window._miModuloMat = { iniciarCuestionario, cargarTemas };
})();
