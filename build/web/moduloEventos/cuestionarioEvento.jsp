  <%-- 
    Document   : cuestionarioEvento
    Created on : 11 abr 2026, 18:44:08
    Author     : yuren
--%>

<%@page import="java.util.Collections"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>

<%@ include file="/jsp/seguridad.jsp" %>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="estilosCuestionario.css">

        <title>JSP Page</title>
    </head>
    <body>
        
        <%-- Pregunta --%>
<%
        
    
        //Datos para los registros y consultas en la base de datos

        String materiaEvento = request.getParameter("materiaEvento");
        int parcialEvento = Integer.parseInt(request.getParameter("parcialEvento"));
        int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
        int posicionPregunta = Integer.parseInt(request.getParameter("posicionPregunta"));
        
        int lugarClasificacion = 0;
        if(posicionPregunta > 1){
            lugarClasificacion = Integer.parseInt(request.getParameter("lugarClasificacion"));

        }
        



        
        //Datos que se obtienen de la base de datos
        int idEvento = 0;

        int numPreguntas = 0; 
        int idPregunta = 0; 

        int puntajePregunta = 0;
        int tiempoEvento = 0; 
        String textoPregunta = ""; 
        int [] idRespuestas = new int[4];
        String[] respuestas = new String[4];

        String[] valoresRespuestas = new String[4]; //Dentro de este arreglo se guardaran los valores cada una de las respuestas, los cuales pueden ser correcto o incorrecto 
        
        
        
        
        try{
            Connection conecta;
            PreparedStatement preparedStatement;

            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

            preparedStatement = conecta.prepareStatement("SELECT Evento.id_eve, Evento.pre_eve, Evento.tie_eve, Pregunta.id_pre, Pregunta.tex_pre, Pregunta.pun_pre FROM Evento INNER JOIN Pregunta ON Evento.id_eve = Pregunta.id_eve"
            + " WHERE Evento.mat_eve=? AND Evento.par_eve=? AND Pregunta.pos_pre=?");
            
            preparedStatement.setString(1, materiaEvento);
            preparedStatement.setInt(2, parcialEvento);
            preparedStatement.setInt(3, posicionPregunta);
            
            
            ResultSet rs = preparedStatement.executeQuery();

            while(rs.next()){
                
                idEvento = rs.getInt("id_eve");
                numPreguntas = rs.getInt("pre_eve");
                tiempoEvento = rs.getInt("tie_eve");
                idPregunta = rs.getInt("id_pre");
                textoPregunta = rs.getString("tex_pre");
                puntajePregunta = rs.getInt("pun_pre");
                
                System.out.println("Datos Obtenidos:");
                
                System.out.println(numPreguntas);
                System.out.println(textoPregunta);
                
            }	

        }catch (Exception e){
                out.println("Error. " + e.getMessage());
        }
        

        
        
        //Consulta de las respuestas de la pregunta
        try{
            Connection conecta;
            PreparedStatement preparedStatement;

            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/Focus", "root", "n0m3l0");

            preparedStatement = conecta.prepareStatement("SELECT Respuesta.id_res, Respuesta.tex_res, Respuesta.val_res FROM Evento INNER JOIN Pregunta ON Evento.id_eve = Pregunta.id_eve INNER JOIN Respuesta ON Pregunta.id_pre = Respuesta.id_pre "
            + "WHERE Respuesta.id_pre=? ");
            
            preparedStatement.setInt(1, idPregunta);
            
            ResultSet rs = preparedStatement.executeQuery();
            
            int indiceLista = 0;
            
            ArrayList<Integer> indiceRandom = new ArrayList<>();
            indiceRandom.add(0);
            indiceRandom.add(1);
            indiceRandom.add(2);
            indiceRandom.add(3);
            
            Collections.shuffle(indiceRandom);//Este metodo ordena de manera aleatoria los elementos de una lista
            System.out.println(indiceRandom);
            while(rs.next()){
                
                System.out.println(indiceRandom.get(indiceLista));
                System.out.println(rs.getInt("id_res"));
                System.out.println(rs.getString("tex_res"));
                
                idRespuestas[indiceRandom.get(indiceLista)] = rs.getInt("id_res");
                respuestas[indiceRandom.get(indiceLista)] = rs.getString("tex_res");
                valoresRespuestas[indiceRandom.get(indiceLista)] = rs.getString("val_res");
                indiceLista = indiceLista + 1;
                    
            }	
            
            
           

        }catch (Exception e){
                out.println("Error. " + e.getMessage());
        }

