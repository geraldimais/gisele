const startDate = new Date("2021-10-22T00:00:00"); // coloque a data do relacionamento

function updateTimer() {
  const now = new Date();
  const diff = now - startDate;

  const seconds = Math.floor(diff / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);

  const years = Math.floor(days / 365);
  const months = Math.floor((days % 365) / 30);
  const daysLeft = (days % 365) % 30;
  const hoursLeft = hours % 24;
  const minutesLeft = minutes % 60;
  const secondsLeft = seconds % 60;

  document.getElementById("timer").innerText =
    `Estamos juntos há ${years} anos, ${months} meses, ${daysLeft} dias, ` +
    `${hoursLeft} horas, ${minutesLeft} minutos e ${secondsLeft} segundos 💖`;
}

setInterval(updateTimer, 1000);
updateTimer();
