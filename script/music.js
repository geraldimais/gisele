const music = document.getElementById('background-music');
const playButton = document.getElementById('play-button');
const pauseButton = document.getElementById('pause-button');
const musicAnimation = document.getElementById('music-animation');

const playlist = [
  'music/Bruna Karla - Que Bom Você Chegou.mp3',
  'music/Lindo Momento - Julliany Souza Letra.mp3',
  'music/Eu Te Amo -  Melk Villar e Paloma Possi.mp3',
  'music/Marcela Taís - Clipe： Escolhi te esperar.mp3',
  'music/Mariana Aguiar - Seremos Um.mp3',
  'music/Meu grande amor - Lara Fabian.mp3',
];

let currentTrack = 0;

music.src = playlist[currentTrack];

function updateCurrentTrackName() {
  const currentTrackDisplay = document.getElementById('current-track');
  const fileName = playlist[currentTrack].split('/').pop().replace('.mp3', '');
  currentTrackDisplay.innerText = `Tocando agora: ${fileName}`;
}

function playCurrentTrack() {
  music.muted = false;
  music.src = playlist[currentTrack];
  music.play();
  updateCurrentTrackName();
  showPauseButton();
  showAnimation();
}

function playMusic() {
  if (music.src !== playlist[currentTrack]) {
    music.src = playlist[currentTrack];
  }
  music.play().then(() => {
    updateCurrentTrackName();
    showPauseButton();
    showAnimation();
  }).catch((e) => {
    console.log("Erro ao tentar tocar música: ", e);
  });
}

function pauseMusic() {
  music.pause();
  const currentTrackDisplay = document.getElementById('current-track');
  currentTrackDisplay.innerText = `Pausado: ${playlist[currentTrack].split('/').pop().replace('.mp3', '')}`;
  showPlayButton();
  hideAnimation();
}

function nextMusic() {
  currentTrack = (currentTrack + 1) % playlist.length;
  playCurrentTrack();
}

function prevMusic() {
  currentTrack = (currentTrack - 1 + playlist.length) % playlist.length;
  playCurrentTrack();
}

function showPlayButton() {
  playButton.style.display = 'inline';
  pauseButton.style.display = 'none';
}

function showPauseButton() {
  playButton.style.display = 'none';
  pauseButton.style.display = 'inline';
}

function showAnimation() {
  musicAnimation.style.display = 'flex';
}

function hideAnimation() {
  musicAnimation.style.display = 'none';
}



music.addEventListener('ended', () => {
  nextMusic();
});

window.addEventListener('load', () => {
  updateCurrentTrackName();
});
