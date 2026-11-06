function atualizar() {
    var _a, _b, _c, _d, _e, _f;
    var out = document.getElementById("output");
    if (!out)
        return;
    var cssWidth = window.innerWidth;
    var cssHeight = window.innerHeight;
    var screenWidth = window.screen.width;
    var screenHeight = window.screen.height;
    var dpr = window.devicePixelRatio;
    var physicalWidth = screenWidth * dpr;
    var physicalHeight = screenHeight * dpr;
    var orientation = ((_b = (_a = screen.orientation) === null || _a === void 0 ? void 0 : _a.type) !== null && _b !== void 0 ? _b : "indisponível");
    var safeAreas = {
        top: (_c = window.screen.availTop) !== null && _c !== void 0 ? _c : "N/A",
        bottom: (_d = window.screen.availBottom) !== null && _d !== void 0 ? _d : "N/A",
        left: (_e = window.screen.availLeft) !== null && _e !== void 0 ? _e : "N/A",
        right: (_f = window.screen.availRight) !== null && _f !== void 0 ? _f : "N/A",
    };
    out.textContent = "\n\uD83D\uDCF1 VIEWPORT CSS (o que o navegador usa)\nWidth:  ".concat(cssWidth, "\nHeight: ").concat(cssHeight, "\n\n\uD83D\uDCDF SCREEN L\u00D3GICA (sem DPR)\nWidth:  ").concat(screenWidth, "\nHeight: ").concat(screenHeight, "\n\n\uD83D\uDD0D Device Pixel Ratio\nDPR: ").concat(dpr, "\n\n\uD83E\uDDEE RESOLU\u00C7\u00C3O F\u00CDSICA ESTIMADA (Screen * DPR)\nWidth:  ").concat(physicalWidth, "\nHeight: ").concat(physicalHeight, "\n\n\uD83D\uDD04 Orienta\u00E7\u00E3o atual\n").concat(orientation, "\n\n\uD83E\uDDED SAFE AREAS (se dispon\u00EDveis)\nTop:    ").concat(safeAreas.top, "\nBottom: ").concat(safeAreas.bottom, "\nLeft:   ").concat(safeAreas.left, "\nRight:  ").concat(safeAreas.right, "\n\n");
}
window.addEventListener("resize", atualizar);
window.addEventListener("orientationchange", atualizar);
atualizar();
