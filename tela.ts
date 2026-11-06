function atualizar(): void {
  const out = document.getElementById("output");
  if (!out) return;

  const cssWidth: number = window.innerWidth;
  const cssHeight: number = window.innerHeight;

  const screenWidth: number = window.screen.width;
  const screenHeight: number = window.screen.height;

  const dpr: number = window.devicePixelRatio;

  const physicalWidth: number = screenWidth * dpr;
  const physicalHeight: number = screenHeight * dpr;

  const orientation = (screen.orientation?.type ?? "indisponível") as string;

  const safeAreas = {
    top: (window.screen as any).availTop ?? "N/A",
    bottom: (window.screen as any).availBottom ?? "N/A",
    left: (window.screen as any).availLeft ?? "N/A",
    right: (window.screen as any).availRight ?? "N/A",
  };

  out.textContent = `
📱 VIEWPORT CSS (o que o navegador usa)
Width:  ${cssWidth}
Height: ${cssHeight}

📟 SCREEN LÓGICA (sem DPR)
Width:  ${screenWidth}
Height: ${screenHeight}

🔍 Device Pixel Ratio
DPR: ${dpr}

🧮 RESOLUÇÃO FÍSICA ESTIMADA (Screen * DPR)
Width:  ${physicalWidth}
Height: ${physicalHeight}

🔄 Orientação atual
${orientation}

🧭 SAFE AREAS (se disponíveis)
Top:    ${safeAreas.top}
Bottom: ${safeAreas.bottom}
Left:   ${safeAreas.left}
Right:  ${safeAreas.right}

`;
}

window.addEventListener("resize", atualizar);
window.addEventListener("orientationchange", atualizar);

atualizar();