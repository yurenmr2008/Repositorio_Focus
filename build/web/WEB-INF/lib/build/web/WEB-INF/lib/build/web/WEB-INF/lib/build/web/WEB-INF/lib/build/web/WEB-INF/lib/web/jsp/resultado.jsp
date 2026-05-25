<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String score = request.getParameter("score");
    String aciertos = request.getParameter("aciertos");
    String total = request.getParameter("total");
    String materia = request.getParameter("materia");
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Resultado</title>
    <link rel="stylesheet" href="css/theme.css">
</head>

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
        
        <a href="#">Calendario</a>
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
<body>
    <div class="container">
        <div class="card">
            <div class="card-header"><h2>Resultado: <%= materia %></h2></div>
            <div class="card-body">
                <br><br>
                <p>Obtuviste <strong><%= score %>%</strong> (<%= aciertos %> de <%= total %>).</p>
                <div id="retroArea"></div>
                <div style="margin-top:12px;">
                    <br><br>
                    <a href="seleccionar.jsp" class="botonsitos">Volver a seleccionar</a>
                    
                    <a href="inicio.jsp" class="botonsitos">Inicio</a>
                </div>
            </div>
        </div>
    </div>
             
</body>
    </center>
<script>
let parcialSeleccionado = null;
let modoSeleccionado = null;


function seleccionarParcial(num){
    parcialSeleccionado = num;

    document.querySelectorAll('.btn-parcial')
        .forEach(b => b.classList.remove('activo'));
    document.querySelectorAll('.btn-parcial')[num-1]
        .classList.add('activo');

    const select = document.getElementById('tema');
    select.innerHTML = '<option value="">Selecciona un tema</option>';

    const temas = window.obtenerTemas("Calculo Integral", num);

    temas.forEach(t => {
        const option = document.createElement("option");
        option.value = t;
        option.textContent = t;
        select.appendChild(option);
    });
}


document.querySelectorAll('.modo').forEach(btn=>{
    btn.addEventListener('click', ()=>{
        document.querySelectorAll('.modo')
            .forEach(b=>b.classList.remove('activo'));
        btn.classList.add('activo');
        modoSeleccionado = btn.dataset.modo;
    });
});


document.getElementById("btnIniciar").addEventListener("click", ()=>{
    const tema = document.getElementById("tema").value;

    if(!parcialSeleccionado || !tema || !modoSeleccionado){
        alert("Selecciona parcial, tema y modalidad.");
        return;
    }

    const params = new URLSearchParams({
        materia: "Calculo Integral",
        unidad: parcialSeleccionado,
        tema,
        dificultad: "facil",
        modo: modoSeleccionado
    });

    window.location.href = "cuestionario.jsp?" + params.toString();
});


function toggle(btn,id){
    const menu=document.getElementById(id);
    const flecha=btn.querySelector('.flecha');

    document.querySelectorAll('.sub-opciones')
        .forEach(m=>{ if(m.id!==id) m.style.maxHeight=null; });

    document.querySelectorAll('.flecha')
        .forEach(f=>{ if(f!==flecha) f.classList.remove('girar'); });

    if(menu.style.maxHeight){
        menu.style.maxHeight=null;
        flecha.classList.remove('girar');
    } else {
        menu.style.maxHeight=menu.scrollHeight+'px';
        flecha.classList.add('girar');
    }
}


function abrirMenu(id){
    const menu = document.getElementById(id);
    menu.style.display = (menu.style.display === "block") ? "none" : "block";
}
</script>

</html>