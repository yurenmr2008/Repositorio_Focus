<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>



<%
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
  <title>Focus • Matemáticas - Cuestionarios</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/moduloCuestionarios/css/theme.css?v=1.2">
</head>
<body>
  <div class="container" style="padding-top:22px">
    <div class="hero" role="region" aria-label="Bienvenida">
      <div class="hero-left">
        <h2 class="hero-title">Practica con calma</h2>
        <p class="hero-sub">Sesiones con temporizador y retroalimentación para mejorar paso a paso.</p>
        <div class="hero-cta">
          <a class="btn primary-solid positioned" href="${pageContext.request.contextPath}/moduloCuestionarios/seleccionar.jsp">Iniciar práctica</a>
          <a class="btn secondary-solid positioned" href="${pageContext.request.contextPath}/moduloCuestionarios/perfil.jsp">Mi avance</a>
        </div>
      </div>
      <div class="hero-illustration" aria-hidden="true">
        <img src="${pageContext.request.contextPath}/moduloCuestionarios/images/hero-study.png" alt="Ilustración estudio" style="width:92%;height:auto;border-radius:8px;box-shadow:0 8px 20px rgba(0,0,0,0.06)">
      </div>
    </div>

    <div style="height:18px"></div>

    <div class="dashboard">
      <div class="sidebar card">
        <div style="display:flex;align-items:center;gap:12px;margin-bottom:8px">
          <div style="width:48px;height:48px;border-radius:10px;background:var(--lavanda);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700">F</div>
          <div>
            <h2>Materias</h2>
            <div class="hint">Elige una materia para comenzar</div>
          </div>
        </div>

        <ul class="sidebar-menu">
          <li><a class="active-item">Cálculo Diferencial</a></li>
          <li><a>Cálculo Integral</a></li>
        </ul>
      </div>

      <main class="card card-body main-content">
        <h2 style="font-family:'Quicksand',sans-serif;margin-top:0">Tu espacio de práctica</h2>
        <p class="hint">Selecciona <strong>Iniciar práctica</strong> para elegir materia, unidad y modo.</p>

        <div style="margin-top:18px;display:flex;gap:12px;flex-wrap:wrap">
          <a class="btn primary-solid positioned" href="${pageContext.request.contextPath}/moduloCuestionarios/seleccionar.jsp">Iniciar práctica</a>
          <a class="btn ghost positioned" href="${pageContext.request.contextPath}/moduloCuestionarios/perfil.jsp">Mi avance</a>
        </div>
      </main>
    </div>
  </div>

<script>
  // ripple effect for buttons (keeps existing behavior)
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
