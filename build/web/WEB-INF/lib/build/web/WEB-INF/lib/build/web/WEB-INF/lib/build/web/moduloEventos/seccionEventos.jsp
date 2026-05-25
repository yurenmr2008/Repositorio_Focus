<%-- 
    Document   : seccionEventos
    Created on : 8 abr 2026, 10:34:43
    Author     : yuren
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    
    
    <head>
        <title>TODO supply a title</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link rel="stylesheet" href="estilosCarrusel3.css">
        
    </head>
    <body>
        <div>TODO write content</div>
        
    <div class="carrousel">
        
        <div class="contenedorBotonesCarrusel">

            <button class="btn_carrusel btn_anterior">◀</button>
            <button class="btn_carrusel btn_siguiente">▶</button>

            
            <div class="grande">
                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoIntegral.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 27 de noviembre 2024 </h3>

                        <h1>Calculo Integral</h1>
                        <h2>Primer parcial</h2> 
                        <form action="infoCuestionarioEvento.jsp" method="POST"> //Se modifo para pruebas la direccion que hiba a: cuestionarioEvento
                            
                            <input type="hidden" name="materiaEvento" value="CalculoIntegral">
                            <input type="hidden" name="parcialEvento" value="1">
                            <input type="hidden" name="idEstudiante" value="13"> //MODIFICAR POR EL VALOR REAL DEL ID
                            <input type="hidden" name="posicionPregunta" value="<%=1%>">

                            <input type="submit" name="Entrar">
                        </form>

                    </div>
                </div>


                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoQuimicaIV.jpeg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 28 de noviembre 2024 </h3>

                        <h1>Química IV</h1>
                        <h2>Primer parcial</h2>

                    </div>

                </div>


                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoFisicaIV.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 28 de noviembre 2024 </h3>

                        <h1>Fisica IV</h1>
                        <h2>Primer parcial</h2>

                    </div>

                </div>

                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoIntegral.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 2 de enero 2024 </h3>

                        <h1>Calculo Integral</h1>
                        <h2>Segundo parcial</h2>

                    </div>
                </div>

                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoQuimicaIV.jpeg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 28 de noviembre 2024 </h3>

                        <h1>Química IV</h1>
                        <h2>Segundo parcial</h2>
                    </div>

                </div>

                <div class="contenedorEvento">
                    <div>
                        <div class="contenedorFondo">
                           <img src="fondoFisicaIV.jpg" alt="Imagen 1" class="contenedorFondo">
                        </div>

                        <h3>Miércoles 28 de noviembre 2024 </h3>

                        <h1>Fisica IV</h1>
                        <h2>Segundo parcial</h2>

                    </div>

                </div>




                <div class="contenedorEvento">
                    <div>
                        hola5
                    </div>

                </div>


                <div class="contenedorEvento">
                    <div>
                        ultimo
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
