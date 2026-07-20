# Content Forge

Gerador de conteúdo estático para Instagram — Post, Story e Carrossel — com escolha livre de **estilo**, **tipografia** e **layout**. Sem backend, sem build, um único `index.html`.

## Estilos prontos

| Estilo | Visual | Fonte padrão |
|---|---|---|
| **Terminal** | Fundo preto, grid verde, moldura técnica, chrome de janela de sistema, botão `[ ENTER ]` | Share Tech Mono + IBM Plex Mono |
| **Editorial** | Preto/âmbar, moldura de régua dupla, botão sublinhado | Playfair Display + Inter |
| **Moderno** | Bold, bloco geométrico decorativo, botão em pílula | Space Grotesk + Inter |

Escolher um estilo define cor, moldura e botão de uma vez — mas tudo pode ser sobrescrito depois.

## O que dá pra customizar

- **Tipografia**: 4 pares de fonte, trocáveis independente do estilo (Mono, Serif editorial, Geométrica, Amigável)
- **Cor**: paleta de destaque + cor de fundo, ambas com seletor livre (contraste do texto se ajusta automaticamente)
- **Layout**: alinhamento (esquerda/centro), foto opcional por slide, disposição empilhada ou lado a lado, botões de CTA opcionais

## Formatos

- **Post** — 1080×1080
- **Story** — 1080×1920, sequência ilimitada de slides
- **Carrossel** — 1080×1350, sequência ilimitada de slides

Cada slide de Story/Carrossel pode ser uma capa (título + texto + foto) ou um slide de conteúdo (frase + numeração).

## Como usar

Abra o `index.html` no navegador — não precisa de servidor nem instalação.

## Publicar no GitHub Pages

1. Suba este repositório no GitHub
2. Settings → Pages → Source: branch `main`, pasta `/root`
3. O link fica em `https://SEU_USUARIO.github.io/content-forge/`

## Stack

HTML, CSS e JavaScript puro. Exportação de imagem via [html2canvas](https://github.com/niklasvh/html2canvas) e ZIP via [JSZip](https://github.com/Stuk/jszip), carregados via CDN (cdnjs).

## Limitações

Os botões de CTA são apenas visuais — Instagram não permite link clicável dentro de imagem de post ou story. Para link funcional em story, use o Link Sticker nativo do app depois de publicar; para post, o link da bio.
