<%-- 
    Document   : infoCuestionarioEvento
    Created on : 14 may 2026, 18:58:56
    Author     : yuren
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="infoCuestionarioEvento.css">
    </head>
    <body>
        
        
        
        <% 
            
                   
        String materiaEvento = request.getParameter("materiaEvento");
        int parcialEvento = Integer.parseInt(request.getParameter("parcialEvento"));
        int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
        int posicionPregunta = Integer.parseInt(request.getParameter("posicionPregunta"));


        int puntajeActualEst = 0;
        int tiempoActualEst = 0;

            
        //Datos que se obtienen de la base de datos
        int idEvento = 0;
        int numPreguntas = 0; 
        int tiempoEvento = 0; 

        //Consulta de la información del evento en base al parcial y a la materia de este mismo
        try{
            Connection conecta;
            PreparedStatement preparedStatement;

            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

            preparedStatement = conecta.prepareStatement("SELECT id_eve, pre_eve, tie_eve FROM Evento"
            + " WHERE Evento.mat_eve=? AND Evento.par_eve=?");
            
            preparedStatement.setString(1, materiaEvento);
            preparedStatement.setInt(2, parcialEvento);

            
            
            ResultSet rs = preparedStatement.executeQuery();

            while(rs.next()){
                
                idEvento = rs.getInt("id_eve");
                numPreguntas = rs.getInt("pre_eve");
                tiempoEvento = rs.getInt("tie_eve");

                
                System.out.println("Datos Obtenidos:");
                System.out.println(numPreguntas);
                
            }	

        }catch (Exception e){
                out.println("Error. " + e.getMessage());
        }
            


        //Consulta del puntaje y tiempo actual del estudiante en el cuestionario
        try{
            Connection conecta;
            PreparedStatement preparedStatement;

            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

            preparedStatement = conecta.prepareStatement("SELECT pun_cla, tie_cla FROM Clasificacion WHERE id_est=? AND id_eve=?");
            preparedStatement.setInt(1, idEstudiante);
            preparedStatement.setInt(2, idEvento);

            ResultSet rs = preparedStatement.executeQuery();

            while(rs.next()){
                puntajeActualEst = rs.getInt("pun_cla");
                tiempoActualEst = rs.getInt("tie_cla");
                System.out.println("Datos Obtenidos:");
                System.out.println("Puntaje del estudiante: " + puntajeActualEst);
                System.out.println("Tiempo del estudiante: " + tiempoActualEst);
            }


            rs.close();
            preparedStatement.close();
            conecta.close();

        }catch (Exception e){
            out.println("Error. " + e.getMessage());


        }

        boolean eventoRealizado;

        if(puntajeActualEst == 0 & tiempoActualEst == 0){
            eventoRealizado = false;

        }
        else{
            eventoRealizado = true;
        }    

        %>
        
        
        
        
        
        
        
        <form action="seccionEventos.jsp" method="POST">
            <input type="submit" name="Atras" value="Atras">
                       
        </form>

        
        
        <% 
                
                String[] podioNombres = new String[3];
                
                int indice = 0;

                //Obtiene los 3 estudiantes con mejores resultados en la clasificación (podio)
                try{
                    Connection conecta;
                    PreparedStatement preparedStatement;

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                    preparedStatement = conecta.prepareStatement(                    
                    "SELECT Estudiante.nom_est, Clasificacion.pun_cla, Clasificacion.tie_cla FROM Estudiante "+
                    "INNER JOIN Clasificacion ON Estudiante.id_est = Clasificacion.id_est " +
                    "WHERE Clasificacion.pun_cla > ? OR (pun_cla = ? AND tie_cla < ?) " +
                    "ORDER BY Clasificacion.pun_cla DESC, Clasificacion.tie_cla ASC LIMIT 3");
                    

                    preparedStatement.setInt(1, puntajeActualEst);//modificar
                    preparedStatement.setInt(2, puntajeActualEst); // modificar
                    preparedStatement.setInt(3, tiempoActualEst);

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
                        
                        
                        podioNombres[indice] = nomParticipante;          
                        
                        indice = indice + 1;

                    }

                    rs.close();
                    preparedStatement.close();
                    conecta.close();

                }catch (Exception e){
                    out.println("Error. " + e.getMessage());
                } 
        
        
        %>
        
        
        
        
        
        
        <div class="seccionSuperior">
            <h1>Podio</h1>
            <div class="Podio">
                <div class="SegundoLugar">
                    2°
                    <br>
                    <%=podioNombres[1]%>
                </div>
                <div class="PrimerLugar">
                    1°
                    <br>
                    <%=podioNombres[0]%>
                </div>
                <div class="TercerLugar">
                    3°
                    <br>
                    <%=podioNombres[2]%>
 
                </div>
            </div>
        </div> 

        <div class="seccionInferior">
            <div class="seccionIzquierda">
            <table>
            <tr>
                <th>Lugar</th>
                <th>Nombre</th>
                <th>Puntaje</th>
                <th>Tiempo</th>
            </tr>
            <%
                    
            //######## TABLA DE CLASIFICACIÓN ########
            int lugaresTabla = 10;
            
            if(eventoRealizado == true){

                //Despliege de los 5 estudiantes con un lugar más alto al del usuario y más próximos a este mismo en la clasificación
                try{
                    Connection conecta;
                    PreparedStatement preparedStatement;

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                    preparedStatement = conecta.prepareStatement(
                    "SELECT * FROM (" +
                    
                    "SELECT Estudiante.nom_est, Clasificacion.pun_cla, Clasificacion.tie_cla FROM Estudiante "+
                    "INNER JOIN Clasificacion ON Estudiante.id_est = Clasificacion.id_est " +
                    "WHERE Clasificacion.pun_cla > ? OR (pun_cla = ? AND tie_cla < ?) " +
                    "ORDER BY Clasificacion.pun_cla ASC, Clasificacion.tie_cla DESC LIMIT 5 " +
                    
                    ") AS subconsulta ORDER BY subconsulta.pun_cla DESC, subconsulta.tie_cla ASC;");

                    preparedStatement.setInt(1, puntajeActualEst);//modificar
                    preparedStatement.setInt(2, puntajeActualEst); // modificar
                    preparedStatement.setInt(3, tiempoActualEst);

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
                        out.println(tiempoParticipante);
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
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

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
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                    preparedStatement = conecta.prepareStatement("SELECT COUNT(*) lugar_cla FROM Clasificacion WHERE pun_cla > ? OR (pun_cla = ? AND tie_cla < ?)");
                    preparedStatement.setInt(1, puntajeActualEst);
                    preparedStatement.setInt(2, puntajeActualEst);
                    preparedStatement.setInt(3, tiempoActualEst);

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
                out.println(tiempoActualEst);
                out.println("</td>");

                
                //Despliege de los 5 estudiantes con un lugar más bajo al del usuario y más próximos a este mismo en la clasificación
                
                System.out.println("Lugares restantes en la tabla:" + lugaresTabla);
                try{
                    
                    Connection conecta;
                    PreparedStatement preparedStatement;

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                    preparedStatement = conecta.prepareStatement(
                    "SELECT Estudiante.nom_est, Clasificacion.pun_cla, Clasificacion.tie_cla FROM Estudiante " +
                    "INNER JOIN Clasificacion ON Estudiante.id_est = Clasificacion.id_est " +
                    "WHERE Clasificacion.pun_cla < ? OR (pun_cla = ? AND tie_cla > ?) " +
                    "ORDER BY Clasificacion.pun_cla DESC, Clasificacion.tie_cla ASC LIMIT ?;");
                    // LIMIT 5

                    preparedStatement.setInt(1, puntajeActualEst);
                    preparedStatement.setInt(2, puntajeActualEst);
                    preparedStatement.setInt(3, tiempoActualEst);
                    preparedStatement.setInt(4, lugaresTabla);

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
                        out.println(tiempoParticipante);
                        out.println("</td>");

                        out.println("</tr>");
                    }

                    rs.close();
                    preparedStatement.close();
                    conecta.close();

                }catch (Exception e){
                    out.println("Error. " + e.getMessage());
                }    
   
            }
            else{
            
                if(eventoRealizado == false){

                    // Se despliegán los 10 estudiantes con mejor puntaje en la tabla de clasificación
                    try{
                        Connection conecta;
                        PreparedStatement preparedStatement;

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                        preparedStatement = conecta.prepareStatement(
                        "SELECT Estudiante.nom_est, Clasificacion.pun_cla, Clasificacion.tie_cla FROM Estudiante " +
                        "INNER JOIN Clasificacion ON Estudiante.id_est = Clasificacion.id_est " +
                        "ORDER BY Clasificacion.pun_cla DESC, Clasificacion.tie_cla ASC LIMIT 10;");
                        // LIMIT 10

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
                            out.println(tiempoParticipante);
                            out.println("</td>");

                            out.println("</tr>");
                        }

                        rs.close();
                        preparedStatement.close();
                        conecta.close();

                    }catch (Exception e){
                        out.println("Error. " + e.getMessage());
                    }    

                
                }
            }

            %>
            </table>
            </div>
            
       
            <div class="seccionDerecha">
                <%
                    
                //######## INFORMACIÓN O RESULTADOS ########
            
                if(eventoRealizado == true){
                    
                    
                    
                
                }
                else{
            
                    if(eventoRealizado == false){

                        out.println("<h2>Información del evento:</h2>");
                        
                        out.println(" Evento: " + materiaEvento);
                        out.println("<br>");

                        out.println("<br> Parcial: " + parcialEvento);
                        out.println("<br>");

                        out.println("<br> Número de preguntas: " + numPreguntas);
                        out.println("<br>");
                        
                        out.println("<br> Tiempo: " + tiempoEvento);
                        out.println("<br><br>");

                        out.println("<h3> Instrucciones Generales: </h3>");
                        out.println(" a. Lea cuidadosamente todo el examen antes de comenzar");
                        out.println("<br> b. No se permite la consulta de apuntes, libros, revistas, etc.");
                        out.println("<br> c. No se permite el uso de celulares o dispositivos móviles de ningún tipo");

                        out.println("<br><br>");
                        
                        out.println("<form  action='cuestionarioEvento.jsp' method='POST'>");
                        out.println("<input type='hidden' name='materiaEvento' value='" +materiaEvento + "'>");
                        out.println("<input type='hidden' name='parcialEvento' value='" +parcialEvento+ "'>");
                        out.println("<input type='hidden' name='idEstudiante' value='" +idEstudiante+ "'>");
                        out.println(" <input type='hidden' name='posicionPregunta' value='" +posicionPregunta+ "'>");
                        
                        out.println("<input type='submit' name='comenzarIntento' value='Comenzar Intento'>");
                        
                        out.println("</form>");


                    }
                }
                %>                
                
                
                
            </div>
            
            
        </div>
    </body>
</html>