<%-- 
    Document   : clasificacionMomentanea
    Created on : 18 abr 2026, 19:40:16
    Author     : yuren
--%>
<%-- Document : clasificacionMomentanea Created on : 18 abr 2026, 19:40:16 Author : yuren --%>



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@ page import="clasesModuloEvento.*" %>

<%@ include file="/jsp/seguridad.jsp" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP Page</title>
<link rel="stylesheet" href="infoCuestionarioEventos.css">

</head>
<body>
<%
    metodosEvento metodoEvento = new metodosEvento(); //Se inicializa la clase con los metodos del modulo Evento

    
    //Datos para los registros y consultas en la base de datos
    String materiaEvento = request.getParameter("materiaEvento");
    int parcialEvento = Integer.parseInt(request.getParameter("parcialEvento"));
    int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
    int idEvento = Integer.parseInt(request.getParameter("idEvento"));
    int numeroPreguntas = Integer.parseInt(request.getParameter("numeroPreguntas"));

    //Datos obtenidos de la respuesta a la pregunta
    int idRespuesta = Integer.parseInt(request.getParameter("idRespuesta"));
    String valorRespuesta = request.getParameter("valorRespuesta");
    int tiempoRespuesta = Integer.parseInt(request.getParameter("tiempoRespuesta"));
    int posicionPregunta = Integer.parseInt(request.getParameter("posicionPregunta"));
    
    
    int lugarClasificacionPasado = 0;
    int avanceClasificacion = 0;
    if(posicionPregunta > 1){
        lugarClasificacionPasado = Integer.parseInt(request.getParameter("lugarClasificacion"));
    }
    
    
    int puntajePregunta = Integer.parseInt(request.getParameter("puntajePregunta"));
    
    int puntajeActualEst = 0;
    int tiempoActualEst = 0;
    posicionPregunta = posicionPregunta +1;

    //Consulta del puntaje y tiempo actual del estudiante en el cuestionario
    try{
        Connection conecta;
        PreparedStatement preparedStatement;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

        preparedStatement = conecta.prepareStatement("SELECT pun_cla, tie_cla FROM Clasificacion WHERE id_est=? AND id_eve=?");
        preparedStatement.setInt(1, idEstudiante);
        preparedStatement.setInt(2, idEvento);

        ResultSet rs = preparedStatement.executeQuery();

        while(rs.next()){
            puntajeActualEst = rs.getInt("pun_cla");
            tiempoActualEst = rs.getInt("tie_cla");
            System.out.println("Datos Obtenidos:");
            System.out.println(puntajeActualEst);
            System.out.println(tiempoActualEst);
        }

        rs.close();
        preparedStatement.close();
        conecta.close();

    }catch (Exception e){
        out.println("Error. " + e.getMessage());
    }

    //Verifica que la respuesta sea correcta, para aumentar el puntaje que tiene el estudiante en el cuestionario
    System.out.println("Valor de la respuesta del estudiante:" + valorRespuesta);
    System.out.println("Puntaje de la pregunta: " + puntajePregunta);

    if(valorRespuesta.equals("Correcto")){
        puntajeActualEst = puntajeActualEst + puntajePregunta;
    }
    else{
        if(valorRespuesta.equals("Incorrecto")){
            puntajeActualEst = puntajeActualEst + 0;
        }
    }

    System.out.println("Puntaje actual: " + puntajeActualEst);

    //Le suma el tiempo que se tardo en responder el estudiante la pregunta del cuetionario al tiempo actual
    System.out.println("Tiempo de Respuesta: " + tiempoRespuesta);
    tiempoActualEst = tiempoActualEst + tiempoRespuesta;
    System.out.println("Tiempo actual de respuesta: " + tiempoActualEst);

    //Registrar en la base de datos la respuesta del Estudiante

    //INSERT INTO usuarios (id, nombre, email)
    //VALUES(1,'Juan Pérez', 'juan@email.com')
    //ON DUPLICATE KEY UPDATE
    //nombre = VALUES(nombre),email = VALUES(email);

    try{
        String nombreAct = request.getParameter("nombreAct");
        String descriptionAct = request.getParameter("descripcionAct");
        String estadoAct = request.getParameter("estadoAct");
        String prioridadAct = request.getParameter("prioridadAct");

        Connection conecta;
        PreparedStatement preparedStatement;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root" , "n0m3l0");

        preparedStatement = conecta.prepareStatement("INSERT INTO Clasificacion (id_est, id_eve, pun_cla, tie_cla) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE pun_cla = VALUES(pun_cla), tie_cla = VALUES(tie_cla)");
        preparedStatement.setInt(1, idEstudiante);
        preparedStatement.setInt(2, idEvento);
        preparedStatement.setInt(3, puntajeActualEst);
        preparedStatement.setInt(4,tiempoActualEst);

        preparedStatement.executeUpdate();

        System.out.println("Todo se ha registrado correctamente");
        System.out.println("Se cambio o registro el nuevo puntaje del estudiante");

        preparedStatement.close();
        conecta.close();

    } catch(Exception e){
        System.out.println("Error." + e.getMessage());
        System.out.println("Casi");
    }
