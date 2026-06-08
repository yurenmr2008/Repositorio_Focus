<%-- 
    Document   : bienvenidaMenu
    Created on : 27 may 2026, 19:59:41
    Author     : yuren
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <link rel="stylesheet" href="../css/estilos_general.css">

    </head>
    <%
        String nombreUsuario = request.getParameter("nombreUsuario");
        System.out.println("El nombre del estudiante es:" + nombreUsuario);
        
    
    %>
    

    
    <body>
       <section class="bienvenida">
            <h1>Bienvenido de nuevo, <span id="nombreUsuario"><%= nombreUsuario %></span></h1>
            <p>Descubre lo nuevo del día</p>
       </section>    
    </body>
    
</html>
