<%@ page import="java.util.List" %>
<%@ page import="chat.ChatDAO" %>

<%
    ChatDAO dao = new ChatDAO();
    List<String> mensajes = dao.obtenerMensajes();
    int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat entre Estudiantes</title>
    <link rel="stylesheet" type="text/css" href="chat.css">
</head>
<body>
    <div class="chat-container">
        <h2>Apoyo entre Estudiantes</h2>

        <!-- Lista de mensajes -->
        <% if(mensajes.isEmpty()) { %>
            <p>No hay mensajes aún. ¡Sé el primero en escribir!</p>
        <% } else { 
            for(String msg : mensajes) { %>
                <div class="mensaje"><%= msg %></div>
        <% }} %>

        <!-- Formulario para enviar mensaje -->
        <div class="formulario">
            <form action="ChatServlet" method="post">
                <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> <!-- id del estudiante -->
                <textarea name="contenido" rows="3" placeholder="Escribe tu mensaje..." required></textarea>
                <input class="btn-completar" type="submit"  value="Enviar Mensaje">
                <!--<button type="submit">Enviar mensaje</button> -->
            </form>
        </div>
    </div>
</body>
<script>
function actualizarMensajes() {
    fetch("Chat.jsp")
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, "text/html");
            // Extrae solo la lista de mensajes
            const nuevosMensajes = doc.querySelectorAll(".mensaje");
            const contenedorMensajes = document.querySelector(".chat-container");

            
        });
}

// Actualiza cada 3 segundos
setInterval(actualizarMensajes, 3000);
//Aqui hicimos cambios sin ayuda de chat
// Elimina los mensajes actuales y agrega los nuevos
            const mensajesActuales = contenedorMensajes.querySelectorAll(".mensaje");
            mensajesActuales.forEach(m => m.remove());
            nuevosMensajes.forEach(m => contenedorMensajes.querySelector(".formulario").before(m));
</script>


</html>

