<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pagina Principal</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../css/estilos_general.css">
</head>

<%@ include file="seguridad.jsp" %>

<%
    
    String nombreEstudiante = (String) session.getAttribute("nombreEstudiante");
    int idEstudiante = (int) session.getAttribute("idEstudiante");
    
    if (nombreEstudiante == null) {
       
        response.sendRedirect("iniciar.jsp");
        return; 
    }
    String nombreAMostrar = nombreEstudiante.split(" ")[0];
    
%>

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
      <!-- Reemplaza o pega este bloque en inicio.jsp dentro del nav Estudia -->
<div class="submenu" id="menuEstudia">
  <a href="../moduloCuestionarios/index.jsp" target="ventana">Cuestionarios</a>
  <a href="../moduloMatematicasInteractivas/matematicas_interactivas.jsp" target="ventana">Matemáticas interactivas</a>
  <a href="../html/modoConcentracion.html" target="ventana">Modo concentración</a>
</div>


    </div>

   <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuRecursos')">Recursos académicos</div>
      <div class="submenu" id="menuRecursos">
        <a href="../html/recursosAcademicos.html" target="ventana">Contenido de apoyo</a>
      </div>
    </div>

    <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuComunidad')">Comunidad</div>
      <div class="submenu" id="menuComunidad">
        <a href="../chat/Chat.jsp?idEstudiante=<%=idEstudiante%>" target="ventana">Apoyo entre estudiantes</a>
        <a href="../moduloEventos/seccionEventos.jsp?idEstudiante=<%=idEstudiante%>" target="ventana">Eventos</a>
      </div>
    </div>

    <div class="nav-item">
      <div class="nav-boton" onclick="abrirMenu('menuProgreso')">Mi progreso</div>
      <div class="submenu" id="menuProgreso">
        
        <a href="../moduloCalendario/CalendarioGeneral.jsp?idEstudiante=<%=idEstudiante%>" target="ventana">Calendario</a>
        <a href="../PanelProgreso/PanelProgreso.jsp?idEstudiante=<%=idEstudiante%>" target="ventana">Panel de progreso</a>
      </div>
    </div>

  </nav>

  <div class="cuenta">
    <div class="icono-cuenta" onclick="abrirMenu('menuCuenta')">U</div>
    <div class="submenu-cuenta" id="menuCuenta">
      <a href="#">Mi cuenta</a>
      <a href="#">Ayuda</a>
      <a href="../index.html">Cerrar sesión</a>
    </div>
  </div>
</header>

<main class="principal">

    <iframe src="../jsp/bienvenidaMenu.jsp?nombreUsuario=<%=nombreAMostrar%>" width="100%" height="900" frameborder="0" name="ventana"></iframe>

</main>

<script>
function abrirMenu(id){
  var menu = document.getElementById(id);
  if(menu.style.display==='block'){
    menu.style.display='none';
  } else {
    menu.style.display='block';
  }
}

</script>

</body>
</html>