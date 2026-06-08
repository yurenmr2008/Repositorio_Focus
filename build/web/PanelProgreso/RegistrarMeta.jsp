<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrar Meta</title>
    <link rel="stylesheet" type="text/css" href="panelProgreso.css">
</head>
<body>
    <%
    int idEstudiante = Integer.parseInt(request.getParameter("idEstudiante"));
    
%>
    <div class="registrar-meta">
    <h2>Registrar una nueva meta</h2>
<form action="<%= request.getContextPath() %>/RegistrarMeta" method="post">
        <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>">

        <label for="nomMet">Nombre de la meta (menos de 45 caracteres):</label>
        <input type="text" id="nomMet" name="nomMet" maxlength="45" required>

        <label for="desMet">Descripción (menos de 45 caracteres):</label>
        <textarea id="desMet" name="desMet" maxlength="45" required></textarea>

        <button type="submit">Guardar meta</button>
    </form>
</div>

</body>
</html>
