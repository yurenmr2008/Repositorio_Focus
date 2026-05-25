<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Cálculo Integral</title>

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
<div class="contenedor-semestres">

     <aside class="sidebar">
        <div class="semestre disabled"><h3>I Semestre</h3></div>
        <div class="sub-opciones disabled"></div>

        <div class="semestre disabled"><h3>II Semestre</h3></div>
        <div class="sub-opciones disabled"></div>

        <div class="semestre disabled"><h3>III Semestre</h3></div>
        <div class="sub-opciones disabled"></div>

        <div class="semestre disabled">
            <h3> IV Semestre</h3>
        </div>
        <div class="sub-opciones disabled"></div>
        <!-- 
        <div class="semestre" onclick="toggle(this,'s4')">
            <h3>IV Semestre</h3>
            <span class="flecha">▾</span>
        </div>
        <div class="sub-opciones" id="s4">
            <a href="calculoDiferencial.html">Calculo Diferencial</a>
            <a href="#">Fisica III</a>
            <a href="#">Quimica III</a>
            <a href="#">Dibujo Tecnico II</a>
             <a href="#">Ingles IV </a>
        </div>
-->

        <div class="semestre" onclick="toggle(this,'s5')">
            <h3>V Semestre</h3>
            <span class="flecha">▾</span>
        </div>
        <div class="sub-opciones" id="s5">
            <a href="seleccionar.jsp">Calculo Integral</a>
            <a href="#">Fisica IV</a>
            <a href="#">Quimica IV</a>
            <a href="#">Orientacion III</a>
            <a href="#">Ingles V</a>
        </div>

        <div class="semestre disabled"><h3>VI Semestre</h3></div>
        <div class="sub-opciones disabled"></div>
    </aside>

    <main class="content-main">

        <div class="card">
            <h1>Cálculo Integral</h1>
            <h2>Selecciona tu cuestionario</h2>

            <div class="parciales">
                <button class="btn-parcial" onclick="seleccionarParcial(1)">Primer parcial</button>
                <button class="btn-parcial" onclick="seleccionarParcial(2)">Segundo parcial</button>
                <button class="btn-parcial" onclick="seleccionarParcial(3)">Tercer parcial</button>
            </div>

            <select id="tema" class="select-tema">
                <option value="">Selecciona un tema</option>
            </select>

            <h3>Elige tu modalidad</h3>
            <br>

            <div class="modos">
                <button class="modo" data-modo="retroalimentacion">Retroalimentación</button>
                <button class="modo" data-modo="contrarreloj">Contra reloj</button>
                <button class="modo" data-modo="practica">Práctica</button>
            </div>

            <button class="iniciar" id="btnIniciar">Iniciar</button>
        </div>

    </main>

</div>
<script src="../js/preguntas.js"></script>


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








</body>
</html>
