<%-- 
    Document   : seccionEventos
    Created on : 8 abr 2026, 10:34:43
    Author     : yuren
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ include file="/jsp/seguridad.jsp" %>

<!DOCTYPE html>

<html>
    
    
    <head>
        <title>TODO supply a title</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link rel="stylesheet" href="estilosCarrusel.css">
        <script>
            function aviso()
            {
                alert("Contenido no disponible por el momento")
                
            }
            
            
        </script>
    </head>
    <body>
    <%
        String idEstudiante = request.getParameter("idEstudiante");
        System.out.println("El id del estudiante es:" + idEstudiante);
    
    %>  

        
    <div class="carrousel">
        <h1 class="titulo-eventos">Eventos</h1>
        
        
        <div class="contenedorBotonesCarrusel">

            <button class="btn_carrusel btn_anterior">◀</button>
            <button class="btn_carrusel btn_siguiente">▶</button>

            
            <div class="grande">
                <div class="contenedorEvento tarjeta-evento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoIntegral.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Lunes 2 de agosto 2026 </h3>

                        <h1>Calculo Integral</h1>
                        <h2>Primer parcial</h2> 
                        <form action="infoCuestionarioEvento.jsp" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="1">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar">
                        </form>

                    </div>
                </div>


                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoQuimicaIV.jpeg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 4 de agosto 2026 </h3>

                        <h1>Química IV</h1>
                        <h2>Primer parcial</h2>
                        
                        <form action="" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="QuimicaIV">
                            <input type="hidden" name="parcialEvento" value="1">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar" onClick="aviso()">
                        </form>
                    </div>

                </div>


                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoFisicaIV.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Jueves 5 de agosto 2026 </h3>

                        <h1>Fisica IV</h1>
                        <h2>Primer parcial</h2>
                        
                        <form action="" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="1">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar" onClick="aviso()">
                        </form>
                    </div>

                </div>

                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoIntegral.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Martes 27 de noviembre 2026 </h3>

                        <h1>Calculo Integral</h1>
                        <h2>Segundo parcial</h2>

                        <form action="infoCuestionarioEvento.jsp" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="2">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar">
                        </form>
                    </div>
                </div>

                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoQuimicaIV.jpeg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 28 de noviembre 2026 </h3>

                        <h1>Química IV</h1>
                        <h2>Segundo parcial</h2>
                        
                        <form action="" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="1">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar" onClick="aviso()">
                        </form>
                    </div>

                </div>

                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoFisicaIV.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Jueves 29 de noviembre 2026 </h3>

                        <h1>Fisica IV</h1>
                        <h2>Segundo parcial</h2>
                        
                        <form action="" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="1">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar" onClick="aviso()">
                        </form>

                    </div>

                </div>




                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoIntegral.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Lunes 11 de enero 2027 </h3>

                        <h1>Calculo Integral</h1>
                        <h2>Tercer parcial</h2>

                        <form action="infoCuestionarioEvento.jsp" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="3">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar">
                        </form>
                    </div>
                </div>


                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoQuimicaIV.jpeg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Martes 12 de enero 2027 </h3>

                        <h1>Química IV</h1>
                        <h2>Tercer parcial</h2>
                        
                        <form action="" method="POST"> 
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="3">
                            <input type="hidden" name="idEstudiante" value="<%=idEstudiante%>"> 
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar" value="Entrar" onClick="aviso()">
                        </form>
                    </div>
                </div>


            </div>
        </div>
        
        <ul class="puntos">
            <li class="punto activo"></li>
            <li class="punto"></li>
        </ul>
    </div>
        
        <script src="javaScriptCarrusel.js"></script>
    </body>
</html>
