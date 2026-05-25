<%-- 
    Document   : menuEventos
    Created on : 10 mar 2026, 12:40:14 p.m.
    Author     : Alumno
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="estilosCalendario.css">
        <link rel="stylesheet" href="css/estilos_general.css">
        <link rel="stylesheet" href="css/semestres.css">
        <link rel="stylesheet" href="css/calculoDiferencial.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="../css/estilos_general.css">
    </head>
    
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
        <a href="html/cuestionarios.html">Cuestionarios</a>
        <a href="#">Matemáticas interactivas</a>
        <a href="html/modoConcentracion.html"> Modo concentración</a>
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

<script>
function toggle(btn,id){
    let menu=document.getElementById(id);
    let flecha=btn.querySelector('.flecha');

    document.querySelectorAll('.sub-opciones').forEach(m=>{
        if(m.id!==id) m.style.maxHeight=null;
    });
    document.querySelectorAll('.semestre .flecha').forEach(f=>{
        if(f!==flecha) f.classList.remove('girar');
    });

    if(menu.style.maxHeight){
        menu.style.maxHeight=null;
        flecha.classList.remove('girar');
    } else {
        menu.style.maxHeight=menu.scrollHeight+'px';
        flecha.classList.add('girar');
    }
}

let parcialSeleccionado = null;
function seleccionarParcial(num){
    parcialSeleccionado = num;
    document.querySelectorAll('.btn-parcial').forEach(b=>b.classList.remove('activo'));
    document.querySelectorAll('.btn-parcial')[num-1].classList.add('activo');
}

function abrirMenu(id){
  let menu = document.getElementById(id);
  menu.style.display = (menu.style.display === "block") ? "none" : "block";
}

const modos = document.querySelectorAll('.modo');

modos.forEach(m => {
    m.addEventListener('click', () => {
        modos.forEach(b => b.classList.remove('activo'));
        m.classList.add('activo');
    });
});

function seleccionarParcial(num){
    parcialSeleccionado = num;
    
 
    document.querySelectorAll('.btn-parcial').forEach(b=>b.classList.remove('activo'));
    document.querySelectorAll('.btn-parcial')[num-1].classList.add('activo');

    
    let select = document.getElementById('tema');
    select.innerHTML = ""; 

    let opciones = [];

    if(num === 1){
        opciones = [
            "Propiedades de los números reales",
            "Funciones",
            "Límites"
        ];
    }

    if(num === 2){
        opciones = [
            "La derivada y sus interpretaciones"
        ];
    }

    if(num === 3){
        opciones = [
            "Por el momento no hay disponibles"
        ];
    }

   
    opciones.forEach(op => {
        let option = document.createElement("option");
        option.textContent = op;
        option.value = op;
        select.appendChild(option);
    });
}

</script>

    <body>


        
        
    </body>
</html>
