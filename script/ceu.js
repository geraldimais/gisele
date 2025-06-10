const canvas = document.getElementById('starry-sky');
const ctx = canvas.getContext('2d');

let width = window.innerWidth;
let height = window.innerHeight;
canvas.width = width;
canvas.height = height;

let stars = [];
let shootingStars = [];

function random(min, max) {
  return Math.random() * (max - min) + min;
}

// Criar mais estrelas fixas (300)
for (let i = 0; i < 300; i++) {
  stars.push({
    x: Math.random() * width,
    y: Math.random() * height,
    radius: Math.random() * 1.5,
    alpha: Math.random()
  });
}

// Criar estrelas cadentes com maior frequência
function createShootingStar() {
  shootingStars.push({
    x: random(0, width),
    y: 0,
    length: random(100, 300),
    speed: random(4, 10),
    opacity: 1
  });
}

setInterval(createShootingStar, 1000);  // de 3000ms para 1000ms

// Variáveis para mover a lua
const moon = document.getElementById('moon');
let moonX = parseFloat(getComputedStyle(moon).right);
let moonY = parseFloat(getComputedStyle(moon).top);

function moveMoon() {
  moonX -= 0.05; // movimento horizontal lento
  moonY += 0.02; // movimento vertical ainda mais sutil

  if (moonX < -200) moonX = width;  // reseta quando sai da tela
  if (moonY > height) moonY = 0;    // reseta verticalmente

  moon.style.right = `${moonX}px`;
  moon.style.top = `${moonY}px`;

  requestAnimationFrame(moveMoon);
}

moveMoon();

function draw() {
  ctx.clearRect(0, 0, width, height);

  // Fundo nebuloso
  let gradient = ctx.createRadialGradient(width/2, height/2, 100, width/2, height/2, width);
  gradient.addColorStop(0, 'rgba(20,20,30,0.3)');
  gradient.addColorStop(1, 'rgba(0,0,0,0.6)');
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, width, height);

  // Estrelas fixas
  stars.forEach(star => {
    ctx.beginPath();
    ctx.arc(star.x, star.y, star.radius, 0, Math.PI * 2);
    ctx.fillStyle = `rgba(255, 255, 255, ${star.alpha})`;
    ctx.fill();
  });

  // Estrelas cadentes
  shootingStars.forEach((s, index) => {
    ctx.beginPath();
    ctx.moveTo(s.x, s.y);
    ctx.lineTo(s.x + s.length, s.y + s.length / 2);
    ctx.strokeStyle = `rgba(255,255,255,${s.opacity})`;
    ctx.lineWidth = 2;
    ctx.stroke();

    s.x += s.speed;
    s.y += s.speed / 2;
    s.opacity -= 0.02;  // desaparecer um pouco mais rápido

    if (s.opacity <= 0) {
      shootingStars.splice(index, 1);
    }
  });

  requestAnimationFrame(draw);
}

draw();

window.addEventListener('resize', () => {
  width = window.innerWidth;
  height = window.innerHeight;
  canvas.width = width;
  canvas.height = height;
});