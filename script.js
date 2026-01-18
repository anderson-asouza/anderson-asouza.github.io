// ----- Modal de Vídeos -----
var modal = document.getElementById('modalVideo');
var fechar = document.querySelector('.fechar-video');
var video = modal === null || modal === void 0 ? void 0 : modal.querySelector('video');
var linksVideo = document.querySelectorAll('.abrir-video');
linksVideo.forEach(function (link) {
    link.addEventListener('click', function (e) {
        e.preventDefault();
        var src = link.getAttribute('data-video');
        if (!video || !modal || !src)
            return;
        video.src = src;
        modal.style.display = 'flex';
        video.play();
    });
});
function fecharModal() {
    if (!modal || !video)
        return;
    modal.style.display = 'none';
    video.pause();
    video.currentTime = 0;
    video.src = "";
}
if (fechar) {
    fechar.addEventListener('click', fecharModal);
}
if (modal) {
    modal.addEventListener('click', function (e) {
        if (e.target === modal)
            fecharModal();
    });
}
// ----- Modal de Fotos -----
var modalFotos = document.getElementById('modalFotos');
var fecharFotos = document.querySelector('.fechar-foto');
var imgAtual = document.getElementById('fotoAtual');
var btnPrev = document.getElementById('prevFoto');
var btnNext = document.getElementById('nextFoto');
var linksFotos = document.querySelectorAll('.abrir-fotos');
var fotos = [];
var indiceAtual = 0;
// Abrir galeria
linksFotos.forEach(function (link) {
    link.addEventListener('click', function (e) {
        e.preventDefault();
        var lista = link.getAttribute('data-fotos');
        var base = link.getAttribute('data-base');
        if (!lista || !base || !modalFotos || !imgAtual)
            return;
        fotos = lista.split('|').map(function (nome) { return base + nome; });
        indiceAtual = 0;
        imgAtual.src = fotos[indiceAtual];
        modalFotos.style.display = 'flex';
    });
});
function fecharModalFotos() {
    if (!modalFotos || !imgAtual)
        return;
    modalFotos.style.display = 'none';
    imgAtual.src = "";
}
if (fecharFotos) {
    fecharFotos.addEventListener('click', fecharModalFotos);
}
if (modalFotos) {
    modalFotos.addEventListener('click', function (e) {
        if (e.target === modalFotos)
            fecharModalFotos();
    });
}
// Navegar entre fotos
function mostrarFoto(i) {
    if (!imgAtual)
        return;
    indiceAtual = (i + fotos.length) % fotos.length;
    imgAtual.src = fotos[indiceAtual];
}
btnPrev === null || btnPrev === void 0 ? void 0 : btnPrev.addEventListener('click', function () { return mostrarFoto(indiceAtual - 1); });
btnNext === null || btnNext === void 0 ? void 0 : btnNext.addEventListener('click', function () { return mostrarFoto(indiceAtual + 1); });
//Texto desdobrável
function toggleSobre() {
    var div = document.getElementById("sobreTexto");
    var btn = document.querySelector(".sobre-toggle");
    if (!div || !btn)
        return;
    div.classList.toggle("aberto");
    btn.textContent = div.classList.contains("aberto")
        ? "Mostrar menos"
        : "Leia mais...";
}
window.toggleSobre = toggleSobre;
function abrirModalContato() {
    var modal = document.getElementById("modalContato");
    modal.style.display = "flex";
    document.getElementById("contato").value = "";
    document.getElementById("assunto").value = "";
    document.getElementById("mensagem").value = "";
    var feedback = document.getElementById("feedback-contato");
    feedback.textContent = "";
    feedback.style.color = "";
}
function fecharModalContato() {
    var modal = document.getElementById("modalContato");
    modal.style.display = "none";
}
var enviando = false;
function enviarEmailContato() {
    var contato = document.getElementById("contato").value.trim();
    var assunto = document.getElementById("assunto").value.trim();
    var mensagem = document.getElementById("mensagem").value.trim();
    var feedback = document.getElementById("feedback-contato");
    if (!contato || !assunto || !mensagem) {
        feedback.style.color = 'red';
        feedback.textContent = "Por favor, preencha todos os campos!";
        return;
    }
    if (enviando)
        return;
    enviando = true;
    var btnEnviar = document.getElementById("enviar");
    btnEnviar.disabled = true;
    var SERVICE_ID = "service_d0e1bsh";
    var TEMPLATE_ID = "template_4rkz8la";
    window.emailjs.send(SERVICE_ID, TEMPLATE_ID, { contato: contato, assunto: assunto, mensagem: mensagem }).then(function () {
        feedback.style.color = 'green';
        feedback.textContent = "Mensagem enviada com sucesso!";
        document.getElementById("contato").value = "";
        document.getElementById("assunto").value = "";
        document.getElementById("mensagem").value = "";
    }).catch(function (error) {
        feedback.style.color = 'red';
        feedback.textContent = "Erro ao enviar mensagem. Tente novamente.";
        console.error(error);
    }).finally(function () {
        btnEnviar.disabled = false;
        enviando = false;
    });
}
window.abrirModalContato = abrirModalContato;
window.fecharModalContato = fecharModalContato;
window.enviarEmailContato = enviarEmailContato;
