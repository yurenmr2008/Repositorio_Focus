<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registro</title>
<link rel="stylesheet" href="../css/registro_css.css">
<script>
function validar() {
    let c1 = document.getElementById("c1").value
    let c2 = document.getElementById("c2").value
    if (c1 !== c2) {
        alert("Las contraseÃ±as no coinciden")
        return false
    }
    return true
}
</script>
</head>

<body>

<div class="contenedor">
    <div class="tarjeta">
        <h1>Crear cuenta</h1>
        <form method="post" action="registrarUsuario.jsp" onsubmit="return validar();">

            <label>Nombre</label>
            <input type="text" name="nombre" required>

            <label>Correo</label>
            <input type="email" name="correo" required>

            <label>Contrasena</label>
            <input type="password" id="c1" name="contrasena" required>

            <label>Repetir contrasena</label>
            <input type="password" id="c2" required>

            <label>Fecha de nacimiento</label>
            <input type="date" name="fch_nac" required>

            <label>Semestre</label>
            <select name="id_sem" required>
                <option value="">Selecciona</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
            </select>

            <button type="submit">Registrar</button>
        </form>
    </div>
</div>

</body>
</html>