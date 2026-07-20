<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>gerador_universal.app</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=IBM+Plex+Mono:wght@400;500;600;700&family=Playfair+Display:wght@700;800;900&family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&family=Poppins:wght@600;700;800&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
<style>
  :root{
    /* app shell (fixo, não muda com o tema escolhido) */
    --app-bg:#0a0d0a; --app-panel:#0e120f; --app-line:#1c2820; --app-muted:#6e8a78;
    --app-accent:#39ff7a; --app-text:#e8f5ec;
    --ui-mono:'IBM Plex Mono', ui-monospace, monospace;

    /* stage (conteúdo exportado) — valores default = tema Terminal */
    --s-bg:#050805; --s-text:#eef7f0; --s-muted:#7a9483;
    --s-accent:#00FF66; --s-accent-dim:#0a5c2c; --s-accent-deep:#08381c; --s-glow:rgba(0,255,102,.4);
    --s-termbox-bg:rgba(0,255,102,.07); --s-scan-tint:rgba(0,255,102,.08);
    --s-head:'Share Tech Mono', monospace; --s-body:'IBM Plex Mono', monospace;
  }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;background:var(--app-bg);color:var(--app-text);font-family:var(--ui-mono);}

  /* ---------- APP SHELL ---------- */
  .app{min-height:100vh;display:flex;flex-direction:column;}
  .topbar{display:flex;align-items:center;justify-content:space-between;padding:16px 24px;border-bottom:1px solid var(--app-line);background:linear-gradient(180deg,#0d130f,#0a0d0a);flex-wrap:wrap;gap:12px;}
  .logo{font-weight:700;color:var(--app-accent);font-size:14px;}
  .logo span{color:var(--app-muted);}
  .cursor{display:inline-block;width:8px;height:14px;background:var(--app-accent);margin-left:2px;vertical-align:-2px;animation:blink 1s steps(1) infinite;}
  @keyframes blink{50%{opacity:0;}}
  .format-tabs{display:flex;gap:8px;background:#0d130f;padding:4px;border:1px solid var(--app-line);border-radius:2px;}
  .format-tabs button{font-family:var(--ui-mono);font-size:12px;letter-spacing:.08em;font-weight:600;background:transparent;border:none;color:var(--app-muted);padding:8px 14px;border-radius:1px;cursor:pointer;}
  .format-tabs button:hover{color:var(--app-text);}
  .format-tabs button.active{background:var(--app-accent);color:#03170a;}

  .workspace{flex:1;display:flex;min-height:0;}
  .panel{width:390px;min-width:330px;border-right:1px solid var(--app-line);padding:20px;overflow-y:auto;background:var(--app-panel);}
  .stage-area{flex:1;overflow:auto;padding:32px;display:flex;flex-direction:column;align-items:center;gap:18px;background-image:linear-gradient(rgba(57,255,122,.05) 1px, transparent 1px),linear-gradient(90deg, rgba(57,255,122,.05) 1px, transparent 1px);background-size:26px 26px;}

  /* ---------- PANEL ---------- */
  .field{margin-bottom:16px;}
  .field label{display:block;font-size:10px;letter-spacing:.1em;color:var(--app-accent);margin-bottom:6px;text-transform:uppercase;font-weight:600;}
  .field .hint{display:block;font-size:10px;color:var(--app-muted);margin-top:4px;font-weight:400;text-transform:none;letter-spacing:0;}
  .field input[type=text], .field textarea, .field select{width:100%;background:#050805;border:1px solid var(--app-line);color:var(--app-text);font-family:var(--ui-mono);font-size:13px;padding:9px 10px;border-radius:1px;resize:vertical;outline:none;}
  .field input[type=text]:focus, .field textarea:focus, .field select:focus{border-color:var(--app-accent);}
  .field textarea{min-height:64px;line-height:1.5;}
  .section-title{color:#ffb020;font-size:11px;letter-spacing:.1em;text-transform:uppercase;font-weight:700;margin:22px 0 12px;padding-bottom:8px;border-bottom:1px dashed var(--app-line);display:flex;align-items:center;justify-content:space-between;}
  .section-title:first-child{margin-top:0;}
  .toggle-inline{display:flex;align-items:center;gap:6px;text-transform:none;letter-spacing:0;font-size:11px;color:var(--app-muted);font-weight:400;cursor:pointer;}
  .toggle-inline input{accent-color:var(--app-accent);width:14px;height:14px;cursor:pointer;}

  .style-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:8px;margin-bottom:6px;}
  .style-card{border:1px solid var(--app-line);border-radius:3px;padding:10px 6px;text-align:center;cursor:pointer;background:#0a0f0a;}
  .style-card.active{border-color:var(--app-accent);}
  .style-swatch{width:100%;height:30px;border-radius:2px;margin-bottom:6px;}
  .style-card .name{font-size:10px;color:var(--app-muted);letter-spacing:.03em;}
  .style-card.active .name{color:var(--app-text);}

  .imgrow{display:flex;gap:8px;align-items:center;}
  .filebtn{font-family:var(--ui-mono);font-size:11px;background:#0b1c10;border:1px solid var(--app-line);color:var(--app-accent);padding:8px 10px;border-radius:1px;cursor:pointer;flex:1;text-align:center;}
  .clearbtn{background:transparent;border:1px solid var(--app-line);color:var(--app-muted);font-size:11px;padding:8px 10px;border-radius:1px;cursor:pointer;font-family:var(--ui-mono);}

  .download-btn{width:100%;margin-top:10px;background:var(--app-accent);color:#03170a;border:none;font-family:var(--ui-mono);font-weight:700;font-size:13px;padding:13px;border-radius:1px;cursor:pointer;}
  .download-btn.ghost{background:transparent;border:1px solid var(--app-accent);color:var(--app-accent);}
  .download-btn:disabled{opacity:.4;cursor:not-allowed;}

  .swatches{display:flex;flex-wrap:wrap;gap:8px;align-items:center;}
  .swatch{width:24px;height:24px;border-radius:50%;border:2px solid transparent;cursor:pointer;padding:0;}
  .swatch.active{border-color:var(--app-text);box-shadow:0 0 0 2px #000;}
  .swatch-custom{width:24px;height:24px;border-radius:50%;border:2px solid var(--app-line);padding:0;cursor:pointer;overflow:hidden;}
  .swatch-custom::-webkit-color-swatch-wrapper{padding:0;}
  .swatch-custom::-webkit-color-swatch{border:none;border-radius:50%;}

  .slidebar{display:flex;gap:8px;overflow-x:auto;padding-bottom:6px;max-width:100%;}
  .slidechip{flex:0 0 auto;font-size:11px;padding:7px 12px;border-radius:1px;border:1px solid var(--app-line);background:#0a0f0a;color:var(--app-muted);cursor:pointer;white-space:nowrap;}
  .slidechip.active{border-color:var(--app-accent);color:var(--app-accent);}
  .slidechip .x{margin-left:8px;color:var(--app-muted);}
  .slidechip .x:hover{color:#ff5c5c;}
  .addslide{flex:0 0 auto;font-size:11px;padding:7px 12px;border-radius:1px;border:1px dashed var(--app-accent);background:transparent;color:var(--app-accent);cursor:pointer;}

  .frame-label{font-size:11px;color:var(--app-muted);letter-spacing:.08em;}
  .preview-frame{position:relative;overflow:hidden;border:1px solid var(--app-line);background:#000;}
  .empty-note{color:var(--app-muted);font-size:12px;text-align:left;max-width:280px;}
  footer.tip{padding:14px 20px;border-top:1px solid var(--app-line);color:var(--app-muted);font-size:11px;background:var(--app-panel);}
  footer.tip strong{color:var(--app-accent);}

  /* ============================================================ */
  /* STAGE — o conteúdo exportado. Tudo aqui usa as var(--s-*)     */
  /* ============================================================ */
  .stage{position:relative;background:var(--s-bg);color:var(--s-text);overflow:hidden;font-family:var(--s-body);}
  .stage.grid-on{background-image:linear-gradient(rgba(255,255,255,.05) 1px, transparent 1px),linear-gradient(90deg, rgba(255,255,255,.05) 1px, transparent 1px);background-size:36px 36px;}

  /* frame: technical (cantos + label) */
  .fcorner{position:absolute;width:26px;height:26px;border:2px solid var(--s-accent);opacity:.9;}
  .fcorner.tl{top:14px;left:14px;border-right:none;border-bottom:none;}
  .fcorner.tr{top:14px;right:14px;border-left:none;border-bottom:none;}
  .fcorner.bl{bottom:14px;left:14px;border-right:none;border-top:none;}
  .fcorner.br{bottom:14px;right:14px;border-left:none;border-top:none;}
  .dim-label{position:absolute;bottom:16px;right:20px;color:var(--s-muted);letter-spacing:.08em;}

  /* frame: line (regua dupla, elegante) */
  .frame-line-top, .frame-line-bottom{position:absolute;left:0;right:0;height:0;border-top:3px double var(--s-accent);}
  .frame-line-top{top:0;} .frame-line-bottom{bottom:0;}

  /* frame: none + bloco geométrico decorativo (moderno) */
  .accent-blob{position:absolute;border-radius:999px;background:var(--s-accent);opacity:.14;filter:blur(2px);}

  .win-chrome{display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--s-accent-deep);}
  .win-dots{display:flex;gap:7px;}
  .win-dots .dot{border-radius:50%;display:inline-block;}
  .win-dots .dot.red{background:#ff5f56;} .win-dots .dot.amber{background:#ffc107;} .win-dots .dot.green{background:var(--s-accent);}
  .win-title{color:var(--s-muted);letter-spacing:.04em;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-family:var(--s-body);}
  .win-status{display:flex;align-items:center;color:var(--s-accent);letter-spacing:.06em;white-space:nowrap;font-family:var(--s-body);}
  .win-status .pulse{border-radius:50%;background:var(--s-accent);display:inline-block;}

  .eyebrow{color:var(--s-muted);letter-spacing:.16em;text-transform:uppercase;font-weight:500;font-family:var(--s-body);}
  .headline{color:var(--s-accent);font-family:var(--s-head);line-height:.98;letter-spacing:.005em;}
  .headline.glow{text-shadow:0 0 24px var(--s-glow);}
  .headline.upper{text-transform:uppercase;}
  .sub{color:var(--s-text);font-weight:700;line-height:1.25;font-family:var(--s-body);}
  .sub.accent2{color:var(--s-accent);}
  .sub.upper{text-transform:uppercase;}

  .termbox{border:1px solid var(--s-accent-deep);background:var(--s-termbox-bg);position:relative;}
  .stage.frame-none .termbox{border:none;border-radius:6px;}
  .termbox .cmd{color:var(--s-accent);font-family:var(--s-body);}
  .termbox .body{color:var(--s-text);font-family:var(--s-body);}
  .termbox .body strong{color:var(--s-accent);font-weight:700;}
  .termbox .tags{color:var(--s-muted);font-family:var(--s-body);}
  .termbox .tags strong{color:var(--s-accent);font-weight:600;}

  .photo-frame{position:relative;border:1px solid var(--s-accent-deep);background:#0a0f0b;overflow:hidden;display:flex;align-items:center;justify-content:center;}
  .stage.frame-none .photo-frame, .stage.frame-line .photo-frame{border:none;border-radius:8px;}
  .photo-frame img{width:100%;height:100%;object-fit:cover;display:block;}
  .photo-frame .placeholder{color:var(--s-accent-deep);text-align:center;font-size:13px;letter-spacing:.08em;font-family:var(--s-body);}
  .photo-frame.tone-scan img{filter:grayscale(40%) contrast(1.1) brightness(.95);}
  .photo-frame.tone-scan .overlay{position:absolute;inset:0;pointer-events:none;background:repeating-linear-gradient(to bottom, rgba(0,0,0,0) 0px, rgba(0,0,0,0) 2px, rgba(0,0,0,.35) 3px, rgba(0,0,0,0) 4px), var(--s-scan-tint);mix-blend-mode:multiply;}
  .photo-frame.tone-mono img{filter:grayscale(100%) contrast(1.08);}
  .photo-frame.tone-duo img{filter:grayscale(100%) contrast(1.15);}
  .photo-frame.tone-duo .overlay{position:absolute;inset:0;pointer-events:none;background:var(--s-accent);mix-blend-mode:color;opacity:.55;}
  .photo-caption{color:var(--s-muted);text-align:center;letter-spacing:.05em;font-family:var(--s-body);}

  .btnrow{display:flex;}
  .cta{font-weight:700;text-align:center;display:flex;align-items:center;justify-content:center;gap:.4em;font-family:var(--s-body);}
  .cta .bracket{opacity:.55;}
  /* button style: bracket (terminal) */
  .cta.style-bracket.fill{background:var(--s-accent);color:var(--s-bg);}
  .cta.style-bracket.outline{background:transparent;color:var(--s-accent);border:1px solid var(--s-accent);}
  /* button style: underline (editorial) */
  .cta.style-underline{background:transparent;border:none;border-bottom:2px solid var(--s-accent);border-radius:0;letter-spacing:.08em;text-transform:uppercase;padding-left:0;padding-right:0;}
  .cta.style-underline.fill{color:var(--s-accent);}
  .cta.style-underline.outline{color:var(--s-text);border-bottom-color:var(--s-muted);}
  /* button style: pill (moderno) */
  .cta.style-pill{border-radius:999px;}
  .cta.style-pill.fill{background:var(--s-accent);color:var(--s-bg);}
  .cta.style-pill.outline{background:transparent;color:var(--s-text);border:2px solid var(--s-text);}

  .content-heading{color:var(--s-accent);font-family:var(--s-head);line-height:1.05;}
  .content-heading.glow{text-shadow:0 0 20px var(--s-glow);}
  .content-body{color:var(--s-text);font-family:var(--s-body);}
  .content-body strong{color:var(--s-accent);}
  .slidecount{color:var(--s-muted);letter-spacing:.08em;font-family:var(--s-body);}
  .content-eyebrow{color:var(--s-muted);letter-spacing:.15em;text-transform:uppercase;font-family:var(--s-body);}
</style>
</head>
<body>
<div class="app">
  <div class="topbar">
    <div class="logo">$ <span>gerador_universal</span> --brand=custom<span class="cursor"></span></div>
    <div class="format-tabs" id="formatTabs">
      <button data-fmt="post" class="active">POST</button>
      <button data-fmt="story">STORY</button>
      <button data-fmt="carousel">CARROSSEL</button>
    </div>
  </div>
  <div class="workspace">
    <aside class="panel" id="panel"></aside>
    <section class="stage-area" id="stageArea"></section>
  </div>
  <footer class="tip"><strong>Dica:</strong> o Estilo define a personalidade (cores, moldura, botão); a Tipografia e o Layout você pode trocar livremente por cima, sem quebrar a identidade.</footer>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script>
/* ===================== ESTILOS (presets de identidade visual) ===================== */
const STYLE_PRESETS = {
  terminal: {
    name:"Terminal", swatch:"#00FF66",
    bg:"#050805", accent:"#00FF66", frame:"technical", button:"bracket",
    grid:true, glow:true, photoTone:"scan", fontPair:"mono", align:"left",
    usePhotoDefault:false, layoutDefault:"stacked", chrome:true
  },
  editorial: {
    name:"Editorial", swatch:"#F2C230",
    bg:"#0d0d0d", accent:"#F2C230", frame:"line", button:"underline",
    grid:false, glow:false, photoTone:"mono", fontPair:"serif", align:"left",
    usePhotoDefault:true, layoutDefault:"side", chrome:false
  },
  moderno: {
    name:"Moderno", swatch:"#FF5A36",
    bg:"#12131a", accent:"#FF5A36", frame:"none", button:"pill",
    grid:false, glow:false, photoTone:"duo", fontPair:"geometric", align:"center",
    usePhotoDefault:true, layoutDefault:"stacked", chrome:false
  }
};
const FONT_PAIRS = {
  mono:      { name:"Mono terminal",     head:"'Share Tech Mono', monospace",  body:"'IBM Plex Mono', monospace" },
  serif:     { name:"Serif editorial",   head:"'Playfair Display', serif",     body:"'Inter', sans-serif" },
  geometric: { name:"Geométrica",        head:"'Space Grotesk', sans-serif",   body:"'Inter', sans-serif" },
  friendly:  { name:"Amigável",          head:"'Poppins', sans-serif",         body:"'Roboto', sans-serif" }
};

/* ===================== DADOS PADRÃO ===================== */
function defaultCoverFields(preset){
  const p = STYLE_PRESETS[preset];
  return {
    eyebrow: "// POSICIONAMENTO EM UMA LINHA",
    headline: "TÍTULO",
    sub1: "SUBTÍTULO DE APOIO",
    sub2: "SEGUNDA LINHA",
    command: "./sobre --resumo",
    body: "Escreva aqui a proposta central: o que você entrega e por que isso importa **agora** pro seu público.",
    tags: "Prova social: **cliente 1**, **cliente 2**, **cliente 3**.",
    cta1: "QUERO_SABER_MAIS",
    cta2: "VER_DETALHES",
    imageData: null,
    caption: "FOTO.jpg",
    usePhoto: p.usePhotoDefault,
    useCta: true,
    layout: p.layoutDefault
  };
}
function defaultContentSlide(){
  return { type:"content", eyebrow:"// PONTO-CHAVE", heading:"Uma frase\nforte por\nslide.", body:"Complemento curto que reforça a ideia principal **em destaque**.", footnote:"@seu.perfil" };
}

const state = {
  format:"post",
  style:{ preset:"terminal", accent: STYLE_PRESETS.terminal.accent, bg: STYLE_PRESETS.terminal.bg, fontPair: STYLE_PRESETS.terminal.fontPair, align: STYLE_PRESETS.terminal.align },
  post: defaultCoverFields("terminal"),
  story: { active:0, slides:[ Object.assign({type:"cover"}, defaultCoverFields("terminal")) ] },
  carousel: { active:0, slides:[ Object.assign({type:"cover"}, defaultCoverFields("terminal")), defaultContentSlide(), defaultContentSlide() ] }
};

const SIZES = {
  post:{w:1080,h:1080,label:"1080 × 1080"},
  story:{w:1080,h:1920,label:"1080 × 1920"},
  carousel:{w:1080,h:1350,label:"1080 × 1350"}
};
const SEQUENCE_CONFIG = {
  story:{ filePrefix:"story", label:"Story", zipName:"stories.zip" },
  carousel:{ filePrefix:"slide", label:"Carrossel", zipName:"carrossel.zip" }
};

/* ===================== HELPERS ===================== */
function esc(s){ return (s||"").replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;"); }
function md(s){ return esc(s).replace(/\*\*(.+?)\*\*/g,"<strong>$1</strong>").replace(/\n/g,"<br>"); }
function hexToRgb(hex){ const m=hex.replace("#",""); return {r:parseInt(m.substr(0,2),16), g:parseInt(m.substr(2,2),16), b:parseInt(m.substr(4,2),16)}; }
function mixHex(a,b,amt){ const A=hexToRgb(a),B=hexToRgb(b); const r=Math.round(A.r+(B.r-A.r)*amt),g=Math.round(A.g+(B.g-A.g)*amt),bl=Math.round(A.b+(B.b-A.b)*amt); return "#"+[r,g,bl].map(v=>v.toString(16).padStart(2,"0")).join(""); }
function luminance(hex){ const {r,g,b}=hexToRgb(hex); return (0.299*r+0.587*g+0.114*b)/255; }

// calcula todas as variáveis --s-* a partir do estado de estilo atual
function computeThemeVars(){
  const st = state.style;
  const isDark = luminance(st.bg) < 0.5;
  const text = isDark ? mixHex(st.bg, "#ffffff", 0.92) : mixHex(st.bg, "#000000", 0.92);
  const muted = isDark ? mixHex(st.bg, "#ffffff", 0.45) : mixHex(st.bg, "#000000", 0.45);
  const accentDim = mixHex(st.accent, st.bg, 0.3);
  const accentDeep = mixHex(st.accent, st.bg, 0.62);
  const {r,g,b} = hexToRgb(st.accent);
  const fp = FONT_PAIRS[st.fontPair];
  return `--s-bg:${st.bg};--s-text:${text};--s-muted:${muted};--s-accent:${st.accent};--s-accent-dim:${accentDim};--s-accent-deep:${accentDeep};--s-glow:rgba(${r},${g},${b},.4);--s-termbox-bg:rgba(${r},${g},${b},.07);--s-scan-tint:rgba(${r},${g},${b},.08);--s-head:${fp.head};--s-body:${fp.body};`;
}
function presetOf(){ return STYLE_PRESETS[state.style.preset]; }

function technicalFrame(w,h,frame){
  if(frame==="technical"){
    return `<div class="fcorner tl"></div><div class="fcorner tr"></div><div class="fcorner bl"></div><div class="fcorner br"></div>
      <div class="dim-label" style="font-size:${Math.round(w*0.013)}px;">${w}×${h}</div>`;
  }
  if(frame==="line"){
    return `<div class="frame-line-top"></div><div class="frame-line-bottom"></div>`;
  }
  return `<div class="accent-blob" style="width:${Math.round(w*0.55)}px;height:${Math.round(w*0.55)}px;top:${Math.round(h*-0.15)}px;right:${Math.round(w*-0.2)}px;"></div>`;
}
function windowChrome(w, title, status){
  const dot = Math.round(w*0.011), fs = Math.round(w*0.0155);
  return `<div class="win-chrome" style="padding:0 0 ${Math.round(w*0.018)}px 0;margin-bottom:${Math.round(w*0.03)}px;">
    <div style="display:flex;align-items:center;gap:${Math.round(w*0.02)}px;">
      <div class="win-dots"><span class="dot red" style="width:${dot}px;height:${dot}px;"></span><span class="dot amber" style="width:${dot}px;height:${dot}px;"></span><span class="dot green" style="width:${dot}px;height:${dot}px;"></span></div>
      <div class="win-title" style="font-size:${fs}px;">${esc(title)}</div>
    </div>
    <div class="win-status" style="font-size:${fs}px;"><span class="pulse" style="width:${Math.round(w*0.009)}px;height:${Math.round(w*0.009)}px;margin-right:${Math.round(w*0.008)}px;"></span>${esc(status)}</div>
  </div>`;
}

/* ===================== STAGE RENDERERS ===================== */
function coverStageHTML(f, w, h, isVerticalFormat){
  const p = presetOf();
  const pad = Math.round(w*0.058);
  const align = state.style.align;
  const alignItems = align==="center" ? "center" : "flex-start";
  const textAlign = align==="center" ? "center" : "left";
  const headSize = Math.round(w*(f.usePhoto && f.layout==="side" && !isVerticalFormat ? 0.10 : 0.125));
  const subSize = Math.round(w*0.03);
  const eyeSize = Math.round(w*0.017);
  const bodySize = Math.round(w*0.0195);
  const headlineClasses = ["headline", p.glow?"glow":"", p.preset==="terminal"?"upper":""].filter(Boolean).join(" ");
  const subClasses = ["sub", p.preset==="terminal"?"upper":""].filter(Boolean).join(" ");

  const textBlock = `
    <div style="display:flex;flex-direction:column;align-items:${alignItems};text-align:${textAlign};width:100%;">
      <div class="eyebrow" style="font-size:${eyeSize}px;margin-bottom:${Math.round(h*0.02)}px;">${esc(f.eyebrow)}</div>
      <div class="${headlineClasses}" style="font-size:${headSize}px;">${esc(f.headline)}</div>
      <div class="${subClasses} accent2" style="font-size:${subSize}px;margin-top:${Math.round(h*0.026)}px;">${esc(f.sub1)}</div>
      <div class="${subClasses}" style="font-size:${subSize}px;margin-top:${Math.round(h*0.006)}px;">${esc(f.sub2)}</div>
    </div>`;

  const termBlock = `
    <div class="termbox" style="padding:${Math.round(w*0.026)}px;margin-top:${Math.round(h*0.03)}px;border-radius:${p.frame==="none"?"8px":"0"};text-align:${textAlign};">
      <div class="cmd" style="font-size:${bodySize}px;margin-bottom:${Math.round(w*0.016)}px;">${p.preset==="terminal" ? "$ "+esc(f.command) : esc(f.command)}</div>
      <div class="body" style="font-size:${bodySize}px;line-height:1.55;">${md(f.body)}</div>
      ${f.tags ? `<div class="tags" style="font-size:${bodySize}px;line-height:1.55;margin-top:${Math.round(w*0.014)}px;">${md(f.tags)}</div>` : ""}
    </div>`;

  const ctaBlock = f.useCta===false ? "" : `
    <div class="btnrow" style="margin-top:${Math.round(h*0.032)}px;gap:${Math.round(w*0.014)}px;justify-content:${align==="center"?"center":"flex-start"};">
      <div class="cta style-${p.button} fill" style="padding:${Math.round(w*0.02)}px ${Math.round(w*0.028)}px;font-size:${Math.round(w*0.017)}px;">
        ${p.button==="bracket" ? `<span class="bracket">[</span>ENTER<span class="bracket">]</span> ` : ""}${esc(f.cta1)}
      </div>
      <div class="cta style-${p.button} outline" style="padding:${Math.round(w*0.02)}px ${Math.round(w*0.028)}px;font-size:${Math.round(w*0.017)}px;">
        ${p.button==="bracket" ? `<span class="bracket">[</span>&gt;<span class="bracket">]</span> ` : ""}${esc(f.cta2)}
      </div>
    </div>`;

  const chrome = p.chrome ? windowChrome(w, "root@marca:~$ " + (isVerticalFormat?"./story.sh":"./post.sh"), "ONLINE") : "";
  const frameMarks = technicalFrame(w,h,p.frame);

  function photoBlock(pw, ph){
    return `<div style="width:${pw}px;">
      <div class="photo-frame tone-${p.photoTone}" style="width:${pw}px;height:${ph}px;">
        ${f.imageData ? `<img src="${f.imageData}"><div class="overlay"></div>` : `<div class="placeholder">[ SEM IMAGEM ]<br>envie uma foto no painel</div>`}
      </div>
      <div class="photo-caption" style="font-size:${Math.round(w*0.0135)}px;margin-top:10px;text-align:${textAlign};">${p.preset==="terminal"?`[ ${esc(f.caption)} ]`:esc(f.caption)}</div>
    </div>`;
  }

  const hasPhoto = f.usePhoto !== false;

  if(isVerticalFormat){
    const pw = w - pad*2, ph = Math.round(h*0.36);
    if(hasPhoto){
      return `<div class="stage frame-${p.frame} ${p.grid?"grid-on":""}" style="width:${w}px;height:${h}px;padding:${pad}px;display:flex;flex-direction:column;${computeThemeVars()}">
        ${frameMarks}${chrome}${textBlock}
        <div style="flex:1;display:flex;flex-direction:column;justify-content:center;align-items:center;margin-top:${Math.round(h*0.03)}px;">${photoBlock(pw,ph)}</div>
        ${termBlock}${ctaBlock}
      </div>`;
    }
    // sem foto: centraliza cabeçalho + bloco de texto + cta como um único grupo no espaço vertical disponível
    return `<div class="stage frame-${p.frame} ${p.grid?"grid-on":""}" style="width:${w}px;height:${h}px;padding:${pad}px;display:flex;flex-direction:column;${computeThemeVars()}">
      ${frameMarks}${chrome}
      <div style="flex:1;display:flex;flex-direction:column;justify-content:center;">
        ${textBlock}${termBlock}${ctaBlock}
      </div>
    </div>`;
  }

  if(hasPhoto && f.layout==="side"){
    const pw = Math.round(w*0.4), ph = h - pad*2;
    return `<div class="stage frame-${p.frame} ${p.grid?"grid-on":""}" style="width:${w}px;height:${h}px;padding:${pad}px;display:flex;flex-direction:column;${computeThemeVars()}">
      ${frameMarks}${chrome}
      <div style="display:flex;flex:1;gap:${Math.round(w*0.045)}px;">
        <div style="flex:1;display:flex;flex-direction:column;justify-content:center;">${textBlock}${termBlock}${ctaBlock}</div>
        <div style="display:flex;flex-direction:column;justify-content:center;">${photoBlock(pw,ph)}</div>
      </div>
    </div>`;
  }

  // stacked (com ou sem foto)
  const pw = w - pad*2, ph = Math.round(h*0.32);
  return `<div class="stage frame-${p.frame} ${p.grid?"grid-on":""}" style="width:${w}px;height:${h}px;padding:${pad}px;display:flex;flex-direction:column;${computeThemeVars()}">
    ${frameMarks}${chrome}
    <div style="flex:1;display:flex;flex-direction:column;justify-content:center;">
      ${textBlock}
      ${hasPhoto ? `<div style="display:flex;justify-content:${align==="center"?"center":"flex-start"};margin-top:${Math.round(h*0.03)}px;">${photoBlock(pw,ph)}</div>` : ""}
      ${termBlock}${ctaBlock}
    </div>
  </div>`;
}

function contentStageHTML(f, w, h, index, total){
  const p = presetOf();
  const align = state.style.align;
  const textAlign = align==="center" ? "center" : "left";
  const alignItems = align==="center" ? "center" : "flex-start";
  const pad = Math.round(w*0.075);
  const headSize = Math.round(w*0.072);
  const bodySize = Math.round(w*0.026);
  const eyeSize = Math.round(w*0.018);
  const chrome = p.chrome ? windowChrome(w, `root@marca:~$ ./slide_${String(index).padStart(2,"0")}.sh`, "RUN") : "";
  return `<div class="stage frame-${p.frame} ${p.grid?"grid-on":""}" style="width:${w}px;height:${h}px;padding:${pad}px;display:flex;flex-direction:column;${computeThemeVars()}">
    ${technicalFrame(w,h,p.frame)}${chrome}
    <div class="content-eyebrow" style="font-size:${eyeSize}px;text-align:${textAlign};">${esc(f.eyebrow||"")}</div>
    <div style="flex:1;display:flex;flex-direction:column;justify-content:center;align-items:${alignItems};text-align:${textAlign};">
      <div class="content-heading ${p.glow?'glow':''}" style="font-size:${headSize}px;">${md(f.heading)}</div>
      <div class="content-body" style="font-size:${bodySize}px;line-height:1.6;margin-top:${Math.round(h*0.06)}px;max-width:88%;">${md(f.body)}</div>
    </div>
    <div style="display:flex;justify-content:space-between;align-items:flex-end;">
      <div class="slidecount" style="font-size:${Math.round(w*0.0165)}px;">[ ${esc(f.footnote||"")} ]</div>
      <div class="slidecount" style="font-size:${Math.round(w*0.0165)}px;">[ ${String(index).padStart(2,"0")} / ${String(total).padStart(2,"0")} ]</div>
    </div>
  </div>`;
}
function sequenceSlideHTML(sl, w, h, index, total){
  return sl.type==="cover" ? coverStageHTML(sl, w, h, false) : contentStageHTML(sl, w, h, index, total);
}

/* ===================== PAINEL: ESTILO / TIPOGRAFIA / LAYOUT ===================== */
function styleControlsHTML(){
  const cards = Object.entries(STYLE_PRESETS).map(([key,p])=>{
    const active = state.style.preset===key;
    return `<div class="style-card ${active?'active':''}" data-preset="${key}">
      <div class="style-swatch" style="background:${p.bg};box-shadow:inset 0 0 0 2px ${p.accent};"></div>
      <div class="name">${p.name}</div>
    </div>`;
  }).join("");

  const accentSwatches = ["#00FF66","#F2C230","#FF5A36","#00E5FF","#FF2E9A","#B14CFF"].map(hex=>{
    const active = state.style.accent.toUpperCase()===hex.toUpperCase();
    return `<button class="swatch ${active?'active':''}" data-hex="${hex}" style="background:${hex};"></button>`;
  }).join("");

  const fontOptions = Object.entries(FONT_PAIRS).map(([key,f])=>`<option value="${key}" ${state.style.fontPair===key?"selected":""}>${f.name}</option>`).join("");

  return `
    <div class="section-title">Estilo</div>
    <div class="style-grid">${cards}</div>
    <div class="empty-note" style="margin-bottom:10px;">Escolher um estilo define cor, moldura e botão padrão — você pode sobrescrever tudo abaixo.</div>

    <div class="section-title">Cor de destaque</div>
    <div class="swatches" style="margin-bottom:14px;">
      ${accentSwatches}
      <input type="color" class="swatch-custom" id="accentColor" value="${state.style.accent}" title="Cor personalizada">
    </div>

    <div class="section-title">Cor de fundo</div>
    <div class="swatches" style="margin-bottom:14px;">
      <button class="swatch ${state.style.bg.toUpperCase()==='#050805'?'active':''}" data-bg="#050805" style="background:#050805;border:1px solid #333;"></button>
      <button class="swatch ${state.style.bg.toUpperCase()==='#0D0D0D'?'active':''}" data-bg="#0d0d0d" style="background:#0d0d0d;border:1px solid #333;"></button>
      <button class="swatch ${state.style.bg.toUpperCase()==='#FFFFFF'?'active':''}" data-bg="#ffffff" style="background:#ffffff;"></button>
      <button class="swatch ${state.style.bg.toUpperCase()==='#F5F1E8'?'active':''}" data-bg="#f5f1e8" style="background:#f5f1e8;"></button>
      <input type="color" class="swatch-custom" id="bgColor" value="${state.style.bg}" title="Cor personalizada">
    </div>

    <div class="section-title">Tipografia</div>
    <div class="field"><select id="fontPairSelect">${fontOptions}</select></div>

    <div class="section-title">Layout — alinhamento</div>
    <div class="field">
      <select id="alignSelect">
        <option value="left" ${state.style.align==="left"?"selected":""}>Esquerda</option>
        <option value="center" ${state.style.align==="center"?"selected":""}>Centro</option>
      </select>
    </div>
  `;
}
function bindStyleControls(){
  document.querySelectorAll(".style-card").forEach(card=>{
    card.onclick = ()=>{
      const key = card.dataset.preset;
      const p = STYLE_PRESETS[key];
      state.style.preset = key;
      state.style.accent = p.accent;
      state.style.bg = p.bg;
      state.style.fontPair = p.fontPair;
      state.style.align = p.align;
      // aplica defaults de foto/layout/cta apenas ao slide ativo, sem sobrescrever texto já digitado
      applyPresetDefaultsToActiveSlide(p);
      renderPanel(); renderStage();
    };
  });
  document.querySelectorAll(".swatch[data-hex]").forEach(sw=>{
    sw.onclick = ()=>{ state.style.accent = sw.dataset.hex; renderPanel(); renderStage(); };
  });
  document.querySelectorAll(".swatch[data-bg]").forEach(sw=>{
    sw.onclick = ()=>{ state.style.bg = sw.dataset.bg; renderPanel(); renderStage(); };
  });
  const accentCustom = document.getElementById("accentColor");
  if(accentCustom) accentCustom.oninput = ()=>{ state.style.accent = accentCustom.value; renderStage(); };
  const bgCustom = document.getElementById("bgColor");
  if(bgCustom) bgCustom.oninput = ()=>{ state.style.bg = bgCustom.value; renderStage(); };
  const fontSel = document.getElementById("fontPairSelect");
  if(fontSel) fontSel.onchange = ()=>{ state.style.fontPair = fontSel.value; renderStage(); };
  const alignSel = document.getElementById("alignSelect");
  if(alignSel) alignSel.onchange = ()=>{ state.style.align = alignSel.value; renderStage(); };
}
function activeCoverFieldsForFormat(){
  if(state.format==="post") return state.post;
  const seq = state[state.format];
  const sl = seq.slides[seq.active];
  return sl.type==="cover" ? sl : null;
}
function applyPresetDefaultsToActiveSlide(p){
  const f = activeCoverFieldsForFormat();
  if(!f) return;
  f.usePhoto = p.usePhotoDefault;
  f.layout = p.layoutDefault;
}

/* ===================== FORM: CAPA (headline/termbox/foto/cta) ===================== */
function coverFieldsFormHTML(prefix, f){
  const p = presetOf();
  return `
    <div class="section-title">Cabeçalho</div>
    <div class="field"><label>Eyebrow</label><input type="text" id="${prefix}-eyebrow"></div>
    <div class="field"><label>Título principal</label><input type="text" id="${prefix}-headline"></div>
    <div class="field"><label>Subtítulo linha 1</label><input type="text" id="${prefix}-sub1"></div>
    <div class="field"><label>Subtítulo linha 2</label><input type="text" id="${prefix}-sub2"></div>

    <div class="section-title">Bloco de texto</div>
    <div class="field"><label>Linha de comando/kicker</label><input type="text" id="${prefix}-command"></div>
    <div class="field"><label>Texto principal<span class="hint">use **palavra** para destacar</span></label><textarea id="${prefix}-body"></textarea></div>
    <div class="field"><label>Linha extra (prova social/tags)</label><textarea id="${prefix}-tags"></textarea></div>

    <div class="section-title">
      <span>Foto</span>
      <label class="toggle-inline"><input type="checkbox" id="${prefix}-usePhoto" ${f.usePhoto?"checked":""}>incluir fotografia</label>
    </div>
    ${f.usePhoto ? `
    <div class="field"><label>Disposição</label>
      <select id="${prefix}-layout">
        <option value="stacked" ${f.layout==="stacked"?"selected":""}>Empilhada (foto embaixo)</option>
        <option value="side" ${f.layout==="side"?"selected":""}>Lado a lado</option>
      </select>
    </div>
    <div class="field imgrow">
      <button class="filebtn" id="${prefix}-imgbtn">&gt; upload_imagem.jpg</button>
      <button class="clearbtn" id="${prefix}-imgclear">limpar</button>
    </div>
    <input type="file" accept="image/*" id="${prefix}-imgfile" style="display:none;">
    <div class="field"><label>Legenda da foto</label><input type="text" id="${prefix}-caption"></div>
    ` : `<div class="empty-note" style="margin-bottom:12px;">Sem fotografia — o texto ocupa o espaço todo.</div>`}

    <div class="section-title">
      <span>Botões (CTA)</span>
      <label class="toggle-inline"><input type="checkbox" id="${prefix}-useCta" ${f.useCta?"checked":""}>incluir botões</label>
    </div>
    ${f.useCta ? `
    <div class="field"><label>Botão preenchido</label><input type="text" id="${prefix}-cta1"></div>
    <div class="field"><label>Botão contornado</label><input type="text" id="${prefix}-cta2"></div>
    ` : `<div class="empty-note">Sem botões — Instagram não permite link clicável na imagem; use o Link Sticker do app no story, ou o link da bio no post.</div>`}
  `;
}
function bindCoverForm(prefix, fields, onChange, onToggle){
  const ids = ["eyebrow","headline","sub1","sub2","command","body","tags","caption","cta1","cta2"];
  ids.forEach(k=>{
    const el = document.getElementById(`${prefix}-${k}`);
    if(!el) return;
    el.value = fields[k] || "";
    el.addEventListener("input", ()=>{ fields[k]=el.value; onChange(); });
  });
  const imgbtn = document.getElementById(`${prefix}-imgbtn`);
  if(imgbtn){
    imgbtn.onclick = ()=> document.getElementById(`${prefix}-imgfile`).click();
    document.getElementById(`${prefix}-imgfile`).onchange = (e)=>{
      const file = e.target.files[0]; if(!file) return;
      const reader = new FileReader();
      reader.onload = ()=>{ fields.imageData = reader.result; onChange(); };
      reader.readAsDataURL(file);
    };
    document.getElementById(`${prefix}-imgclear`).onclick = ()=>{ fields.imageData = null; onChange(); };
  }
  const layoutSel = document.getElementById(`${prefix}-layout`);
  if(layoutSel) layoutSel.onchange = ()=>{ fields.layout = layoutSel.value; onChange(); };
  const photoToggle = document.getElementById(`${prefix}-usePhoto`);
  if(photoToggle) photoToggle.onchange = ()=>{ fields.usePhoto = photoToggle.checked; (onToggle||onChange)(); };
  const ctaToggle = document.getElementById(`${prefix}-useCta`);
  if(ctaToggle) ctaToggle.onchange = ()=>{ fields.useCta = ctaToggle.checked; (onToggle||onChange)(); };
}

function contentFieldsFormHTML(prefix){
  return `
    <div class="section-title">Conteúdo do slide</div>
    <div class="field"><label>Eyebrow</label><input type="text" id="${prefix}-eyebrow"></div>
    <div class="field"><label>Frase principal<span class="hint">use quebras de linha pra controlar o ritmo</span></label><textarea id="${prefix}-heading" style="min-height:90px;"></textarea></div>
    <div class="field"><label>Texto de apoio</label><textarea id="${prefix}-body"></textarea></div>
    <div class="field"><label>Rodapé (@ / marca)</label><input type="text" id="${prefix}-footnote"></div>
  `;
}
function bindContentForm(prefix, fields, onChange){
  ["eyebrow","heading","body","footnote"].forEach(k=>{
    const el = document.getElementById(`${prefix}-${k}`);
    if(!el) return;
    el.value = fields[k] || "";
    el.addEventListener("input", ()=>{ fields[k]=el.value; onChange(); });
  });
}

/* ===================== RENDER: PAINEL ===================== */
function renderPanel(){
  const panel = document.getElementById("panel");
  if(state.format==="post"){
    panel.innerHTML = styleControlsHTML() + coverFieldsFormHTML("post", state.post) + `<button class="download-btn" id="downloadBtn">&gt; baixar_post.png</button>`;
    bindStyleControls();
    bindCoverForm("post", state.post, renderStage, ()=>{ renderPanel(); renderStage(); });
    document.getElementById("downloadBtn").onclick = ()=>{
      const s = SIZES.post;
      downloadPNG(coverStageHTML(state.post, s.w, s.h, false), s.w, s.h, "post.png");
    };
  } else {
    renderSequencePanel(state.format);
  }
}
function renderSequencePanel(formatKey){
  const cfg = SEQUENCE_CONFIG[formatKey];
  const panel = document.getElementById("panel");
  const seq = state[formatKey];

  let chips = seq.slides.map((sl,i)=>`<div class="slidechip ${i===seq.active?'active':''}" data-i="${i}">${cfg.filePrefix}_${String(i+1).padStart(2,'0')} ${seq.slides.length>1?`<span class="x" data-del="${i}">×</span>`:''}</div>`).join("");
  chips += `<button class="addslide" id="addSlideBtn">+ slide</button>`;

  panel.innerHTML = styleControlsHTML() + `<div class="section-title">${cfg.label} — sequência</div><div class="slidebar">${chips}</div>`;
  bindStyleControls();

  const active = seq.slides[seq.active];
  const formPrefix = formatKey + "-active";
  const wrap = document.createElement("div");
  wrap.innerHTML = active.type==="cover" ? coverFieldsFormHTML(formPrefix, active) : contentFieldsFormHTML(formPrefix);
  panel.appendChild(wrap);

  const btnRow = document.createElement("div");
  btnRow.innerHTML = `
    <button class="download-btn" id="downloadSlideBtn">&gt; baixar_${cfg.filePrefix}_${String(seq.active+1).padStart(2,'0')}.png</button>
    <button class="download-btn ghost" id="downloadAllBtn">&gt; baixar_todos.zip</button>
  `;
  panel.appendChild(btnRow);

  panel.querySelectorAll(".slidechip").forEach(chip=>{
    chip.onclick = (e)=>{
      if(e.target.dataset.del !== undefined){
        const idx = parseInt(e.target.dataset.del);
        if(seq.slides.length>1){
          seq.slides.splice(idx,1);
          if(seq.active>=seq.slides.length) seq.active = seq.slides.length-1;
          renderPanel(); renderStage();
        }
        return;
      }
      seq.active = parseInt(chip.dataset.i);
      renderPanel(); renderStage();
    };
  });
  document.getElementById("addSlideBtn").onclick = ()=>{
    seq.slides.push(defaultContentSlide());
    seq.active = seq.slides.length-1;
    renderPanel(); renderStage();
  };

  if(active.type==="cover"){
    bindCoverForm(formPrefix, active, renderStage, ()=>{ renderPanel(); renderStage(); });
  } else {
    bindContentForm(formPrefix, active, renderStage);
  }

  document.getElementById("downloadSlideBtn").onclick = ()=>{
    const s = SIZES[formatKey];
    const html = sequenceSlideHTML(active, s.w, s.h, seq.active+1, seq.slides.length);
    downloadPNG(html, s.w, s.h, `${cfg.filePrefix}_${String(seq.active+1).padStart(2,'0')}.png`);
  };
  document.getElementById("downloadAllBtn").onclick = ()=>downloadAllSequence(formatKey);
}

/* ===================== RENDER: STAGE ===================== */
function renderStage(){
  const area = document.getElementById("stageArea");
  area.innerHTML = "";
  if(state.format==="post"){
    const s = SIZES.post;
    const previewW = 460, scale = previewW/s.w, previewH = Math.round(s.h*scale);
    const html = coverStageHTML(state.post, s.w, s.h, false);
    area.innerHTML = `
      <div class="frame-label">Feed — ${s.label}px</div>
      <div class="preview-frame" style="width:${previewW}px;height:${previewH}px;">
        <div style="transform:scale(${scale});transform-origin:top left;width:${s.w}px;height:${s.h}px;">${html}</div>
      </div>`;
  } else {
    renderSequenceStage(state.format);
  }
}
function renderSequenceStage(formatKey){
  const area = document.getElementById("stageArea");
  const cfg = SEQUENCE_CONFIG[formatKey];
  const seq = state[formatKey];
  const s = SIZES[formatKey];
  const previewW = 300, scale = previewW/s.w, previewH = Math.round(s.h*scale);
  const row = document.createElement("div");
  row.style.cssText = "display:flex;gap:22px;flex-wrap:wrap;justify-content:center;";
  seq.slides.forEach((sl,i)=>{
    const isVertical = formatKey==="story";
    const html = sl.type==="cover" ? coverStageHTML(sl, s.w, s.h, isVertical) : contentStageHTML(sl, s.w, s.h, i+1, seq.slides.length);
    const box = document.createElement("div");
    box.style.cssText = "display:flex;flex-direction:column;align-items:center;gap:8px;cursor:pointer;";
    box.innerHTML = `
      <div class="frame-label">${cfg.filePrefix}_${String(i+1).padStart(2,'0')} ${i===seq.active?'· editando':''}</div>
      <div class="preview-frame" style="width:${previewW}px;height:${previewH}px;${i===seq.active?'outline:2px solid var(--app-accent);':''}">
        <div style="transform:scale(${scale});transform-origin:top left;width:${s.w}px;height:${s.h}px;">${html}</div>
      </div>`;
    box.onclick = ()=>{ seq.active=i; renderPanel(); renderStage(); };
    row.appendChild(box);
  });
  area.innerHTML = `<div class="frame-label">${cfg.label} — ${s.label}px por slide</div>`;
  area.appendChild(row);
}

/* ===================== EXPORT ===================== */
function downloadPNG(html, w, h, filename){
  const off = document.createElement("div");
  off.style.cssText = `position:absolute;left:0;top:0;width:${w}px;height:${h}px;opacity:0;pointer-events:none;z-index:-1;overflow:hidden;`;
  off.innerHTML = html;
  document.body.appendChild(off);
  document.fonts.ready.then(()=>new Promise(r=>setTimeout(r,50))).then(()=>{
    return html2canvas(off.firstElementChild, { width:w, height:h, windowWidth:w, windowHeight:h, backgroundColor:state.style.bg, scale:1, useCORS:true, allowTaint:true, logging:false });
  }).then(canvas=>{
    const link = document.createElement("a");
    link.download = filename; link.href = canvas.toDataURL("image/png");
    document.body.appendChild(link); link.click(); link.remove();
  }).catch(err=>{
    console.error("Falha ao gerar PNG:", err);
    alert("Deu ruim ao gerar a imagem: " + err.message + "\nAbre o console (F12) pra ver o erro completo.");
  }).finally(()=>{ document.body.removeChild(off); });
}
async function downloadAllSequence(formatKey){
  const cfg = SEQUENCE_CONFIG[formatKey];
  const seq = state[formatKey];
  const s = SIZES[formatKey];
  const btn = document.getElementById("downloadAllBtn");
  btn.disabled = true; btn.textContent = "gerando...";
  try{
    await document.fonts.ready;
    const zip = new JSZip();
    for(let i=0;i<seq.slides.length;i++){
      const sl = seq.slides[i];
      const isVertical = formatKey==="story";
      const html = sl.type==="cover" ? coverStageHTML(sl, s.w, s.h, isVertical) : contentStageHTML(sl, s.w, s.h, i+1, seq.slides.length);
      const off = document.createElement("div");
      off.style.cssText = `position:absolute;left:0;top:0;width:${s.w}px;height:${s.h}px;opacity:0;pointer-events:none;z-index:-1;overflow:hidden;`;
      off.innerHTML = html;
      document.body.appendChild(off);
      await new Promise(r=>setTimeout(r,50));
      const canvas = await html2canvas(off.firstElementChild, { width:s.w, height:s.h, windowWidth:s.w, windowHeight:s.h, backgroundColor:state.style.bg, scale:1, useCORS:true, allowTaint:true, logging:false });
      document.body.removeChild(off);
      const dataUrl = canvas.toDataURL("image/png").split(",")[1];
      zip.file(`${cfg.filePrefix}_${String(i+1).padStart(2,'0')}.png`, dataUrl, {base64:true});
    }
    const content = await zip.generateAsync({type:"blob"});
    const link = document.createElement("a");
    link.href = URL.createObjectURL(content); link.download = cfg.zipName;
    document.body.appendChild(link); link.click(); link.remove();
  } catch(err){
    console.error("Falha ao gerar ZIP:", err);
    alert("Deu ruim ao gerar o ZIP: " + err.message + "\nAbre o console (F12) pra ver o erro completo.");
  } finally {
    btn.disabled = false; btn.textContent = "> baixar_todos.zip";
  }
}

/* ===================== FORMAT SWITCH + INIT ===================== */
document.getElementById("formatTabs").addEventListener("click",(e)=>{
  const btn = e.target.closest("button"); if(!btn) return;
  document.querySelectorAll("#formatTabs button").forEach(b=>b.classList.remove("active"));
  btn.classList.add("active");
  state.format = btn.dataset.fmt;
  renderPanel(); renderStage();
});
renderPanel();
renderStage();
</script>
</body>
</html>
