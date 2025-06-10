const track = document.getElementById("carousel");
let currentIndex = 0;
const totalImages = track.children.length;

function updateCarousel() {
  const offset = -(100 / 12) * currentIndex;
  track.style.transform = `translateX(${offset}%)`;
}

function nextSlide() {
  if (currentIndex < totalImages - 1) {
    currentIndex++;
  } else {
    currentIndex = 0; // volta para a primeira imagem
  }
    updateCarousel();
  }

function prevSlide() {
  if (currentIndex > 0) {
    currentIndex--;
  } else {
    currentIndex = totalImages - 1; // vai para a última imagem
  }
    updateCarousel();
  }

// === Suporte a toque (arrastar no celular) ===

let startX = 0;
let isDragging = false;

track.addEventListener("touchstart", (e) => {
  startX = e.touches[0].clientX;
  isDragging = true;
});

track.addEventListener("touchmove", (e) => {
  if (!isDragging) return;

  const currentX = e.touches[0].clientX;
  const diff = startX - currentX;

  // Evita scroll da página
  if (Math.abs(diff) > 10) e.preventDefault();
});

track.addEventListener("touchend", (e) => {
  if (!isDragging) return;
  const endX = e.changedTouches[0].clientX;
  const diff = startX - endX;

  if (diff > 50) {
    // Arrastou para a esquerda
    nextSlide();
  } else if (diff < -50) {
    // Arrastou para a direita
    prevSlide();
  }

  isDragging = false;
});
// === Avanço automático ===
setInterval(() => {
  nextSlide();
}, 4000); // a cada 4 segundos
