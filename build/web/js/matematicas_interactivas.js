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
  // Filtrar entradas inválidas
  if (!t || !t.tema || t.tema.toString().trim() === '') {
    console.warn('Tema inválido ignorado', t);
    return;
  }
  const unidadNum = Number(t.unidad || 0);
  if (!Number.isFinite(unidadNum) || unidadNum === 0) {
    console.warn('Tema con unidad inválida (0) ignorado', t);
    return;
  }

  // Renderizar tarjeta para temas válidos
  const card = document.createElement('div');
  card.className = 'topic-card';
  const title = document.createElement('h4');
  title.textContent = (t.materia || 'Sin materia') + ' · Unidad ' + unidadNum;
  const temaEl = document.createElement('div');
  temaEl.className = 'meta';
  temaEl.textContent = t.tema;
  const errores = (typeof t.count === 'number' && t.count > 0) ? t.count : 0;
  const count = document.createElement('div');
  count.className = 'count';
  count.textContent = errores + (errores === 1 ? ' error' : ' errores');

  const actions = document.createElement('div');
  actions.style.display = 'flex';
  actions.style.gap = '8px';
  actions.style.marginTop = '8px';

  const btnPracticar = document.createElement('button');
  btnPracticar.className = 'btn primary-solid';
  btnPracticar.textContent = 'Practicar';
  btnPracticar.addEventListener('click', () => iniciarCuestionario(t.materia, unidadNum, t.tema));

  const btnCompletar = document.createElement('button');
  btnCompletar.className = 'btn crema';
  btnCompletar.textContent = 'Marcar completado';
  btnCompletar.addEventListener('click', () => marcarCompletado(t.materia, unidadNum, t.tema));

  actions.appendChild(btnPracticar);
  actions.appendChild(btnCompletar);

  card.appendChild(title);
  card.appendChild(temaEl);
  card.appendChild(count);
  card.appendChild(actions);

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
  if (!tema || tema.toString().trim() === '') {
    alert('Tema inválido. No se puede marcar como completado.');
    return;
  }

  // Mini confirm
  function showMiniConfirm(message, onYes, onNo) {
    try {
      const wrapper = document.createElement('div');
      wrapper.style.position = 'fixed';
      wrapper.style.left = '0';
      wrapper.style.top = '0';
      wrapper.style.right = '0';
      wrapper.style.bottom = '0';
      wrapper.style.display = 'flex';
      wrapper.style.alignItems = 'center';
      wrapper.style.justifyContent = 'center';
      wrapper.style.zIndex = 10000;
      wrapper.style.background = 'rgba(0,0,0,0.25)';

      const box = document.createElement('div');
      box.style.background = '#fff';
      box.style.padding = '14px';
      box.style.borderRadius = '8px';
      box.style.boxShadow = '0 8px 24px rgba(0,0,0,0.12)';
      box.style.maxWidth = '420px';
      box.style.width = '90%';
      box.style.textAlign = 'center';

      const txt = document.createElement('div');
      txt.style.marginBottom = '12px';
      txt.style.color = '#222';
      txt.textContent = message;

      const actions = document.createElement('div');
      actions.style.display = 'flex';
      actions.style.justifyContent = 'center';
      actions.style.gap = '10px';

      const btnNo = document.createElement('button');
      btnNo.className = 'btn';
      btnNo.textContent = 'No';
      btnNo.addEventListener('click', () => { try { document.body.removeChild(wrapper); } catch(e){}; if (onNo) onNo(); });

      const btnYes = document.createElement('button');
      btnYes.className = 'btn crema';
      btnYes.textContent = 'Sí, marcar';
      btnYes.addEventListener('click', () => { try { document.body.removeChild(wrapper); } catch(e){}; if (onYes) onYes(); });

      actions.appendChild(btnNo);
      actions.appendChild(btnYes);
      box.appendChild(txt);
      box.appendChild(actions);
      wrapper.appendChild(box);
      document.body.appendChild(wrapper);
    } catch (e) {
      if (confirm(message)) { if (onYes) onYes(); } else { if (onNo) onNo(); }
    }
  }

  function normalizeText(s) {
    if (!s && s !== 0) return '';
    try { return String(s).normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim(); }
    catch(e) { return String(s).toLowerCase().trim(); }
  }

  showMiniConfirm('Marcar este tema como completado eliminará los errores guardados para él. ¿Continuar?', () => {
    const normTema = normalizeText(tema);
    const normMateria = normalizeText(materia);
    const unidadNum = Number(unidad || 0);

    // localizar tarjeta
    const cards = Array.from(document.querySelectorAll('.topic-card'));
    let targetCard = null;
    for (const c of cards) {
      const temaEl = c.querySelector('.meta') ? normalizeText(c.querySelector('.meta').textContent) : '';
      const title = c.querySelector('h4') ? normalizeText(c.querySelector('h4').textContent) : '';
      const titleUnidadMatch = title.match(/unidad\s*([0-9]+)/i);
      const titleUnidad = titleUnidadMatch ? Number(titleUnidadMatch[1]) : null;

      const materiaMatch = title.indexOf(normMateria) !== -1;
      const temaMatch = temaEl === normTema || title.indexOf(normTema) !== -1;
      const unidadMatch = (unidadNum && titleUnidad === unidadNum) || (!unidadNum && (titleUnidad === null || titleUnidad === 0));

      if (temaMatch && materiaMatch && unidadMatch) { targetCard = c; break; }
    }

    let btnCompletar = null;
    if (targetCard) {
      btnCompletar = targetCard.querySelector('.btn.crema');
      if (btnCompletar) { btnCompletar.disabled = true; btnCompletar.style.opacity = '0.6'; btnCompletar.textContent = 'Marcando...'; }
    }

    const body = new URLSearchParams();
    body.append('tema', tema);
    if (idEst) body.append('usuario', idEst);

    console.log('marcarCompletado payload:', Object.fromEntries(body.entries()));

    fetch(API_MARCAR, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: body.toString()
    })
    .then(r => {
      if (!r.ok) throw new Error('HTTP ' + r.status);
      return r.json();
    })
.then(j => {
  console.log('marcarCompletado response:', j);
  if (j && j.status === 'ok') {
    const deleted = (typeof j.deleted !== 'undefined') ? Number(j.deleted) : null;

    // Si encontramos la tarjeta en el DOM, eliminarla
    if (targetCard && targetCard.parentNode) {
      targetCard.parentNode.removeChild(targetCard);
      console.log('Tarjeta eliminada del DOM (client-side). deleted:', deleted);
    } else if (typeof cargarTemas === 'function') {
      // recargar lista desde servidor si existe la función
      cargarTemas();
    } else {
      // fallback: recargar la página
      window.location.reload();
    }

    // Además: asegurar que el contador de errores para ese tema quede en 0
    // (si existe un contador global o una lista lateral, buscar y actualizar)
    try {
      // ejemplo: si hay un elemento con data-tema="Funciones" que muestra el contador
      const selector = '[data-tema="' + CSS.escape(tema) + '"] .count';
      const countEl = document.querySelector(selector);
      if (countEl) {
        countEl.textContent = '0 errores';
      }
    } catch (e) {
      // si CSS.escape no existe en navegadores antiguos, intentar búsqueda simple
      const els = Array.from(document.querySelectorAll('.count'));
      els.forEach(el => {
        const parent = el.closest('.topic-card');
        if (parent) {
          const meta = parent.querySelector('.meta');
          if (meta && meta.textContent && meta.textContent.trim() === tema.trim()) {
            el.textContent = '0 errores';
          }
        }
      });
    }

    // Mensaje al usuario
    if (deleted !== null) {
      if (deleted > 0) alert('Tema marcado como completado y errores eliminados.');
      else alert('Tema marcado como completado. Contador reiniciado (no se encontraron errores previos).');
    } else {
      alert('Tema marcado como completado. Contador reiniciado.');
    }
  } else {
    console.warn('Respuesta inesperada de MarcarCompletado:', j);
    alert('No se pudo marcar como completado. Intenta de nuevo.');
    if (btnCompletar) { btnCompletar.disabled = false; btnCompletar.style.opacity = ''; btnCompletar.textContent = 'Marcar completado'; }
  }
})

    .catch(err => {
      console.error('Error marcando completado:', err);
      alert('Error al marcar completado. Intenta de nuevo.');
      if (btnCompletar) { btnCompletar.disabled = false; btnCompletar.style.opacity = ''; btnCompletar.textContent = 'Marcar completado'; }
      if (typeof cargarTemas === 'function') cargarTemas(); else window.location.reload();
    });
  }, () => {
    // onNo: nada
  });
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
// Ejecutar al cargar la lista de temas o al cargar la página
(function normalizeCompletarButtons() {
  try {
    const botones = document.querySelectorAll('.topic-card .btn.crema, .btn.crema');
    botones.forEach(b => {
      // eliminar solo las propiedades conflictivas inline para permitir que el CSS las controle
      b.style.removeProperty('background-color');
      b.style.removeProperty('color');
      b.style.removeProperty('border-width');
      b.style.removeProperty('border-style');
      // forzar color si aún no se aplica (fallback)
      b.style.setProperty('background-color', '#9b8fe6', 'important');
      b.style.setProperty('color', '#ffffff', 'important');
    });
    console.log('normalizeCompletarButtons: botones procesados:', botones.length);
  } catch (e) {
    console.warn('normalizeCompletarButtons error', e);
  }
})();
