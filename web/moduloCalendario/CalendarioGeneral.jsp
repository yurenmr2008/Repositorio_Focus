
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>

<%@ include file="/jsp/seguridad.jsp" %>

<html>
<head>
<link rel="stylesheet" href="estilosCalendario.css">

<link rel="stylesheet" href="../css/estilos_general.css">
</head>


<body>
    <% 
        //NOTAS:
        //* se tiene que obtner el id del estudiante desde que inicia sesion al sistema
        //* se tiene que crear el calendario del estudiante desde que crea un cuenta por primera vez junto con el estudiante
        
        Date fechaActual = new Date();
        String [] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        String nomMesActual = meses[fechaActual.getMonth()];
       
        int diaActual = fechaActual.getDate();
        System.out.println("Dia actual: " + diaActual);

        
        int numMesActual = fechaActual.getMonth() +1;
        System.out.println(nomMesActual);
        
        int yearActual = fechaActual.getYear() + 1900;
        System.out.println(yearActual);
        
        int [] diasPorMes = {31,28,31,30,31,30,31,31,30,31,30,31};
        int diasDelMes = diasPorMes[numMesActual-1];
       
        
        int idCalendario = 0;
        
        String idEstudiante = request.getParameter("idEstudiante");
        System.out.println("El id del estudiante es:" + idEstudiante);
        
        try{
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root" , "n0m3l0");


            st = conecta.prepareStatement("INSERT INTO Calendario(id_est, mes_cal, año_cal)  SELECT ?,?,?  WHERE NOT EXISTS(SELECT 1 FROM Calendario WHERE id_est=? AND mes_cal=? AND año_cal =?);");
            
            st.setString(1,idEstudiante);
            st.setInt(2,numMesActual);
            st.setInt(3,yearActual);
            st.setString(4,idEstudiante);
            st.setInt(5,numMesActual);
            st.setInt(6,yearActual);

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
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

            preparedStatement = conecta.prepareStatement("SELECT id_cal FROM Calendario WHERE id_est='"+idEstudiante+"' AND mes_cal='"+numMesActual+"' AND año_cal = '"+yearActual+"' ");
            
            ResultSet rs = preparedStatement.executeQuery();

            while(rs.next()){
                idCalendario = rs.getInt("id_cal");
                System.out.println( idCalendario);
                
            }	
            
            conecta.close();
            preparedStatement.close();
            rs.close();

        }catch (Exception e){
                out.println("Error. " + e.getMessage());
        }

    
    %>
    
    <form action="mesesCalendarios.jsp" method="post">
        <input type="hidden" name="numeroMes" value="<%= numMesActual%>">
        <input type="hidden" name="idEstudiante" value="<%= idEstudiante%>">
        <input type="hidden" name="year" value="<%= yearActual%>">
        <input type="submit" name="boton" value="anterior">
    </form>
    
    <form action="mesesCalendarios.jsp" method="post">
        <input type="hidden" name="numeroMes" value="<%= numMesActual%>">
        <input type="hidden" name="idEstudiante" value="<%= idEstudiante%>">
        <input type="hidden" name="year" value="<%= yearActual%>">
        <input type="submit"  name="boton" value="siguiente">
    </form>
        
        
	<h1>Calendario <%= nomMesActual %> <%= yearActual%></h1>
	<table border="1">

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
                            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

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
                                                <input type="hidden" name="numMes" value="<%=numMesActual%>"> <%--Se usa para que funcione el boton volver--%>
                                                <input type="hidden" name="year" value="<%= yearActual %>"> <%--Se usa para que funcione el boton volver--%>
                                                <input type="hidden" name="estudiante" value="<%=idEstudiante%>">
                                                <input type="hidden" name="origen" value="CalendarioGeneral">
                                                
                                                <%
                                                    
                                                    if(num_dia == diaActual && numMesActual == numMesActual){
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
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

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
                        out.println("registro encontrado");

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
                            <input type="hidden" name="numMes" value="<%=numMesActual%>"> <%--Se usa para que funcione el boton volver--%>
                            <input type="hidden" name="year" value="<%= yearActual %>"> <%--Se usa para que funcione el boton volver--%>
                            <input type="hidden" name="estudiante" value="<%=idEstudiante%>">
                            <input type="hidden" name="origen" value="CalendarioGeneral">

                            <%

                                if(num_dia == diaActual && numMesActual == numMesActual){
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