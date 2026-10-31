# ARKHE 3D · Catálogo + sistema de investigación

> **Versión legacy (v1).** La versión activa es **v2**: catálogo de 12 SKU con evidencia verificada, precios en USD y agente publicador. Empezá por [`LEEME-V2.md`](LEEME-V2.md) y `catalogo-v2/index.html`.

Todo lo que necesitás para decidir qué imprimir, a qué precio venderlo y cómo publicarlo.
**Corte de datos:** 24/10/2026 · **Productos analizados:** 192 · **Catálogo curado:** 21

---

## Empezá por acá

| Quiero... | Abrir |
|---|---|
| Ver el catálogo con fotos y precios | `catalogo/index.html` |
| Imprimir fichas A4 para la feria | `catalogo/fichas-para-imprimir.pdf` (o el `.html`) |
| Entender el mercado | `investigacion/estudio-mercado.md` |
| Ver de dónde salió cada dato | `investigacion/fuentes.md` |
| Producir Navidad | `ordenes/OT-001-navidad.md` |
| Producir para la feria | `ordenes/OT-002-feria.md` |
| Vender personalizados | `ordenes/OT-003-personalizados.md` |
| Conectar redes y automatizar | `sistema/publicar/integraciones.md` |
| Ver la shortlist automática | `salidas/radar-2026-10-24.md` |

Abrir el catálogo: doble clic en `catalogo/index.html`. No necesita internet (las fotos están locales).

---

## Comandos

```bash
# regenerar el catálogo después de editar precios o productos
node sistema/generar-catalogo.mjs

# correr la investigación automática (Printables, sin login)
node sistema/radar.mjs --sin-makerworld

# sumar MakerWorld (requiere navegador)
npm i playwright-core
node sistema/radar.mjs

# exportar las fichas a PDF
node sistema/pdf.mjs
```

Salidas del radar en `salidas/`:
- `radar-AAAA-MM-DD.md` — shortlist con score, licencia, costo y precio.
- `orden-de-trabajo-AAAA-MM-DD.md` — lote listo para producir.
- `radar-AAAA-MM-DD.csv` — para Excel o Google Sheets.
- `radar-AAAA-MM-DD.json` — datos crudos.

---

## Cómo está armado

```
ARKHE-3D/
├─ catalogo/
│  ├─ index.html                 catálogo visual, filtros por línea y semáforo
│  ├─ fichas-para-imprimir.html  A4, una ficha por producto
│  ├─ catalogo.csv               planilla para Excel / Sheets
│  └─ img/                       21 fotos reales de los modelos
├─ investigacion/
│  ├─ estudio-mercado.md         qué se vende, canales, plazas, precios
│  └─ fuentes.md                 links, descargas y licencia de cada modelo
├─ ordenes/
│  ├─ OT-001-navidad.md
│  ├─ OT-002-feria.md
│  └─ OT-003-personalizados.md
├─ sistema/
│  ├─ productos.json             la base editable del catálogo
│  ├─ config.json                keywords, costos, impresión, tipo de cambio
│  ├─ generar-catalogo.mjs       JSON → HTML + CSV + fuentes
│  ├─ radar.mjs                  investigación + scoring + orden de trabajo
│  ├─ acentuar.mjs               corrige tildes sin tocar hashtags
│  ├─ publicar/
│  │  ├─ integraciones.md        Metricool, WhatsApp, ManyChat, n8n
│  │  └─ n8n-arkhe.json          workflow listo para importar
│  └─ productos.backup.json      copia sin acentos (respaldo)
└─ salidas/                      resultados de cada corrida
```

---

## Los 3 semáforos (leer antes de imprimir)

- **VERDE · Comercial OK.** Creative Commons BY o dominio público. Se vende citando al autor. Hoy: jabonera, lámpara luna, cake topper.
- **AMARILLO · Licencia.** Modelo gratis pero de uso personal (estándar MakerWorld). Hay que comprar licencia comercial al creador (USD 4–10). Se paga con una venta.
- **ROJO · No vender.** NonCommercial o personaje con copyright (Pokémon, Disney, One Piece). No importa si el archivo es gratis.

**Las fotos del catálogo son de los creadores y son solo referencia interna.** Para publicar, sacá foto propia de tu impresión. Usar la foto ajena es infracción de derechos y además se nota.

---

## Cómo se calcula el score

```
Score = 45% demanda (descargas por mes)
      + 20% engagement (likes / descargas)
      + 15% frescura (modelo nuevo)
      + 20% licencia (se puede vender)
      + ajuste por tipo de producto
```

Un modelo con score alto y licencia VERDE es una orden de producción. Un modelo con score alto y licencia AMARILLA es una compra de licencia. Uno con ROJO no se toca.

---

## Qué editar para que sea tuyo

1. **`sistema/config.json`**
   - `tipo_cambio_usd`: poné el valor del día para ver precios locales.
   - `keywords`: agregá las categorías que querés vigilar.
   - `costos`: precio del kilo de filamento, energía y desgaste reales.
2. **`sistema/productos.json`**
   - precios, stock, textos y canales.
   - después corré `node sistema/generar-catalogo.mjs`.
3. **`catalogo/img/`**
   - reemplazá las fotos por las tuyas manteniendo el nombre del archivo.

---

## Rutina semanal (20 minutos)

1. **Lunes:** correr `radar.mjs` y leer el top 5.
2. **Lunes:** elegir 1 producto nuevo y verificar licencia.
3. **Martes:** imprimir muestra y sacar fotos.
4. **Miércoles:** programar 4 publicaciones en Metricool.
5. **Viernes:** revisar ventas, stock y reponer.
6. **Domingo:** cargar números en la planilla.

---

## Límites conocidos

- **MakerWorld** bloquea pedidos sin navegador. El radar lo resuelve con Playwright y Chrome/Edge instalado. Sin eso, usa el modo `--sin-makerworld` (solo Printables).
- **La descarga del archivo** requiere tu cuenta y, en muchos casos, la licencia. El sistema deja el link y la orden; la descarga es manual o con tu sesión iniciada.
- **Las tendencias de TikTok/Instagram** no tienen API gratuita. Se validan con Meta Ad Library, TikTok Creative Center y 15 minutos de observación semanal.
- **Los gramos y horas** son estimaciones por categoría. Se corrigen con el laminador en la primera pieza.
- **Los precios** son en USD y sin mano de obra. Ajustá con tu costo real y tu hora.

---

## Próximos pasos sugeridos

1. Definir plaza (ciudad/estado) y tipo de cambio para localizar precios.
2. Comprar las 3 licencias de la línea Navidad y producir OT-001.
3. Sacar fotos propias de las primeras 5 piezas.
4. Publicar 4 videos con los textos del catálogo.
5. Volver a correr el radar el lunes y comparar.

---

*Generado con datos en vivo de MakerWorld y Printables. Las descargas son señal de demanda, no ventas. Verificá siempre la licencia antes de vender.*
