let tiempoRestante = 0;
let intervalo = null;

function iniciarTemporizador(segundos, onTick, onFinish) {
  clearInterval(intervalo);
  tiempoRestante = segundos;
  onTick(tiempoRestante);
  intervalo = setInterval(() => {
    tiempoRestante--;
    onTick(tiempoRestante);
    if (tiempoRestante <= 0) {
      clearInterval(intervalo);
      onFinish();
    }
  }, 1000);
}

function detenerTemporizador() {
  clearInterval(intervalo);
}
