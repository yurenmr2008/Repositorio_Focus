<%-- 
    Document   : mesesCalendarios
    Created on : 7 dic 2025, 08:53:47
    Author     : yuren
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="estilosCalendario.css">
<link rel="stylesheet" href="css/estilos_general.css">
<link rel="stylesheet" href="css/semestres.css">
<link rel="stylesheet" href="css/calculoDiferencial.css">

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
    <% 
        
        String idEstudiante = request.getParameter("idEstudiante");
        int year = Integer.parseInt(request.getParameter("year"));
        int numMes = Integer.parseInt( request.getParameter("numeroMes"));
        String boton = request.getParameter("boton");
        
        if(boton.equals("siguiente")){
            numMes = numMes + 1;
            if (numMes > 12){
                numMes = 1;
                year = year + 1;
            }
        }
        else{
            if(boton.equals("anterior")){
                numMes = numMes - 1;
                if (numMes < 1){
                    numMes = 12;
                    year = year - 1;        
                }
            }
            else{
                if(boton.equals("volver")){
                    System.out.println("Volvio al mismo calendario");
                    numMes = numMes;
                }
                
            }
        }
        
        //NOTAS:
        //* se tiene que obtner el id del estudiante desde que inicia sesion al sistema
        //* se tiene que crear el calendario del estudiante desde que crea un cuenta por primera vez junto con el estudiante
        
        Date fechaActual = new Date();
        String [] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        String nomMes = meses[numMes-1];
        
        int [] diasPorMes = {31,28,31,30,31,30,31,31,30,31,30,31};
        int diasDelMes = diasPorMes[numMes-1];
        
        int idCalendario = 0;
        
        
        try{
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root" , "n0m3l0");


            st = conecta.prepareStatement("INSERT INTO Calendario(id_est, mes_cal, año_cal)  SELECT ?,?,?  WHERE NOT EXISTS(SELECT 1 FROM Calendario WHERE id_est=? AND mes_cal=? AND año_cal =?);");
            
            st.setString(1,idEstudiante);
            st.setInt(2,numMes);
            st.setInt(3,year);
            st.setString(4,idEstudiante);
            st.setInt(5,numMes);
            st.setInt(6,year);

            st.executeUpdate();
            System.out.println("Se creo sin ningun problema");
            
        }           
        catch(Exception e){
            System.out.println("Error." + e.getMessage());
            System.out.println("Casi");
        }
        
  
        try{


            Connection conecta;
            PreparedStatement preparedStatement;

            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

            preparedStatement = conecta.prepareStatement("SELECT id_cal FROM Calendario WHERE id_est='"+idEstudiante+"' AND mes_cal='"+numMes+"' AND año_cal = '"+year+"'");
            
            ResultSet rs = preparedStatement.executeQuery();

            while(rs.next()){
                idCalendario = rs.getInt("id_cal");
                System.out.println(idCalendario);
                
            }	

        }catch (Exception e){
                out.println("Error. " + e.getMessage());
        }

    
    %>
    <form action="mesesCalendarios.jsp" method="post">
        <input type="hidden" name="numeroMes" value="<%= numMes%>">
        <input type="hidden" name="idEstudiante" value="<%= idEstudiante%>">
        <input type="hidden" name="year" value="<%= year%>">
        <input type="submit" name="boton" value="anterior">
    </form>
        
        
    <form action="mesesCalendarios.jsp" method="post">
        <input type="hidden" name="numeroMes" value="<%= numMes%>">
        <input type="hidden" name="idEstudiante" value="<%= idEstudiante%>">
        <input type="hidden" name="year" value="<%= year%>">
        <input type="submit"  name="boton" value="siguiente">
    </form>
        
        <h1>Calendario <%= nomMes %> <%=year%></h1>

        <table>
	<%		
	int num_dia = 0;
	for (int i=1; i<=4; i++){
	%>	
	
	<tr>
	
	<%	
		for (int j=1 ; j<=7; j++)
		{
			num_dia = num_dia + 1;
			String diaSemana = "ninguno";
			switch(j){
				case 1:
					diaSemana = "Lunes";
					break; 
				case 2:
					diaSemana = "Martes";
					break;
				case 3:
					diaSemana = "Miercoles";
					break;
				case 4:
					diaSemana = "Jueves";
					break;
				case 5:
					diaSemana = "Viernes";
					break;
				case 6:
					diaSemana = "Sabado";
					break;
				case 7:
					diaSemana = "Domingo";
					break;
			}
                    
                        // Se extraen las actividades pendientes por dia de la base de datos
                        int actPendientes = 0;
                        int actCompletadas = 0;

                        try {

                            Connection conecta;
                            PreparedStatement preparedStatement;

                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                            preparedStatement = conecta.prepareStatement("SELECT Actividad.est_act FROM Estudiante "
                            + "INNER JOIN Calendario ON Estudiante.id_est=Calendario.id_est INNER JOIN Actividad ON Calendario.id_cal=Actividad.id_cal "
                            + "WHERE Actividad.id_dia='"+num_dia+"' AND Calendario.id_cal='"+idCalendario+"'");
                            
                            ResultSet rs = preparedStatement.executeQuery();
                            
                            
                            while(rs.next()){
                                String actEstado = rs.getString("est_act");
                                
                                if(actEstado.equals("Completada")){
                                    actCompletadas = actCompletadas + 1;
                                }
                                else{
                                    if(actEstado.equals("Pendiente")){
                                        actPendientes = actPendientes + 1;
                                    }
                                }
            
                            
                            }	

                        } catch (Exception e) {
                                out.println("valio los pendientes");
                                out.println("Error. " + e.getMessage());
                        }

                        

	
	%>
			
			<td>
				<div>
					<form action="actividadesDia.jsp" method="post">
						<input type="hidden" name="numero" value="<%=num_dia%>">
                                                <input type="hidden" name="nombre" value="<%=diaSemana%>"><%--No se usa este dato--%>
                                                <input type="hidden" name="calendario" value="<%=idCalendario%>">
                                                <input type="hidden" name="numMes" value="<%=numMes%>"> <%--Se usa para que funcione el boton volver--%>
                                                <input type="hidden" name="year" value="<%= year %>"> <%--Se usa para que funcione el boton volver--%>
                                                <input type="hidden" name="estudiante" value="<%=idEstudiante%>">
                                                <input type="hidden" name="origen" value="mesesCalendarios">
                                                
						<input type="submit" value="<%=num_dia%>">				
					</form>
                                        <br>
                                        Pendientes: <%=actPendientes%>
                                        <br>
                                        Completadas: <%=actCompletadas%>
				</div>
			</td>
	<%
            System.out.println("se envia" + idCalendario);
		}	
	%>
	
	</tr>	

	<%
	}
	%>
	
	<tr>
	