%>

<div><h1>Posición: </h1></div>

<table>
<tr>
<th>Lugar</th>
<th>Nombre</th>
<th>Puntaje</th>
<th>Tiempo</th>
</tr>

<%
    //Despliege de los 5 estudiantes con un lugar más alto al del usuario y más próximos a este mismo en la clasificación
    int lugaresTabla = 10;

    try{
        Connection conecta;
        PreparedStatement preparedStatement;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

        preparedStatement = conecta.prepareStatement(
        "SELECT * FROM (" +
        "SELECT Estudiante.nom_est, Clasificacion.pun_cla, Clasificacion.tie_cla FROM Estudiante "+
        "INNER JOIN Clasificacion ON Estudiante.id_est = Clasificacion.id_est " +
        "INNER JOIN Evento ON Clasificacion.id_eve = Evento.id_eve " +
        "WHERE (Clasificacion.pun_cla > ? OR (pun_cla = ? AND tie_cla < ?)) AND " +
        "Evento.id_eve = ? " +
        "ORDER BY Clasificacion.pun_cla ASC, Clasificacion.tie_cla DESC LIMIT 5 " +

        ") AS subconsulta ORDER BY subconsulta.pun_cla DESC, subconsulta.tie_cla ASC;");
        preparedStatement.setInt(1, puntajeActualEst);//modificar
        preparedStatement.setInt(2, puntajeActualEst); // modificar
        preparedStatement.setInt(3, tiempoActualEst);
        preparedStatement.setInt(4, idEvento);

        ResultSet rs = preparedStatement.executeQuery();

        String nomParticipante ;
        int puntajeParticipante;
        int tiempoParticipante;
        int posicionParticipante = 0;

        PreparedStatement preparedStatement2;
        ResultSet rs2;

        while(rs.next()){
        
            lugaresTabla = lugaresTabla - 1; //Va contantdo cuantos lugares en la tabla son ocupados, el maximo es 5 en caso se encuentre 5 estudiantes con un mejor puntaje

            nomParticipante = rs.getString("nom_est");
            puntajeParticipante = rs.getInt("pun_cla");
            tiempoParticipante = rs.getInt("tie_cla");

            out.println("<tr>");

            try{
                preparedStatement2 = conecta.prepareStatement("SELECT COUNT(*) lugar_cla FROM Clasificacion WHERE pun_cla > ? OR (pun_cla = ? AND tie_cla < ?)");
                preparedStatement2.setInt(1, puntajeParticipante);
                preparedStatement2.setInt(2, puntajeParticipante);
                preparedStatement2.setInt(3, tiempoParticipante);

                rs2 = preparedStatement2.executeQuery();

                while(rs2.next()){
                    posicionParticipante = rs2.getInt("lugar_cla") + 1;
                }

                rs2.close();
                preparedStatement2.close();

            }catch (Exception e2){
                out.println("Error. " + e2.getMessage());
            }

            out.println("<td>");
            out.println(posicionParticipante);
            out.println("</td>");

            out.println("<td>");
            out.println(nomParticipante);
            out.println("</td>");

            out.println("<td>");
            out.println(puntajeParticipante);
            out.println("</td>");

            out.println("<td>");
            out.println(metodoEvento.obtenerFormatoTiempo(tiempoParticipante));
            out.println("</td>");

            out.println("</tr>");
        }

        rs.close();
        preparedStatement.close();
        conecta.close();

    }catch (Exception e){
        out.println("Error. " + e.getMessage());
    }

    //Despliegue del lugar del usuario en la clasifición
    int posicionActual = 0;
    String nombreEstudiante = "";

    lugaresTabla = lugaresTabla - 1; // Se descuenta el lugar del usuario en la tabla 

    //Consulta para obtener el nombre del usuario
    try{
        Connection conecta;
        PreparedStatement preparedStatement;
        ResultSet rs;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

        preparedStatement = conecta.prepareStatement("SELECT nom_est FROM Estudiante WHERE id_est=?");
        preparedStatement.setInt(1, idEstudiante);

        rs = preparedStatement.executeQuery();

        while(rs.next()){
            nombreEstudiante = rs.getString("nom_est");
        }

        rs.close();
        preparedStatement.close();
        conecta.close();

    }catch (Exception e){
        out.println("Error. " + e.getMessage());
    }

    //Consulta para obtener la posicion del usuario en la clasificacion
    try{
        Connection conecta;
        PreparedStatement preparedStatement;
        ResultSet rs;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

        preparedStatement = conecta.prepareStatement("SELECT COUNT(*) lugar_cla FROM Clasificacion "+
        "INNER JOIN Evento ON Clasificacion.id_eve = Evento.id_eve " +
        "WHERE (Clasificacion.pun_cla > ? OR (Clasificacion.pun_cla = ? AND Clasificacion.tie_cla < ?)) AND "+
        "Evento.id_eve = ? ;");
        preparedStatement.setInt(1, puntajeActualEst);
        preparedStatement.setInt(2, puntajeActualEst);
        preparedStatement.setInt(3, tiempoActualEst);
        preparedStatement.setInt(4, idEvento);

        rs = preparedStatement.executeQuery();

        while(rs.next()){
            posicionActual = rs.getInt("lugar_cla") + 1;
        }

        rs.close();
        preparedStatement.close();
        conecta.close();

    }catch (Exception e){
        out.println("Error. " + e.getMessage());
    }
    out.println("<tr class='filaClasificacionAlumno'>");  //se le agrega una clase para ponerle estilos mediante css

    out.println("<td>");
    out.println(posicionActual);
    out.println("</td>");

    out.println("<td>");
    out.println(nombreEstudiante); // Modificar
    out.println("</td>");

    out.println("<td>");
    out.println(puntajeActualEst);
    out.println("</td>");

    out.println("<td>");
    out.println(metodoEvento.obtenerFormatoTiempo(tiempoActualEst));
    out.println("</td>");
 
    out.println("<td>");
    avanceClasificacion = lugarClasificacionPasado - posicionActual ;
    if(lugarClasificacionPasado == 0){
        avanceClasificacion = 0;
    }
    
    if(avanceClasificacion > 0){
        out.println("<div class='textoVerde'>");
        out.println("   ▲ +" + avanceClasificacion +" posiciones" );
        out.println("</div>");
    }
    else{
        if(avanceClasificacion < 0){
            out.println("<div class='textoRojo'>");
            out.println("   ▼ " + avanceClasificacion + " posiciones");
            out.println("</div>");

        }
        else{
            if(avanceClasificacion == 0){
                out.println("<div class='textoAzul'>");
                out.println("  ▲ ▼ " + avanceClasificacion);
                out.println("</div>");
            }
        }
    }
    out.println("</td>");
    
    out.println("</tr>");

    //Despliege de los 5 estudiantes con un lugar más bajo al del usuario y más próximos a este mismo en la clasificación
    try{
        Connection conecta;
        PreparedStatement preparedStatement;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

        preparedStatement = conecta.prepareStatement(
       "SELECT Estudiante.nom_est, Clasificacion.pun_cla, Clasificacion.tie_cla FROM Estudiante " +
       "INNER JOIN Clasificacion ON Estudiante.id_est = Clasificacion.id_est " +
       "INNER JOIN Evento ON Clasificacion.id_eve = Evento.id_eve " +
       "WHERE (Clasificacion.pun_cla < ? OR (pun_cla = ? AND tie_cla > ?)) AND " +
       "Evento.id_eve = ? " +
       "ORDER BY Clasificacion.pun_cla DESC, Clasificacion.tie_cla ASC LIMIT ?;");
       // LIMIT 5

       preparedStatement.setInt(1, puntajeActualEst);
       preparedStatement.setInt(2, puntajeActualEst);
       preparedStatement.setInt(3, tiempoActualEst);
       preparedStatement.setInt(4, idEvento);
       preparedStatement.setInt(5, lugaresTabla);

        ResultSet rs = preparedStatement.executeQuery();

        String nomParticipante ;
        int puntajeParticipante;
        int tiempoParticipante;
        int posicionParticipante = 0;

        PreparedStatement preparedStatement2;
        ResultSet rs2;

        while(rs.next()){
            nomParticipante = rs.getString("nom_est");
            puntajeParticipante = rs.getInt("pun_cla");
            tiempoParticipante = rs.getInt("tie_cla");

            out.println("<tr>");

            try{
                preparedStatement2 = conecta.prepareStatement("SELECT COUNT(*) lugar_cla FROM Clasificacion WHERE pun_cla > ? OR (pun_cla = ? AND tie_cla < ?)");
                preparedStatement2.setInt(1, puntajeParticipante);
                preparedStatement2.setInt(2, puntajeParticipante);
                preparedStatement2.setInt(3, tiempoParticipante);

                rs2 = preparedStatement2.executeQuery();

                while(rs2.next()){
                    posicionParticipante = rs2.getInt("lugar_cla") + 1;
                }

                rs2.close();
                preparedStatement2.close();

            }catch (Exception e2){
                out.println("Error. " + e2.getMessage());
            }

            out.println("<td>");
            out.println(posicionParticipante);
            out.println("</td>");

            out.println("<td>");
            out.println(nomParticipante);
            out.println("</td>");

            out.println("<td>");
            out.println(puntajeParticipante);
            out.println("</td>");

            out.println("<td>");
            out.println(metodoEvento.obtenerFormatoTiempo(tiempoParticipante));
            out.println("</td>");

            out.println("</tr>");
        }

        rs.close();
        preparedStatement.close();
        conecta.close();

    }catch (Exception e){
        out.println("Error. " + e.getMessage());
    }
    

    // Registro de la respuesta del alumno de forma individual
    

    try{
        String nombreAct = request.getParameter("nombreAct");
        String descriptionAct = request.getParameter("descripcionAct");
        String estadoAct = request.getParameter("estadoAct");
        String prioridadAct = request.getParameter("prioridadAct");

        Connection conecta;
        PreparedStatement preparedStatement;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root" , "n0m3l0");

        preparedStatement = conecta.prepareStatement("INSERT INTO RespuestaAlumno (id_res, id_est, tie_RA) VALUES (?,?,?)");
        preparedStatement.setInt(1, idRespuesta);
        preparedStatement.setInt(2, idEstudiante);
        preparedStatement.setInt(3, tiempoRespuesta);
    

        preparedStatement.executeUpdate();

        System.out.println("Todo se ha registrado correctamente");
        System.out.println("Se guardo la respuesta del alumno en la base de datos");

        preparedStatement.close();
        conecta.close();

    } catch(Exception e){
        System.out.println("Error." + e.getMessage());
        System.out.println("No se logro guardar la respuesta del alumno en la base de datos");
    }








