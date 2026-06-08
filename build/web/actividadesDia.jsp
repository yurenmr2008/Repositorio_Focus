

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>

<%@ include file="/jsp/seguridad.jsp" %>

<html>
<head>
    <title>Web Site 4</title>
	<link rel="stylesheet" href="estilosTablaActividades.css">
	<script>
		function AgregarAct(){

			const template = document.querySelector("#formAct").content;
			const contenedor = document.querySelector(".principal");
                        const btnAgregar = document.querySelector("#btnAct");
                        const clone = template.cloneNode(true);
			
			contenedor.appendChild(clone);//Agregar el aside que esta dentro del template
                        btnAgregar.remove();//Borra el boton para que el usuario no pueda crear mas actividades de manera simultanea
	
		}
	</script>
	
</head>

<body>
    

    <%
        String origen = request.getParameter("origen"); //Este valor se recibe del calendarioGeneral 
        String id_dia = "";
        String id_cal = "";
        String id_est = "";
        String numMes = ""; //Se usa para que funcione el boton volver
        String year = ""; //Se usa para que funcione el boton volver
        try{
            if(origen.equals("CalendarioGeneral") || origen.equals("mesesCalendarios")){

                id_dia = request.getParameter("numero");
                id_cal = request.getParameter("calendario");
                id_est = request.getParameter("estudiante");
                numMes = request.getParameter("numMes");//Se usa para que funcione el boton volver
                year = request.getParameter("year");// Se usa para que funcione el boton volver
                
                System.out.println("Vamos");
                System.out.println(year);
                System.out.println(id_cal);
            }

        }
        catch(Exception e){
            id_dia =(String) request.getSession().getAttribute("idDia");
            id_cal =(String) request.getSession().getAttribute("idCal");
            id_est =(String) request.getSession().getAttribute("idEst"); 
            numMes = (String) request.getSession().getAttribute("numMes");//Se usa para que funcione el boton volver
            year = (String) request.getSession().getAttribute("year");// Se usa para que funcione el boton volver
        }   
    %>
    
    
    
    <main id="principal" class="principal">
        <section id="nuevasActividades" class="actividades">
            
            <form action="moduloCalendario/mesesCalendarios.jsp" method="post" >
                <input type="hidden" name="numeroMes" value="<%= numMes%>">
                <input type="hidden" name="year" value="<%= year%>">
                <input type="hidden" name="idEstudiante" value="<%= id_est %>">
                <input type="submit" name="boton" value="Volver" class="volver">
            </form>
            
            <h1>Agenda Diaria</h1>
            <table border="1" id="tablaActTitulo">
                    <tr>
                            <td style="width:345px; height: 50px;">Actividad</td>
                            <td style="width:335px; height: 50px;">Descripción</td>
                            <td style="width:220px; height: 50px;">Estado</td>
                            <td style="width:180px; height: 50px;">Prioridad</td>
                            <td style="width:240px; height: 50px;">Cambios</td>
                    </tr>
            </table>
                    <%

                    try {
                            Connection conecta;
                            PreparedStatement preparedStatement;

                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root", "n0m3l0");

                            preparedStatement = conecta.prepareStatement("SELECT Actividad.id_act, Actividad.nom_act, Actividad.des_act, Actividad.est_act, Actividad.pri_act, Actividad.pos_act FROM Estudiante INNER JOIN Calendario ON Estudiante.id_est=Calendario.id_est INNER JOIN Actividad ON Calendario.id_cal=Actividad.id_cal WHERE Actividad.id_dia='"+id_dia+"' AND Actividad.id_cal='"+id_cal+"' AND Estudiante.id_est='"+id_est+"'  ");
                            ResultSet rs = preparedStatement.executeQuery();
                            
                            

                            while(rs.next()){
                                out.println("<form action='SVModificarActividades' method='POST'>");
                                out.println("<table border='1' id='tablaAct'>");
                                out.println("<tr>");
                                out.println("<td>");
                                String nombreAct = rs.getString("nom_act");
                                out.println("<input type='text' name='nombreAct' value='"+nombreAct+"'>");
                                out.println("</td>");
                                out.println("<td>");
                                String descripcionAct = rs.getString("des_act");
                                out.println("<input type='text' name='descripcionAct' value='"+descripcionAct+"'>");
                                out.println("</td>");                            

                                String estadoAct = rs.getString("est_act");
                                String opc_1= "";
                                String opc_2= "";
                                String opc_3= "";

                                if(estadoAct.equals("Pendiente")){
                                    opc_1 = "selected";
                                } 
                                else{
                                    if(estadoAct.equals("Completada")){
                                        opc_2 = "selected";
                                    }
                                    else{
                                        if(estadoAct.equals("Pausada")){
                                            opc_3 = "selected";
                                        }
                                    }
                                }
                                out.println("<td>");
                                out.println("<select name='estadoAct' id='estadoAct'>");
                                out.println("<option value='Pendiente' "+opc_1+">Pendiente</option>");
                                out.println("<option value='Completada' "+opc_2+">Completada</option>");
                                out.println("<option value='Pausada' "+opc_3+">Pausada</option>");
                                out.println("</select>");
                                out.println("</td>");                            


                                String prioridadAct = rs.getString("pri_act");
                                opc_1= "";
                                opc_2= "";
                                opc_3= "";

                                if(prioridadAct.equals("Alta")){
                                    opc_1 = "selected";
                                } 
                                else{
                                    if(prioridadAct.equals("Media")){
                                        opc_2 = "selected";
                                    }
                                    else{
                                        if(prioridadAct.equals("Baja")){
                                            opc_3 = "selected";
                                        }
                                    }
                                }
                                out.println("<td>");
                                out.println("<select name='prioridadAct' id='prioridadAct'>");
                                out.println("<option value='Alta' "+opc_1+">Alta</option>");
                                out.println("<option value='Media' "+opc_2+">Media</option>");
                                out.println("<option value='Baja' "+opc_3+">Baja</option>");
                                out.println("</select>");
                                out.println("</td>");  
                                
                                out.println("<td>");
                                out.println("<input type='submit' name='botonSubmit' value='Guardar'>");
                                out.println("</td>");
                                
                                out.println("<td>");
                                out.println("<input type='submit' name='botonSubmit' value='Eliminar'>");
                                out.println("</td>");
                                
                                //DATOS UTILIZADOS PARA HACER LA MODIFICACION
                                int idAct = rs.getInt("id_act");
                                
                                out.println("<input type='hidden' name='idAct' value='"+idAct+"'>");
                                out.println("<input type='hidden' name='idDia' value='"+id_dia+"'>");
                                out.println("<input type='hidden' name='idEst' value='"+id_est+"'>");
                                out.println("<input type='hidden' name='idCal' value='"+id_cal+"'>");
                                //Datos necesarios para el boton volver
                                out.println("<input type='hidden' name='numMes' value='"+numMes+"'>");
                                out.println("<input type='hidden' name='year' value='"+year+"'>");
                                
                                out.println("</table>"); 
                                out.println("</form>");
                               
                            }	

                    } catch (Exception e) {
                            out.println("Error. " + e.getMessage());
                    }

                    %>
                    <table>
                    <tr id="btnAct">
                        <td colspan="5"><input type="button" value="Agregar Actividad" onClick="AgregarAct()"></td>
                    </tr>
                    </table


        </section> 


         
    </main>
                          
    <template id="formAct">
        <aside class="nuevaActividad">
        <form action="SvGuardarActividades" method="POST" >
            <table>


                <tr>
                    <p>Nombre</p>
                    
                    <input type="text" name="nombreAct">
                    
                    <p>Descripción</p>
                    <input type="text" name="descripcionAct">

                    <p>Estado</p>
                    <select name="estadoAct" id="estadoAct">
                        <option value="Pendiente">Pendiente</option>
                        <option value="Completada">Completada</option>
                        <option value="Pausada">Pausada</option>
                    </select>
                    <p>Prioridad</p>
                    <select name="prioridadAct" id="prioridadAct">
                        <option value="Alta">Alta</option>
                        <option value="Media">Media</option>
                        <option value="Baja">Baja</option>
                    </select>
                    
                    <td>
                    <input type="submit" value="guardar">
                    </td>
                    
                </tr>
                <%--//Datos necesarios para el registro--%>
                
                <input type="hidden" name="idDia" value="<%=id_dia%>">
                <input type='hidden' name='idEst' value="<%=id_est%>">
                <input type="hidden" name="idCal" value="<%=id_cal %>">
                <%--Datos necesarios para el boton volver--%>
                <input type="hidden" name="numMes" value="<%= numMes%>">
                <input type="hidden" name="year" value="<%= year%>">
                

            </table>      
        </form>      
        </aside>     

    </template>
                
                
                
</body>
</html>