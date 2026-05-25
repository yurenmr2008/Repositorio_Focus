<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <link rel="stylesheet" href="../css/iniciarSesion.css">
</head>

<body>

<div class="contenedor">
    <div class="tarjeta">
        <h1>Iniciar Sesión</h1>
        
        
        <% 
            String error = request.getParameter("error");
            if (error != null && error.equals("1")) {
        %>
            <p class="mensaje-error">Credenciales incorrectas. Intenta de nuevo.</p>
        <%
            }
        %>
        
        <form method="post" action="iniciarSesion.jsp">

            <label>Correo Electrónico</label>
            <input type="email" name="correo" required>

            <label>Contraseña</label>
            <input type="password" name="contrasena" required>

            <button type="submit">Entrar</button>
            
            <p class="link-registro">
                ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
            </p>
        </form>
    </div>
</div>

</body>
</html>