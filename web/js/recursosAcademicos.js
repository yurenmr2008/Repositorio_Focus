const datos = [

    {
        carrera: "Tronco Común",
        semestre: 5,
        materia: "Cálculo Integral",
        disponible: true,

        unidades: [

            {
                nombre: "Unidad 1 • Antiderivada e Integral Indefinida",

                temas: [

                    {
                        nombre: "1.1 La antiderivada y el concepto de integral indefinida",
                        link: "1.1.html"
                    },

                    {
                        nombre: "1.2 Integrales inmediatas",
                        link: "1.2.html"
                    },

                    {
                        nombre: "1.2.1 Integración de funciones algebraicas",
                        link: "1.2.1.html"
                    },

                    {
                        nombre: "1.2.2 Integración de funciones trigonométricas",
                        link: "1.2.2.html"
                    },

                    {
                        nombre: "1.2.3 Integración de funciones exponenciales y logarítmicas",
                        link: "1.2.3.html"
                    },

                    {
                        nombre: "1.3 Constante de integración y aplicaciones",
                        link: "1.3.html"
                    }

                ]

            },

            {
                nombre: "Unidad 2 • Métodos de Integración",

                temas: [

                    {
                        nombre: "2.1 Integración por partes",
                        link: "2.1.html"
                    },

                    {
                        nombre: "2.2 Integración por potencias trigonométricas",
                        link: "2.2.html"
                    },

                    {
                        nombre: "2.3 Integración por sustitución trigonométrica",
                        link: "2.3.html"
                    },

                    {
                        nombre: "2.4 Integración por fracciones parciales",
                        link: "2.4.html"
                    },

                    {
                        nombre: "2.5 Integración por racionalización",
                        link: "2.5.html"
                    }

                ]

            },

            {
                nombre: "Unidad 3 • Integral Definida",

                temas: [

                    {
                        nombre: "3.1 Integral definida y Teorema Fundamental del Cálculo",
                        link: "3.1.html"
                    },

                    {
                        nombre: "3.2 Cálculo de área entre un eje y una curva",
                        link: "3.2.html"
                    },

                    {
                        nombre: "3.3 Cálculo de volumen de sólidos de revolución",
                        link: "3.3.html"
                    },

                    {
                        nombre: "3.4 Longitud de arco",
                        link: "3.4.html"
                    }

                ]

            }

        ]

    },

    {
        carrera: "Tronco Común",
        semestre: 1,
        materia: "Dibujo Técnico I",
        disponible: false,
        unidades: []
    },

    {
        carrera: "Tronco Común",
        semestre: 2,
        materia: "Dibujo Técnico II",
        disponible: false,
        unidades: []
    },

    {
        carrera: "Tronco Común",
        semestre: 1,
        materia: "Química",
        disponible: false,
        unidades: []
    },

    {
        carrera: "Tronco Común",
        semestre: 3,
        materia: "Física I",
        disponible: false,
        unidades: []
    },

    {
        carrera: "Tronco Común",
        semestre: 4,
        materia: "Física II",
        disponible: false,
        unidades: []
    },

    {
        carrera: "Tronco Común",
        semestre: 5,
        materia: "Física III",
        disponible: false,
        unidades: []
    },

    {
        carrera: "Tronco Común",
        semestre: 6,
        materia: "Física IV",
        disponible: false,
        unidades: []
    }

];

const contenedor = document.getElementById("contenedorMaterias");
const buscador = document.getElementById("buscador");

function obtenerCarrerasSeleccionadas(){

    return [...document.querySelectorAll(".carrera:checked")]
    .map(c => c.value);

}

function obtenerSemestresSeleccionados(){

    return [...document.querySelectorAll(".semestre:checked")]
    .map(s => Number(s.value));

}

function renderizarMaterias(){

    const textoBusqueda = buscador.value.toLowerCase();

    const carreras = obtenerCarrerasSeleccionadas();
    const semestres = obtenerSemestresSeleccionados();

    let resultados = datos.filter(item => {

        const coincideBusqueda = item.materia
        .toLowerCase()
        .includes(textoBusqueda);

        const coincideCarrera = carreras.length === 0 ||
        carreras.includes(item.carrera);

        const coincideSemestre = semestres.length === 0 ||
        semestres.includes(item.semestre);

        return coincideBusqueda && coincideCarrera && coincideSemestre;

    });

    contenedor.innerHTML = "";

    resultados.forEach((materia,index) => {

        const card = document.createElement("div");

        if(materia.disponible){
            card.classList.add("materia-card");
        }
        else{
            card.classList.add("materia-card","bloqueada");
        }

        let unidadesHTML = "";

        materia.unidades.forEach((unidad,uIndex) => {

            let temasHTML = "";

            unidad.temas.forEach(tema => {

                temasHTML += `
                    <div class="tema"
                    onclick="window.location.href='${tema.link}'">
                        ${tema.nombre}
                    </div>
                `;

            });

            unidadesHTML += `

                <div class="unidad">

                    <button
                    class="boton-unidad"
                    onclick="toggleTemas('temas-${index}-${uIndex}')">
                        ${unidad.nombre}
                    </button>

                    <div class="temas" id="temas-${index}-${uIndex}">
                        ${temasHTML}
                    </div>

                </div>

            `;

        });

        card.innerHTML = `

            <div class="materia-titulo">
                ${materia.materia}
            </div>

            <div class="info">
                ${materia.carrera} • Semestre ${materia.semestre}
            </div>

            ${
                materia.disponible
                ?
                unidadesHTML
                :
                ""
            }

        `;

        contenedor.appendChild(card);

    });

}

function toggleTemas(id){

    const temas = document.getElementById(id);

    if(temas.style.display === "block"){
        temas.style.display = "none";
    }
    else{
        temas.style.display = "block";
    }

}

buscador.addEventListener("input", renderizarMaterias);

document.querySelectorAll(".carrera")
.forEach(check => {
    check.addEventListener("change", renderizarMaterias);
});

document.querySelectorAll(".semestre")
.forEach(check => {
    check.addEventListener("change", renderizarMaterias);
});

renderizarMaterias();