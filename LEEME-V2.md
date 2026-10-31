# ARKHE 3D · v2

Catálogo de 12 productos impresos en 3D con evidencia de mercado, precios y márgenes en USD, fichas A4 para imprimir y un agente que prepara la publicación para WhatsApp, Instagram, Facebook y TikTok.

> **Estado:** catálogo y agente probados en seco (dry-run). La publicación real no se probó porque no hay credenciales ni video. Nada se publica sin `--confirmar`.

## Arranque rápido

Requisitos: Node.js 20 o superior, Chrome o Edge instalados (para el PDF) y `playwright-core`.

```bash
npm install
npm run catalogo:v2     # genera catálogo, fichas, CSV, stock y órdenes de trabajo
npm run pdf:v2          # exporta catalogo-v2/fichas-para-imprimir.pdf (12 páginas A4)
npm run agente:listar   # tabla de costos, precios y márgenes
npm run panel           # regenera agente-publicador/panel.html
```

Abrí con doble clic:

- `catalogo-v2/index.html` — catálogo visual con filtros, evidencia, precio y copy por canal.
- `catalogo-v2/fichas.html` — fichas A4 (también en PDF).
- `agente-publicador/panel.html` — panel de precios, copys y cola de publicaciones.

## Qué hay en el catálogo

12 SKU, todos con licencia **VERDE** (dominio público, CC BY o CC BY-SA):

| Línea | Productos |
|---|---|
| Dragones | Dragón de Cristal, Dragón Glow, Pack 6 Mini Dragones, Huevo de Dragón |
| Fidgets | Pack 6 Huevos Twist, Mini Dragón Llavero, Fidget Star, Pulpo Flexi |
| Deco y hogar | Lámpara Luna Litofanía, Soporte de Celular, Maceta Ribbed |
| Personalizados | Llavero con Nombre |

Cada SKU incluye: link al modelo original, foto de referencia, descripción, precio, costo, margen, licencia, crédito, evidencia de mercado, guion de video, copy para los cuatro canales y riesgos de producción.

Archivos generados:

- `catalogo-v2/productos.json` — datos enriquecidos con precios calculados.
- `catalogo-v2/catalogo.csv` — planilla para Excel o Google Sheets.
- `catalogo-v2/plan-de-stock.md` — stock mínimo, lote y primera tanda.
- `catalogo-v2/ordenes/OT-001..003` — órdenes de trabajo listas para imprimir.
- `investigacion/evidencia-2026-10-25.md` — evidencia, correcciones y descartes.

## Cómo se calcula el precio

El motor vive en `sistema/precios.mjs` y lo usan el catálogo y el agente, así no hay dos precios distintos.

Incluye: material, energía, desgaste de la impresora, depreciación de la máquina, mano de obra de post-proceso, empaque, tasa de fallos, componentes, comisión del canal, margen objetivo y ancla de mercado.

Regla: se toma el mayor entre el precio técnico y el 85% del ancla de mercado observada, y se redondea a `.99`. El resultado es un precio sugerido, no una obligación.

Los precios están en **USD**. El ARS solo aparece si configurás `tipo_cambio_usd` en `sistema/config-v2.json`; por defecto vale `0` y el sistema no inventa un tipo de cambio.

## Agente publicador

### Probar sin publicar

```bash
# Un producto, un canal
npm run agente -- --producto fidget-star --canal WhatsApp

# Todos los SKU en los cuatro canales (dry-run)
npm run agente -- --todos --canal WhatsApp,Instagram,Facebook,TikTok

# Un pack
npm run agente -- --producto fidget-star --canal Instagram --pack fidget-star-x3

# Ajustar margen o precio
npm run agente -- --producto dragon-cristal --canal TikTok --margen 0.65
npm run agente -- --producto dragon-cristal --canal WhatsApp --precio 24.99
```

Sin `--confirmar`, el agente nunca llama a una API: calcula, arma el copy, encola el trabajo y genera el enlace de WhatsApp.

### Publicar de verdad

1. Copiá `agente-publicador/.env.example` a `agente-publicador/.env`.
2. Completá solo los canales que vas a usar.
3. Publicá con `--confirmar`:

```bash
npm run agente -- --producto fidget-star --canal WhatsApp --confirmar
npm run agente -- --producto lampara-luna --canal Instagram --confirmar
npm run agente -- --producto dragon-glow --canal TikTok --video-url https://.../video.mp4 --confirmar
```

Si falta una credencial o un asset, el trabajo queda en estado `manual` con el detalle de lo que falta. **Nunca** se marca como `publicado` sin una respuesta real de la API.

### Credenciales por canal

| Canal | Variables | Requisito extra |
|---|---|---|
| WhatsApp | `WHATSAPP_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID`, `WHATSAPP_TO`, `WHATSAPP_NUMERO` | Número de WhatsApp Business Cloud API |
| Instagram | `META_ACCESS_TOKEN`, `IG_USER_ID` | Cuenta profesional; imagen en URL pública HTTPS |
| Facebook | `FB_PAGE_TOKEN`, `FB_PAGE_ID` | Página de Facebook; imagen pública para publicar foto |
| TikTok | `TIKTOK_ACCESS_TOKEN` | Video público HTTPS (`--video-url` o `TIKTOK_VIDEO_URL`) |

Para Instagram, Facebook y WhatsApp con imagen, `URL_PUBLICA_BASE` debe apuntar a la carpeta `catalogo-v2/img` publicada por HTTPS, sin barra final. Ejemplo: `https://tudominio.com/arkhe/catalogo-v2/img`.

TikTok no acepta una foto: necesita un video. El agente no lo genera; el guion está en cada ficha y en `productos.json`.

