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

<%@ include file="/jsp/seguridad.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="estilosCalendario.css">

        <link rel="stylesheet" href="../css/estilos_general.css">

    </head>
    
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
        
        int diaActual = fechaActual.getDate();
        System.out.println("Dia actual: " + diaActual);

        int numMesActual = fechaActual.getMonth() +1;
        System.out.println(numMesActual);
        
        
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
            conecta.close();
            st.close();
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
            conecta.close();
            preparedStatement.close();
            rs.close();
            

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
                            conecta.close();
                            preparedStatement.close();
                            rs.close();


                        } catch (Exception e) {
                                out.println("valio los pendientes");
                                out.println("Error. " + e.getMessage());
                        }

                        

	
	%>
			
			<td>
				<div>
					<form action="../actividadesDia.jsp" method="post">
						<input type="hidden" name="numero" value="<%=num_dia%>">
                                                <input type="hidden" name="nombre" value="<%=diaSemana%>"><%--No se usa este dato--%>
                                                <input type="hidden" name="calendario" value="<%=idCalendario%>">
                                                <input type="hidden" name="numMes" value="<%=numMes%>"> <%--Se usa para que funcione el boton volver--%>
                                                <input type="hidden" name="year" value="<%= year %>"> <%--Se usa para que funcione el boton volver--%>
                                                <input type="hidden" name="estudiante" value="<%=idEstudiante%>">
                                                <input type="hidden" name="origen" value="mesesCalendarios">
                                                
                                                <%
                                                    
                                                    if(num_dia == diaActual && numMesActual == numMes){
                                                        out.println("<input type='submit' class='diaActual' value='"+num_dia+"'>");				

                                                    }
                                                    else{
                                                        out.println("<input type='submit' value='"+num_dia+"'>");				

                                                    }
                                                
                                                %>
                                                
                                                
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
                    conecta.close();
                    preparedStatement.close();
                    rs.close();
                    
                } catch (Exception e) {
                        out.println("valio los pendientes");
                        out.println("Error. " + e.getMessage());
                }
	%>
                <td>
                    <div>
                        <form action="../actividadesDia.jsp" method="post">
                            <input type="hidden" name="numero" value="<%=num_dia%>">
                            <input type="hidden" name="nombre" value="<%=diaSemana%>">
                            <input type="hidden" name="calendario" value="<%=idCalendario%>">
                            <input type="hidden" name="numMes" value="<%=numMes%>"> <%--Se usa para que funcione el boton volver--%>
                            <input type="hidden" name="year" value="<%= year %>"> <%--Se usa para que funcione el boton volver--%>
                            <input type="hidden" name="estudiante" value="<%=idEstudiante%>">
                            <input type="hidden" name="origen" value="mesesCalendarios">
                            <%
                            if(num_dia == diaActual && numMesActual == numMes){
                                out.println("<input type='submit' class='diaActual' value='"+num_dia+"'>");				

                            }
                            else{
                                out.println("<input type='submit' value='"+num_dia+"'>");				

                            }			
                            %>
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