<%	
        for (int j=1 ; j<=3; j++)
        {

            num_dia = num_dia + 1;

            if(num_dia <= diasDelMes){


                String diaSemana = "ninguno";
                switch(j){
                        case 1:
                                diaSemana = "Lunes";
                                break; 
                        case 2:
                                diaSemana = "Martes";
                                break;
                        case 3:
                                diaSemana = "Miercoles";
                                break;
                        case 4:
                                diaSemana = "Jueves";
                                break;
                        case 5:
                                diaSemana = "Viernes";
                                break;
                        case 6:
                                diaSemana = "Sabado";
                                break;
                        case 7:
                                diaSemana = "Domingo";
                                break;
                }

                // Se extraen las actividades pendientes por dia de la base de datos
                int actPendientes = 0;
                int actCompletadas = 0;

                try {

                    Connection conecta;
                    PreparedStatement preparedStatement;

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                    preparedStatement = conecta.prepareStatement("SELECT Actividad.est_act FROM Estudiante "

                    + "INNER JOIN Calendario ON Estudiante.id_est=Calendario.id_est INNER JOIN Actividad ON Calendario.id_cal=Actividad.id_cal "
                    + "WHERE Actividad.id_dia='"+num_dia+"' AND Calendario.id_cal='"+idCalendario+"'");

                    ResultSet rs = preparedStatement.executeQuery();


                    while(rs.next()){
                        String actEstado = rs.getString("est_act");

                        if(actEstado.equals("Completada")){
                            actCompletadas = actCompletadas + 1;
                        }
                        else{
                            if(actEstado.equals("Pendiente")){
                                actPendientes = actPendientes + 1;
                            }
                        }

                    }	

                } catch (Exception e) {
                        out.println("valio los pendientes");
                        out.println("Error. " + e.getMessage());
                }
	%>
                <td>
                    <div>
                        <form action="actividadesDia.jsp" method="post">
                            <input type="hidden" name="numero" value="<%=num_dia%>">
                            <input type="hidden" name="nombre" value="<%=diaSemana%>">
                            <input type="hidden" name="calendario" value="<%=idCalendario%>">
                            <input type="hidden" name="numMes" value="<%=numMes%>"> <%--Se usa para que funcione el boton volver--%>
                            <input type="hidden" name="year" value="<%= year %>"> <%--Se usa para que funcione el boton volver--%>
                            <input type="hidden" name="estudiante" value="<%=idEstudiante%>">
                            <input type="hidden" name="origen" value="mesesCalendarios">

                            <input type="submit" value="<%=num_dia%>">				
                        </form>

                        <br>
                        Pendientes: <%=actPendientes%>
                        <br>
                        Completadas: <%=actCompletadas%>
                    </div>
                </td>
	<%
            }
        }	
	%>
	</tr>

	</table>
	

	
	
    </body>
</html>