### Cola y panel

La cola está en `agente-publicador/cola.json` (últimos 200 trabajos). El panel es de solo lectura sobre la cola.

```bash
npm run panel                                  # regenerar panel
npm run agente -- --limpiar                    # vaciar cola y regenerar panel
```

Estados posibles: `dry-run`, `publicado`, `manual`, `error`.

## Semáforo legal

- **VERDE** — se puede vender la impresión con el crédito visible. Es el caso de los 12 SKU.
- **AMARILLO** — requiere comprar licencia comercial antes de vender.
- **ROJO** — no vender.

Reglas:

1. Mantené el crédito del autor y el link al modelo en la ficha y en el copy.
2. No redistribuyas los archivos STL. El catálogo linkea la página original; no incluye los modelos.
3. Si modificás un modelo CC BY-SA, la versión modificada mantiene la misma licencia.
4. Las fotos actuales son de los creadores y se usan como referencia interna. **Antes de publicar, sacá fotos propias del producto impreso.**
5. Los personalizados se cobran por adelantado y el nombre se confirma por escrito.

## Evidencia y límites

- **TikTok Shop:** 71 registros recolectados. Se usó `r.jina.ai` para leer las páginas públicas. Las ventas son las que muestra la plataforma; no son una auditoría.
- **Amazon:** 96 registros. Los datos de “comprado en el último mes” son públicos y cambian todos los días.
- **MercadoLibre:** bloqueado. La API devuelve 403 y las páginas redirigen al login. Solo quedan 6 URLs de publicaciones activas; no hay precio ni vendidos por producto. Para completar este canal hace falta una sesión o un token de API.
- **Instagram y Etsy:** acceso directo bloqueado (403/login).
- La evidencia es de categoría, no de una venta exacta del mismo modelo. Cada ficha muestra la referencia concreta: por ejemplo, “dragón articulado 90 cm” o “soporte de celular (categoría)”.
- `fidget-star` es el best seller absoluto (155.700 vendidos). `dragon-cristal` es el ancla de ticket (28.100 a USD 27,73). `soporte-celular` tiene demanda masiva, pero no exclusiva de impresión 3D.
- El dragón de 50 cm se descartó: el ancla es USD 27,73 y 350 g / 17 h no cubren el costo con margen en Argentina.
- El `cake-topper` se descartó: las 1.900 ventas aparentes eran decoración de fruta, no 3D.

## Flujo de producción recomendado

1. **Validar demanda con 4 SKU:** Fidget Star, Dragón de Cristal, Huevo de Dragón y Pack 6 Huevos Twist (OT-001).
2. Imprimir la primera tanda y registrar tiempos y fallos reales.
3. Sacar fotos y grabar un video corto por SKU. El guion está en la ficha.
4. Publicar primero en WhatsApp e Instagram; TikTok cuando haya video.
5. Medir: 3 unidades vendidas en 14 días por SKU. Si no llega, revisar foto, precio o canal antes de reponer.
6. Recién después producir el catálogo completo (OT-002) y los personalizados (OT-003).

## Advertencias

- No prometas “no se rompe”, “para ansiedad” ni curas. El copy ya está corregido para evitar claims médicos o absolutos.
- El pack de huevos twist **no se abre**: se retuerce. El que se abre es el Huevo de Dragón.
- La maceta ribbed lleva base de cuatro patas pegada y **no incluye plato**; el drenaje es opcional y se perfora a pedido.
- La lámpara luna usa portalámpara **E12** con cable y bombilla LED cálida; no es una lámpara USB recargable.
- El dragón de cristal es delicado al despegarlo de la cama. No lo escales a la ligera: probá una unidad a la medida final.
- La publicación real depende de APIs externas. Si una API cambia, el agente devuelve `error` con el mensaje; no oculta el fallo.

## Mapa de archivos

```
ARKHE-3D/
├─ catalogo-v2/
│  ├─ index.html                 catálogo visual
│  ├─ fichas.html                fichas A4
│  ├─ fichas-para-imprimir.pdf   12 páginas A4
│  ├─ catalogo.csv               planilla
│  ├─ productos.json             datos + precios calculados
│  ├─ plan-de-stock.md
│  ├─ ordenes/OT-001..003
│  └─ img/                       fotos WebP de referencia
├─ agente-publicador/
│  ├─ index.mjs                  CLI
│  ├─ canales.mjs                adaptadores de API
│  ├─ panel.mjs                  generador del panel
│  ├─ panel.html                 panel autocontenido
│  ├─ config.json
│  ├─ .env.example
│  └─ cola.json
├─ sistema/
│  ├─ productos-v2.json          fuente de verdad de los 12 SKU
│  ├─ precios.mjs                motor de precios compartido
│  ├─ config-v2.json             costos, comisiones, margen, tipo de cambio
│  ├─ generar-catalogo-v2.mjs    generador
│  └─ pdf-v2.mjs                 exportador PDF
└─ investigacion/
   ├─ datos-mercado-2026-10-25.json
   ├─ evidencia-2026-10-25.md
   └─ raw/                       páginas crudas de la investigación
```

## Comandos útiles

```bash
npm run catalogo:v2
npm run pdf:v2
npm run agente:listar
npm run agente -- --producto fidget-star --canal WhatsApp
npm run agente -- --todos --canal WhatsApp,Instagram,Facebook,TikTok
npm run panel
```

Para cambiar un precio, un costo o un copy, editá `sistema/productos-v2.json`, volvé a correr `npm run catalogo:v2` y `npm run pdf:v2`, y regenerá el panel con `npm run panel`.
