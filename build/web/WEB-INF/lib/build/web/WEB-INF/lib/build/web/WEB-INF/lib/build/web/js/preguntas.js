const preguntas = {
  "Calculo Diferencial": {
    1: {
      "Propiedades de los numeros reales": {
        "facil": [
          { pregunta: "¿Cuál es el resultado de 3 + 5?", opciones: ["6","8","9","7"], correcta: 1, retro: "Suma básica: 3 + 5 = 8." },
          { pregunta: "¿Cuál es el mayor entre 2 y -1?", opciones: ["2","-1","Son iguales","0"], correcta: 0, retro: "2 es mayor que -1." },
          { pregunta: "¿Qué desigualdad es verdadera?", opciones: ["5 < 2","-3 > 1","0 ≤ 0","2 < -2"], correcta: 2, retro: "0 ≤ 0 es verdadera porque son iguales." },
          { pregunta: "¿Cuál es el opuesto de 7?", opciones: ["7","-7","0","1/7"], correcta: 1, retro: "El opuesto aditivo de 7 es -7." },
          { pregunta: "¿Qué número es mayor: -2 o -5?", opciones: ["-2","-5","Son iguales","0"], correcta: 0, retro: "En la recta numérica -2 está a la derecha de -5, por lo tanto es mayor." }
        ],
        "medio": [
          { pregunta: "Si a > b y b > c, ¿qué se puede afirmar?", opciones: ["a < c","a > c","a = c","No se puede saber"], correcta: 1, retro: "Por transitividad: si a > b y b > c entonces a > c." },
          { pregunta: "¿Cuál es la solución de |x| = 3?", opciones: ["x = 3","x = -3","x = ±3","No tiene solución"], correcta: 2, retro: "Valor absoluto 3 implica x = 3 o x = -3." },
          { pregunta: "¿Cuál es el intervalo que contiene 0 y 1?", opciones: ["(0,1)","[0,1]","(0,1]","[0,1)"], correcta: 1, retro: "Si se dice 'contiene 0 y 1' se usan corchetes: [0,1]." },
          { pregunta: "¿Qué representa el conjunto {x | x > 2}?", opciones: ["Intervalo cerrado","Intervalo abierto (2,∞)","Número 2","Conjunto vacío"], correcta: 1, retro: "Es el intervalo abierto (2,∞)." },
          { pregunta: "Si 2x + 3 > 7, ¿x > ? ", opciones: ["1","2","3","4"], correcta: 1, retro: "2x + 3 > 7 → 2x > 4 → x > 2." }
        ],
        "dificil": [
          { pregunta: "Resuelve la desigualdad: (x-1)(x+2) < 0", opciones: ["x < -2","-2 < x < 1","x > 1","No tiene solución"], correcta: 1, retro: "Ceros en -2 y 1; signo negativo entre ellos: -2 < x < 1." },
          { pregunta: "¿Cuál es la intersección de [0,2] y (1,3)?", opciones: ["(1,2]","[1,2]","(0,1)","[0,3]"], correcta: 0, retro: "Intersección es (1,2] porque 1 no incluido, 2 sí." },
          { pregunta: "Si a ≤ b y b ≤ c, ¿qué se cumple?", opciones: ["a > c","a ≤ c","a = c","Nada"], correcta: 1, retro: "Por transitividad de ≤, a ≤ c." },
          { pregunta: "¿Cuál es la solución de x^2 ≥ 4?", opciones: ["x ≤ -2 o x ≥ 2","-2 < x < 2","x = ±2","No tiene solución"], correcta: 0, retro: "x^2 ≥ 4 implica |x| ≥ 2 → x ≤ -2 o x ≥ 2." },
          { pregunta: "¿Cuál es el complemento de (0,1] en R?", opciones: ["(-∞,0] ∪ (1,∞)","[0,1]","(0,1)","(-∞,0) ∪ [1,∞)"], correcta: 0, retro: "Complemento incluye todo fuera de (0,1], es (-∞,0] ∪ (1,∞)." }
        ]
      },

      "Funciones": {
        "facil": [
          { pregunta: "Si f(x)=2x+1, ¿f(2)?", opciones: ["4","5","3","2"], correcta: 1, retro: "Sustituye: 2·2+1 = 5." },
          { pregunta: "¿Qué es el dominio de f(x)=1/x?", opciones: ["R","R\\{0}","[0,∞)","(0,∞)"], correcta: 1, retro: "No se puede dividir entre 0, dominio R sin 0." },
          { pregunta: "La función f(x)=x^2 es par o impar?", opciones: ["Par","Impar","Ninguna","Ambas"], correcta: 0, retro: "f(-x)=(-x)^2=x^2=f(x) → par." },
          { pregunta: "¿Cuál es la imagen de x=3 en f(x)=x-1?", opciones: ["2","3","4","-2"], correcta: 0, retro: "3-1 = 2." },
          { pregunta: "¿Qué representa la gráfica de una función?", opciones: ["Relación entre variables","Número","Operación","Conjunto vacío"], correcta: 0, retro: "La gráfica muestra la relación entre variable independiente y dependiente." }
        ],
        "medio": [
          { pregunta: "Si f(x)=x^2 y g(x)=x+1, ¿(f∘g)(x)?", opciones: ["(x+1)^2","x^2+1","x^2+x+1","x^2+x"], correcta: 0, retro: "Composición: f(g(x)) = (x+1)^2." },
          { pregunta: "¿Cuál es el dominio de f(x)=√(x-2)?", opciones: ["x ≥ 2","x > 2","x ≤ 2","Todos"], correcta: 0, retro: "Radicando ≥ 0 → x-2 ≥ 0 → x ≥ 2." },
          { pregunta: "Si f(x)=1/(x-3), ¿hay asíntota vertical en x=3?", opciones: ["Sí","No","Solo si x→∞","Depende"], correcta: 0, retro: "Denominador 0 en x=3 → asíntota vertical." },
          { pregunta: "¿Qué tipo de función es f(x)=e^x?", opciones: ["Exponencial","Polinómica","Racional","Trigonométrica"], correcta: 0, retro: "Función exponencial con base e." },
          { pregunta: "Si f(x)=2x y g(x)=3x, ¿(f+g)(x)?", opciones: ["5x","6x","x","-x"], correcta: 0, retro: "Suma: 2x+3x = 5x." }
        ],
        "dificil": [
          { pregunta: "Encuentra la inversa de f(x)=2x+3", opciones: ["(x-3)/2","2x-3","1/(2x+3)","(x+3)/2"], correcta: 0, retro: "Resolver y = 2x+3 → x = (y-3)/2 → f^{-1}(x)=(x-3)/2." },
          { pregunta: "¿Cuál es el dominio de f(x)=(x^2-1)/(x-1)?", opciones: ["R\\{1}","R","[-1,1]","(1,∞)"], correcta: 0, retro: "Simplifica pero x=1 no está definido originalmente → excluir 1." },
          { pregunta: "Si f(x)=ln(x-1), ¿dominio?", opciones: ["x>1","x≥1","x<1","Todos"], correcta: 0, retro: "Logaritmo natural requiere argumento > 0 → x-1>0 → x>1." },
          { pregunta: "¿Cuál es la composición inversa f^{-1}(f(x)) para función biyectiva?", opciones: ["x","f(x)","f^{-1}(x)","No existe"], correcta: 0, retro: "Composición de inversa con la función devuelve x." },
          { pregunta: "Si f(x)=x^3-2x, ¿es inyectiva en R?", opciones: ["Sí","No","Solo en [0,∞)","Solo en (-∞,0]"], correcta: 0, retro: "Función cúbica estrictamente creciente → inyectiva en R." }
        ]
      },

      "Limites": {
        "facil": [
          { pregunta: "lim_{x→2} (x+3) = ?", opciones: ["5","2","3","No existe"], correcta: 0, retro: "Sustituye x=2 → 2+3=5." },
          { pregunta: "lim_{x→0} x = ?", opciones: ["0","1","∞","No existe"], correcta: 0, retro: "Sustitución directa: 0." },
          { pregunta: "lim_{x→1} 2 = ?", opciones: ["2","1","0","No existe"], correcta: 0, retro: "Constante → límite es la constante." },
          { pregunta: "lim_{x→3} (x^2) = ?", opciones: ["9","6","3","No existe"], correcta: 0, retro: "3^2 = 9." },
          { pregunta: "lim_{x→-1} (x+1) = ?", opciones: ["0","-1","1","No existe"], correcta: 0, retro: "Sustitución: -1+1=0." }
        ],
        "medio": [
          { pregunta: "lim_{x→0} (sin x)/x = ?", opciones: ["1","0","∞","-1"], correcta: 0, retro: "Límite trigonométrico conocido: 1." },
          { pregunta: "lim_{x→2} (x^2-4)/(x-2) = ?", opciones: ["4","2","0","No existe"], correcta: 0, retro: "Factoriza: (x-2)(x+2)/(x-2) → x+2 → 4." },
          { pregunta: "lim_{x→∞} 1/x = ?", opciones: ["0","1","∞","No existe"], correcta: 0, retro: "A medida que x→∞, 1/x→0." },
          { pregunta: "lim_{x→0} (1 - cos x)/x^2 = ?", opciones: ["1/2","0","1","∞"], correcta: 0, retro: "Límite conocido: 1/2." },
          { pregunta: "lim_{x→0} (e^x - 1)/x = ?", opciones: ["1","0","e","∞"], correcta: 0, retro: "Derivada de e^x en 0 → 1." }
        ],
        "dificil": [
          { pregunta: "lim_{x→∞} (3x^2+1)/(x^2-2) = ?", opciones: ["3","1","0","∞"], correcta: 0, retro: "Comparar coeficientes principales: 3/1 = 3." },
          { pregunta: "lim_{x→0} (sin 3x)/(x) = ?", opciones: ["3","1","0","No existe"], correcta: 0, retro: "Usa (sin 3x)/(3x)·3 → 1·3 = 3." },
          { pregunta: "lim_{x→0} (tan x)/x = ?", opciones: ["1","0","∞","-1"], correcta: 0, retro: "Límite trigonométrico: 1." },
          { pregunta: "lim_{x→0} (1 + x)^{1/x} = ?", opciones: ["e","1","0","∞"], correcta: 0, retro: "Límite clásico que define e." },
          { pregunta: "lim_{x→0} (sqrt(1+x)-1)/x = ?", opciones: ["1/2","0","1","-1/2"], correcta: 0, retro: "Derivada de sqrt en 1: 1/(2√1)=1/2." }
        ]
      }
    },

    2: {
      "La derivada y sus interpretaciones": {
        "facil": [
          { pregunta: "La derivada representa:", opciones: ["Pendiente de la tangente","Área bajo la curva","Volumen","Longitud"], correcta: 0, retro: "La derivada es la pendiente de la recta tangente." },
          { pregunta: "Si s(t)=t^2, la velocidad v(t)=?", opciones: ["2t","t^2","t","1"], correcta: 0, retro: "v = ds/dt = 2t." },
          { pregunta: "Derivada de constante c es:", opciones: ["0","c","1","-c"], correcta: 0, retro: "La derivada de una constante es 0." },
          { pregunta: "Pendiente de y=x es:", opciones: ["1","0","x","-1"], correcta: 0, retro: "y=x tiene pendiente 1." },
          { pregunta: "Interpretación física de derivada: cambio por unidad de:", opciones: ["Tiempo","Área","Volumen","Longitud"], correcta: 0, retro: "Cambio por unidad de tiempo (por ejemplo velocidad)." }
        ],
        "medio": [
          { pregunta: "Si y = x^3, y' = ?", opciones: ["3x^2","x^2","3x","x^3"], correcta: 0, retro: "Regla de potencia: n x^{n-1}." },
          { pregunta: "Derivada de f(x)=x^n es:", opciones: ["n x^{n-1}","x^n","n x^n","x^{n-1}"], correcta: 0, retro: "Regla de la potencia." },
          { pregunta: "Si f(x)=sin x, f'(x) = ?", opciones: ["cos x","-cos x","sin x","-sin x"], correcta: 0, retro: "Derivada de sin es cos." },
          { pregunta: "Si f(x)=e^x, f'(x) = ?", opciones: ["e^x","x e^{x-1}","1","ln x"], correcta: 0, retro: "Derivada de e^x es e^x." },
          { pregunta: "Si f(x)=x^2 sin x, f'(x) = ?", opciones: ["2x sin x + x^2 cos x","2x sin x","x^2 cos x","sin x + x cos x"], correcta: 0, retro: "Producto: (x^2)' sin x + x^2 (sin x)' = 2x sin x + x^2 cos x." }
        ],
        "dificil": [
          { pregunta: "Derivada de f(x)=x^x (usar logaritmos):", opciones: ["x^x(ln x + 1)","x^{x-1}","x^x ln x","x^x / x"], correcta: 0, retro: "d/dx x^x = x^x(ln x + 1)." },
          { pregunta: "Derivada de f(x)=ln(sin x):", opciones: ["cot x","sec x","csc x","tan x"], correcta: 0, retro: "d/dx ln(sin x) = cos x / sin x = cot x." },
          { pregunta: "Si y = u(v(x)), dy/dx = ?", opciones: ["u'(v(x))·v'(x)","u'(x)+v'(x)","u(v'(x))","u'(v(x))/v'(x)"], correcta: 0, retro: "Regla de la cadena: derivada compuesta." },
          { pregunta: "Derivada de f(x)=arcsin x:", opciones: ["1/√(1-x^2)","1/(1+x^2)","-1/√(1-x^2)","ln(1+x)"], correcta: 0, retro: "d/dx arcsin x = 1/√(1-x^2)." },
          { pregunta: "Derivada de f(x)=x^2 sin x:", opciones: ["2x sin x + x^2 cos x","2x sin x","x^2 cos x","sin x + x cos x"], correcta: 0, retro: "Producto: (x^2)' sin x + x^2 (sin x)' = 2x sin x + x^2 cos x." }
        ]
      }
    }
  },
  "Calculo Integral": {
    1: {
      "Antiderivada e integral indefinida": {
        "facil": [
          { pregunta: "∫ 2x dx = ?", opciones: ["x^2 + C","2x + C","x + C","0"], correcta: 0, retro: "∫2x dx = x^2 + C." },
          { pregunta: "∫ 0 dx = ?", opciones: ["C","0","x","1"], correcta: 0, retro: "Integral de 0 es constante C." },
          { pregunta: "∫ 1 dx = ?", opciones: ["x + C","1 + C","0","x^2/2"], correcta: 0, retro: "Integral de 1 es x + C." },
          { pregunta: "∫ cos x dx = ?", opciones: ["sin x + C","-sin x + C","cos x + C","-cos x + C"], correcta: 0, retro: "Integral de cos es sin." },
          { pregunta: "∫ x^n dx = ?", opciones: ["x^{n+1}/(n+1) + C (n≠-1)","n x^{n-1}","ln x","x^n + C"], correcta: 0, retro: "Regla de potencia para integrales." }
        ],
        "medio": [
          { pregunta: "∫ e^x dx = ?", opciones: ["e^x + C","x e^x + C","ln x + C","1 + C"], correcta: 0, retro: "Integral de e^x es e^x + C." },
          { pregunta: "∫ 1/x dx = ?", opciones: ["ln|x| + C","1/x + C","x + C","ln x^2 + C"], correcta: 0, retro: "Integral de 1/x es ln|x| + C." },
          { pregunta: "∫ sin x dx = ?", opciones: ["-cos x + C","cos x + C","sin x + C","-sin x + C"], correcta: 0, retro: "Integral de sin es -cos." },
          { pregunta: "∫ x dx = ?", opciones: ["x^2/2 + C","x + C","2x + C","ln x + C"], correcta: 0, retro: "Integral de x es x^2/2 + C." },
          { pregunta: "∫ (2x+1) dx = ?", opciones: ["x^2 + x + C","x^2 + C","2x^2 + x + C","ln x + C"], correcta: 0, retro: "Integrar término a término." }
        ],
        "dificil": [
          { pregunta: "∫ x^3 dx = ?", opciones: ["x^4/4 + C","x^3/3 + C","x^2/2 + C","x^4 + C"], correcta: 0, retro: "x^{n+1}/(n+1) → x^4/4." },
          { pregunta: "∫ sec^2 x dx = ?", opciones: ["tan x + C","sec x + C","sin x + C","cos x + C"], correcta: 0, retro: "Integral conocida: tan x + C." },
          { pregunta: "∫ 3x^2 dx = ?", opciones: ["x^3 + C","x^3/3 + C","3x + C","x^2 + C"], correcta: 0, retro: "∫3x^2 = 3·x^3/3 = x^3 + C." },
          { pregunta: "∫ (2/x) dx = ?", opciones: ["2 ln|x| + C","ln|x| + C","2/x + C","x^2 + C"], correcta: 0, retro: "Constante 2 sale: 2 ln|x| + C." },
          { pregunta: "∫ (1/(1+x^2)) dx = ?", opciones: ["arctan x + C","ln|x| + C","arcsin x + C","tan x + C"], correcta: 0, retro: "Integral conocida: arctan x + C." }
        ]
      }
    },
    2: {
      "Integracion por partes y sustitución": {
        "facil": [
          { pregunta: "∫ x e^x dx se resuelve con:", opciones: ["Integración por partes","Sustitución simple","Fracciones parciales","No se puede integrar"], correcta: 0, retro: "Usar integración por partes: u=x, dv=e^x dx." },
          { pregunta: "Sustitución u = x^2 para ∫ 2x f(x^2) dx, du = ?", opciones: ["2x dx","x dx","dx","0"], correcta: 0, retro: "du = 2x dx, sustituir facilita la integral." },
          { pregunta: "∫ cos(2x) dx = ?", opciones: ["(1/2) sin(2x) + C","sin(2x) + C","(1/2) cos(2x) + C","-sin(2x) + C"], correcta: 0, retro: "Sustitución u=2x → (1/2) sin(2x)." },
          { pregunta: "∫ (2x)(x^2+1)^3 dx, u = x^2+1, du = ?", opciones: ["2x dx","x dx","dx","0"], correcta: 0, retro: "du = 2x dx, simplifica la integral." },
          { pregunta: "Integración por partes: ∫ u dv = ?", opciones: ["u v - ∫ v du","u v + ∫ v du","u/v - ∫ v du","No aplica"], correcta: 0, retro: "Fórmula estándar de partes." }
        ],
        "medio": [
          { pregunta: "∫ x ln x dx = ?", opciones: ["(x^2/2) ln x - x^2/4 + C","x^2 ln x + C","(x^2/2) ln x + C","ln x + C"], correcta: 0, retro: "Usar partes con u=ln x, dv=x dx." },
          { pregunta: "Sustitución trigonométrica para ∫ 1/√(1-x^2) dx da:", opciones: ["arcsin x + C","arccos x + C","ln|x| + C","tan^{-1} x + C"], correcta: 0, retro: "Integral conocida: arcsin x + C." },
          { pregunta: "∫ e^{2x} dx = ?", opciones: ["(1/2) e^{2x} + C","e^{2x} + C","2 e^{2x} + C","ln e^{2x} + C"], correcta: 0, retro: "Sustitución u=2x → (1/2) e^{2x}." },
          { pregunta: "∫ x/(x^2+1) dx = ?", opciones: ["(1/2) ln(x^2+1) + C","ln(x^2+1) + C","1/(x^2+1) + C","x^2/2 + C"], correcta: 0, retro: "Sustitución u=x^2+1 → du=2x dx." },
          { pregunta: "∫ sin^2 x dx = ?", opciones: ["(x/2) - (sin 2x)/4 + C","(x/2) + (sin 2x)/4 + C","sin^2 x + C","-cos x + C"], correcta: 0, retro: "Usar identidad: sin^2 x = (1-cos 2x)/2." }
        ],
        "dificil": [
          { pregunta: "∫ x^2 e^{x} dx se resuelve con:", opciones: ["Partes repetidas","Sustitución simple","Fracciones parciales","No se puede"], correcta: 0, retro: "Usar partes repetidas reduciendo potencia de x." },
          { pregunta: "∫ dx/(x^2+4) = ?", opciones: ["(1/2) arctan(x/2) + C","arctan(x/2) + C","(1/4) arctan(x/2) + C","ln(x^2+4) + C"], correcta: 0, retro: "Integral estándar con a=2: (1/2) arctan(x/2)." },
          { pregunta: "∫ x/(√(x^2+1)) dx = ?", opciones: ["√(x^2+1) + C","ln(x+√(x^2+1)) + C","(x^2+1)^{3/2} + C","No tiene"], correcta: 0, retro: "Derivada de √(x^2+1) es x/√(x^2+1)." },
          { pregunta: "Fracciones parciales: ∫ dx/(x^2-1) = ?", opciones: ["(1/2) ln| (x-1)/(x+1) | + C","ln|x^2-1| + C","(1/2) ln|x^2-1| + C","arctan x + C"], correcta: 0, retro: "Descomponer en fracciones parciales y integrar." },
          { pregunta: "∫ cos^3 x dx = ?", opciones: ["(sin x)(1 - cos^2 x)/3 + C","(sin x)(2 + cos^2 x)/3 + C","(sin x) - (sin^3 x)/3 + C","No existe"], correcta: 2, retro: "Usar identidad y separar: cos^3 = cos·cos^2." }
        ]
      }
    }
  }
};


window.preguntas = window.preguntas || preguntas;

function obtenerTemas(materia, unidad) {
  if (!window.preguntas || !window.preguntas[materia]) return [];
  const unidadObj = window.preguntas[materia][unidad];
  if (!unidadObj) return [];
  return Object.keys(unidadObj);
}

window.obtenerTemas = window.obtenerTemas || obtenerTemas;

console.log('preguntas.js cargado. materias:', Object.keys(window.preguntas || {}));
