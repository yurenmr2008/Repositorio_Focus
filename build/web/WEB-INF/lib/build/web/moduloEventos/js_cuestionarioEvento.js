

const opc1 = document.querySelector(".opcion1");
const opc2 = document.querySelector(".opcion2");
const opc3 = document.querySelector(".opcion3");
const opc4 = document.querySelector(".opcion4");


const btn_continuar1 = document.querySelector(".btn_continuar1");
const btn_continuar2 = document.querySelector(".btn_continuar2");
const btn_continuar3 = document.querySelector(".btn_continuar3");
const btn_continuar4 = document.querySelector(".btn_continuar4");

const valorRespuesta1 = document.querySelector('.valorRes1').value;
const valorRespuesta2 = document.querySelector('.valorRes2').value;
const valorRespuesta3 = document.querySelector('.valorRes3').value;
const valorRespuesta4 = document.querySelector('.valorRes4').value;

const tiempoRes1 = document.querySelector('.tiempoRespuesta1');
const tiempoRes2 = document.querySelector('.tiempoRespuesta2');
const tiempoRes3 = document.querySelector('.tiempoRespuesta3');
const tiempoRes4 = document.querySelector('.tiempoRespuesta4');

let preguntaRespondida = false;

let tiempoInicial = new Date(); //



opc1.addEventListener('click',()=>{
    if(preguntaRespondida === false){
        console.log("Activado");
        
        if(valorRespuesta1 === "Correcto"){
            opc1.style.background = 'green';

        }
        else{
            opc1.style.background = 'red';
            marcarRespuestaCorrecta();
        }
                
        btn_continuar1.style.display = 'block';
        tiempoRes1.value = tiempoTranscurrido();//Le da al hidden el valor del tiempo que tardo el usuario en contestar en milisegundos
        console.log("Tiempo de respuesta:" + tiempoRes1.value);
        preguntaRespondida = true;
        

        
    
    }
} );

opc2.addEventListener('click',()=>{
    if(preguntaRespondida === false){
        console.log("Activado");
        
        if(valorRespuesta2 === "Correcto"){
            opc2.style.background = 'green';

        }
        else{
            opc2.style.background = 'red';
            marcarRespuestaCorrecta();

        }
        
        btn_continuar2.style.display = 'block';
        
        tiempoRes2.value = tiempoTranscurrido();
        console.log("Tiempo de respuesta:" + tiempoRes2.value);
        preguntaRespondida = true;
    }
} );

opc3.addEventListener('click',()=>{
    if(preguntaRespondida === false){
        console.log("Activado");
        
        if(valorRespuesta3 === "Correcto"){
            opc3.style.background = 'green';

        }
        else{
            opc3.style.background = 'red';
            marcarRespuestaCorrecta();

        }
        
        tiempoRes3.value = tiempoTranscurrido();
        console.log("Tiempo de respuesta:" + tiempoRes3.value);
        btn_continuar3.style.display = 'block';
        preguntaRespondida = true;
    }
} );

opc4.addEventListener('click',()=>{
    if(preguntaRespondida === false){
        console.log("Activado");
        
        if(valorRespuesta4 === "Correcto"){
            opc4.style.background = 'green';

        }
        else{
            opc4.style.background = 'red';
            marcarRespuestaCorrecta();
        }

        tiempoRes4.value = tiempoTranscurrido();
        console.log("Tiempo de respuesta:" + tiempoRes4.value);
       
        btn_continuar4.style.display = 'block';
        preguntaRespondida = true;
    }
} );


function marcarRespuestaCorrecta(){
        if(valorRespuesta1 === "Correcto"){
            opc1.style.background = 'green';
        }
        else{
            if(valorRespuesta2 === "Correcto"){
                opc2.style.background = 'green';
            }
            else{
                if(valorRespuesta3 === "Correcto"){
                    opc3.style.background = 'green';
                }
                else{
                    if(valorRespuesta4 === "Correcto"){
                        opc4.style.background = 'green';
                    }
                }
            }
        }
    
}

function tiempoTranscurrido(){
    let tiempoFinal = new Date();
        
    let tiempo_transcurrido = tiempoFinal - tiempoInicial;
        
    console.log("Tiempo transcurrido: " + tiempo_transcurrido);
    
    return tiempo_transcurrido;
}