%>
</table>

<div class="D">
    <%
        if( posicionPregunta <= numeroPreguntas ){
            out.println("<form class='btn_sigPregunta' action='cuestionarioEvento.jsp' method='POST'>");
            out.println("<input type='hidden' name='materiaEvento' value='"+ materiaEvento +"'>");
            out.println("<input type='hidden' name='parcialEvento' value='"+ parcialEvento +"'>");
            out.println("<input type='hidden' name='idEstudiante' value='" +idEstudiante +"'>");
            out.println("<input type='hidden' name='posicionPregunta' value='"+ posicionPregunta +"'>");
            out.println("<input type='hidden' name='lugarClasificacion' value='"+posicionActual+"'>");

            out.println("<input type='submit' name='Siguiente Pregunta' value='Siguiente pregunta'>");
            out.println("</form>");
        }
        else{
            out.println("<form class='btn_sigPregunta' action='infoCuestionarioEvento.jsp' method='POST'>");
            out.println("<input type='hidden' name='materiaEvento' value='"+ materiaEvento +"'>");
            out.println("<input type='hidden' name='parcialEvento' value='"+ parcialEvento +"'>");
            out.println("<input type='hidden' name='idEstudiante' value='" +idEstudiante +"'>");
            out.println("<input type='hidden' name='posicionPregunta' value='"+ posicionPregunta +"'>");
            out.println("<input type='submit' name='Ver resultados' value='Ver resultados'>");
            out.println("</form>");
        }
        







    %>

</div>

</body>
</html>