%>

        
        
        <div class="pregunta">
            
            <h2><%= textoPregunta%></h2>
            
        </div>
        
        <%-- Respuestas --%>
        
        <div class="respuestas">
            
            <div class="respuesta opcion1 ">
                <h4><%= respuestas[0]%></h4>           
            </div>

            <div class="respuesta opcion2">
                <h4><%= respuestas[1]%></h4>
            </div>
                    
            <div class="respuesta opcion3">
                <h4><%= respuestas[2]%></h4>  
            </div>
            
            <div class="respuesta opcion4">
                <h4><%= respuestas[3]%></h4>
            </div>                                
                
        </div>
                    
                    
            <div class="seccionContinuar">
                <form style="display: none;"  class="btn_continuar1"  action="clasificacionActual.jsp" method="POST">

                    <%--Datos obtenidos de la respuesta a la pregunta--%>


                    <input type="hidden" name="idRespuesta" value="<%= idRespuestas[0]%>"> 
                    <input type="hidden" name="valorRespuesta" class="valorRes1" value="<%= valoresRespuestas[0]%>">
                    <input type="hidden" name="tiempoRespuesta" class="tiempoRespuesta1" value="">
                    <input type="hidden" name="posicionPregunta"  value="<%=posicionPregunta%>">
                    <input type="hidden" name="puntajePregunta"  value="<%=puntajePregunta%>">
                    <input type="hidden" name="lugarClasificacion" value="<%=lugarClasificacion%>">
 


                    <%--Datos para los registros y consultas en la base de datos--%>
                    <input type="hidden" name="materiaEvento" value="<%=materiaEvento%>">
                    <input type="hidden" name="parcialEvento" value="<%=parcialEvento%>">
                    <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
                    <input type="hidden" name="idEvento" value="<%=idEvento%>">
                    <input type="hidden" name="numeroPreguntas" value="<%=numPreguntas%>">




                    <input type="submit" name="Continuar" value="Continuar">
                </form>
            </div>
                
            <div class="seccionContinuar">
                <form style="display: none;" class="btn_continuar2" action="clasificacionActual.jsp" method="POST">

                    <%--Datos obtenidos de la respuesta a la pregunta--%>

                    <input type="hidden" name="idRespuesta" value="<%= idRespuestas[1]%>"> 
                    <input type="hidden" name="valorRespuesta" class="valorRes2" value="<%= valoresRespuestas[1]%>">
                    <input type="hidden" name="tiempoRespuesta" class="tiempoRespuesta2" value="">
                    <input type="hidden" name="posicionPregunta"  value="<%=posicionPregunta%>">
                    <input type="hidden" name="puntajePregunta"  value="<%=puntajePregunta%>">
                    <input type="hidden" name="lugarClasificacion" value="<%=lugarClasificacion%>">


                    <%--Datos para los registros y consultas en la base de datos--%>
                    <input type="hidden" name="materiaEvento" value="<%=materiaEvento%>">
                    <input type="hidden" name="parcialEvento" value="<%=parcialEvento%>">
                    <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
                    <input type="hidden" name="idEvento" value="<%=idEvento%>">
                    <input type="hidden" name="numeroPreguntas" value="<%=numPreguntas%>">



                    <input type="submit" name="Continuar" value="Continuar">
                </form>   
            </div>
                
            <div class="seccionContinuar">
                <form style="display: none;" class="btn_continuar3" action="clasificacionActual.jsp" method="POST"> 

                    <%--Datos obtenidos de la respuesta a la pregunta--%>

                    <input type="hidden" name="idRespuesta" value="<%= idRespuestas[2]%>"> 
                    <input type="hidden" name="valorRespuesta" class="valorRes3" value="<%= valoresRespuestas[2]%>">
                    <input type="hidden" name="tiempoRespuesta" class="tiempoRespuesta3" value="">
                    <input type="hidden" name="posicionPregunta"  value="<%=posicionPregunta%>">
                    <input type="hidden" name="puntajePregunta"  value="<%=puntajePregunta%>">
                    <input type="hidden" name="lugarClasificacion" value="<%=lugarClasificacion%>">


                    <%--Datos para los registros y consultas en la base de datos--%>
                    <input type="hidden" name="materiaEvento" value="<%=materiaEvento%>">
                    <input type="hidden" name="parcialEvento" value="<%=parcialEvento%>">
                    <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
                    <input type="hidden" name="idEvento" value="<%=idEvento%>">
                    <input type="hidden" name="numeroPreguntas" value="<%=numPreguntas%>">


                    <input type="submit" name="Continuar" value="Continuar">
                </form>
            </div>
                    
            <div class="seccionContinuar">
                <form style="display: none;" class="btn_continuar4"  action="clasificacionActual.jsp" method="POST">
                    
                    <%--Datos obtenidos de la respuesta a la pregunta--%>
                    <input type="hidden" name="idRespuesta" value="<%= idRespuestas[3]%>"> 
                    <input type="hidden" name="valorRespuesta" class="valorRes4" value="<%= valoresRespuestas[3]%>">
                    <input type="hidden" name="tiempoRespuesta" class="tiempoRespuesta4" value="">
                    <input type="hidden" name="posicionPregunta"  value="<%=posicionPregunta%>">
                    <input type="hidden" name="puntajePregunta"  value="<%=puntajePregunta%>">
                    <input type="hidden" name="lugarClasificacion" value="<%=lugarClasificacion%>">

                    
                    <%--Datos para los registros y consultas en la base de datos--%>
                    <input type="hidden" name="materiaEvento" value="<%=materiaEvento%>">
                    <input type="hidden" name="parcialEvento" value="<%=parcialEvento%>">
                    <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">
                    <input type="hidden" name="idEvento" value="<%=idEvento%>">
                    <input type="hidden" name="numeroPreguntas" value="<%=numPreguntas%>">


                    <input type="submit" name="Continuar" value="Continuar">
                </form>  
            </div>

        <script src="js_cuestionarioEvento.js"></script>

        
    </body>
</html>
