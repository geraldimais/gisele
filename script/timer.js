const startDate = new Date("2020-06-23T16:52:00"); // coloque a data do relacionamento

function updateTimer() {
  const now = new Date();

  let years = now.getFullYear() - startDate.getFullYear();
  let months = now.getMonth() - startDate.getMonth();
  let days = now.getDate() - startDate.getDate();
  let hours = now.getHours() - startDate.getHours();
  let minutes = now.getMinutes() - startDate.getMinutes();
  let seconds = now.getSeconds() - startDate.getSeconds();

  // Ajusta se o dia atual é menor que o dia de início
  if (seconds < 0) {
    seconds += 60;
    minutes--;
  }
  if (minutes < 0) {
    minutes += 60;
    hours--;
  }
  if (hours < 0) {
    hours += 24;
    days--;
  }
  if (days < 0) {
    // Pega o mês anterior
    const prevMonth = new Date(now.getFullYear(), now.getMonth(), 0);
    days += prevMonth.getDate();
    months--;
  }
  if (months < 0) {
    months += 12;
    years--;
  }

  document.getElementById("timer").innerText =
    `Estamos juntos há ${years} anos, ${months} meses, ${days} dias, ` +
    `${hours} horas, ${minutes} minutos e ${seconds} segundos 💖`;
}

setInterval(updateTimer, 1000);
updateTimer();
