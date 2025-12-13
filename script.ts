// ----- Modal de Vídeos -----

const modal = document.getElementById('modalVideo') as HTMLDivElement | null;
const fechar = document.querySelector('.fechar-video') as HTMLButtonElement | HTMLSpanElement | null;
const video = modal?.querySelector('video') as HTMLVideoElement | null;

const linksVideo = document.querySelectorAll('.abrir-video') as NodeListOf<HTMLAnchorElement>;

linksVideo.forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault();

    const src = link.getAttribute('data-video');
    if (!video || !modal || !src) return;

    video.src = src;

    modal.style.display = 'flex';
    video.play();
  });
});

function fecharModal() {
  if (!modal || !video) return;

  modal.style.display = 'none';
  video.pause();
  video.currentTime = 0;
  video.src = "";
}

if (fechar) {
  fechar.addEventListener('click', fecharModal);
}

if (modal) {
  modal.addEventListener('click', e => {
    if (e.target === modal) fecharModal();
  });
}


// ----- Modal de Fotos -----

const modalFotos = document.getElementById('modalFotos') as HTMLDivElement | null;
const fecharFotos = document.querySelector('.fechar-foto') as HTMLSpanElement | null;
const imgAtual = document.getElementById('fotoAtual') as HTMLImageElement | null;

const btnPrev = document.getElementById('prevFoto') as HTMLButtonElement | null;
const btnNext = document.getElementById('nextFoto') as HTMLButtonElement | null;

const linksFotos = document.querySelectorAll('.abrir-fotos') as NodeListOf<HTMLAnchorElement>;

let fotos: string[] = [];
let indiceAtual = 0;

// Abrir galeria
linksFotos.forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault();

    const lista = link.getAttribute('data-fotos');
    const base = link.getAttribute('data-base');

    if (!lista || !base || !modalFotos || !imgAtual) return;

    fotos = lista.split('|').map(nome => base + nome);
    indiceAtual = 0;

    imgAtual.src = fotos[indiceAtual];
    modalFotos.style.display = 'flex';
  });
});

function fecharModalFotos() {
  if (!modalFotos || !imgAtual) return;

  modalFotos.style.display = 'none';
  imgAtual.src = "";
}

if (fecharFotos) {
  fecharFotos.addEventListener('click', fecharModalFotos);
}

if (modalFotos) {
  modalFotos.addEventListener('click', e => {
    if (e.target === modalFotos) fecharModalFotos();
  });
}

// Navegar entre fotos
function mostrarFoto(i: number) {
  if (!imgAtual) return;

  indiceAtual = (i + fotos.length) % fotos.length;
  imgAtual.src = fotos[indiceAtual];
}

btnPrev?.addEventListener('click', () => mostrarFoto(indiceAtual - 1));
btnNext?.addEventListener('click', () => mostrarFoto(indiceAtual + 1));


//Texto desdobrável
function toggleSobre(): void {
  const div = document.getElementById("sobreTexto") as HTMLElement | null;
  const btn = document.querySelector(".sobre-toggle") as HTMLButtonElement | null;

  if (!div || !btn) return;

  div.classList.toggle("aberto");

  btn.textContent = div.classList.contains("aberto")
    ? "Mostrar menos"
    : "Leia mais...";
}

(window as any).toggleSobre = toggleSobre;

function abrirModalContato(): void {
  const modal = document.getElementById("modalContato") as HTMLElement;
  modal.style.display = "flex";

  (document.getElementById("contato") as HTMLInputElement).value = "";
  (document.getElementById("assunto") as HTMLInputElement).value = "";
  (document.getElementById("mensagem") as HTMLTextAreaElement).value = "";

  const feedback = document.getElementById("feedback-contato") as HTMLElement;

  feedback.textContent = "";
  feedback.style.color = "";
}

function fecharModalContato(): void {
  const modal = document.getElementById("modalContato") as HTMLElement;
  modal.style.display = "none";
}

let enviando = false;

function enviarEmailContato(): void {
  const contato = (document.getElementById("contato") as HTMLInputElement).value.trim();
  const assunto = (document.getElementById("assunto") as HTMLInputElement).value.trim();
  const mensagem = (document.getElementById("mensagem") as HTMLTextAreaElement).value.trim();
  const feedback = document.getElementById("feedback-contato") as HTMLElement;

  if (!contato || !assunto || !mensagem) {
    feedback.style.color = 'red';
    feedback.textContent = "Por favor, preencha todos os campos!";
    return;
  }

  if (enviando) return;
  
  enviando = true;  

  const btnEnviar = document.getElementById("enviar") as HTMLButtonElement;
  btnEnviar.disabled = true;

  const SERVICE_ID = "service_d0e1bsh";
  const TEMPLATE_ID = "template_4rkz8la";

  (window as any).emailjs.send(
    SERVICE_ID,
    TEMPLATE_ID,
    { contato, assunto, mensagem }
  ).then(() => {
    feedback.style.color = 'green';
    feedback.textContent = "Mensagem enviada com sucesso!";
    (document.getElementById("contato") as HTMLInputElement).value = "";
    (document.getElementById("assunto") as HTMLInputElement).value = "";
    (document.getElementById("mensagem") as HTMLTextAreaElement).value = "";
  }).catch((error: any) => {
    feedback.style.color = 'red';
    feedback.textContent = "Erro ao enviar mensagem. Tente novamente.";
    console.error(error);
  }).finally(() => {
    btnEnviar.disabled = false;
    enviando = false;
  });
}

(window as any).abrirModalContato = abrirModalContato;
(window as any).fecharModalContato = fecharModalContato;
(window as any).enviarEmailContato = enviarEmailContato;
