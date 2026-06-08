const grande = document.querySelector('.grande');
const punto = document.querySelectorAll('.punto');

// Recorrer TODOS los punto
punto.forEach( ( cadaPunto , i )=> {
    // Asignamos un CLICK a cadaPunto
    punto[i].addEventListener('click',()=>{

    // Guardar la posición de ese PUNTO
    let posicion  = i;
    // Calculando el espacio que debe DESPLAZARSE el GRANDE
    let operacion = posicion * -50;

    // MOVEMOS el grand
    grande.style.transform = `translateX(${ operacion }%)`;

    // Recorremos TODOS los punto
    punto.forEach( ( cadaPunto , i )=>{
        // Quitamos la clase ACTIVO a TODOS los punto
        punto[i].classList.remove('activo');
    });
    // Añadir la clase activo en el punto que hemos hecho CLICK
    punto[i].classList.add('activo');

    });
});

const btnSiguiente = document.querySelector('.btn_siguiente');
const btnAnterior = document.querySelector('.btn_anterior');
const listaEventos = document.querySelectorAll('.contenedorEvento');


const numEventos = listaEventos.length;


let desplazamiento = 0;

btnSiguiente.addEventListener('click', ()=>{
    desplazamiento = desplazamiento + (100/numEventos  *-1); 
    grande.style.transform = `translateX(${ desplazamiento }%)`;

});

btnAnterior.addEventListener('click', ()=>{
    desplazamiento = desplazamiento + (100/numEventos); 
    grande.style.transform = `translateX(${ desplazamiento }%)`;

});

