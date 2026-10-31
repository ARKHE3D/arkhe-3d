# ARKHE 3D · Automatización con GitHub

Todo el flujo de catálogo, precios, publicaciones y releases corre solo en GitHub:

| Herramienta | Para qué sirve |
|-------------|----------------|
| **GitHub Actions** | Genera catálogo, PDF y ejecuta el agente publicador automáticamente (push, horario o manual). |
| **GitHub Pages** | Hospeda `catalogo-v2/index.html` y las fichas para que cualquiera las vea. |
| **GitHub Releases** | Adjunta el PDF, el CSV y el JSON en cada etiqueta `v*`. |
| **GitHub Secrets** | Guarda credenciales de WhatsApp, Meta, TikTok y URL pública de imágenes. |
| **GitHub Issues** | Tickets de producción (OT-001, OT-002, OT-003). |
| **GitHub Projects** | Kanban de stock y reposición. |
| **Dependabot** | Mantiene actualizadas las dependencias de Node. |

## Paso 0: Crear el repositorio en GitHub

1. Ve a https://github.com/new
2. Nombre del repositorio: `arkhe-3d` (o el que quieras)
3. **Público** o privado, según prefieras.
4. **No inicialices con README** (ya tenemos archivos locales).
5. Copia la URL del repositorio (ej: `https://github.com/TU-USUARIO/arkhe-3d.git`).

## Paso 1: Vincular tu carpeta local con GitHub

En la carpeta `ARKHE-3D/` ejecuta:

```powershell
git init
git add .
git commit -m "feat: catálogo v2 y agente publicador listos para CI/CD"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/arkhe-3d.git
git push -u origin main
```

> Reemplaza `TU-USUARIO/arkhe-3d` por tu usuario y nombre de repo reales.

## Paso 2: Habilitar GitHub Pages

En tu repositorio de GitHub:

1. **Settings → Pages**
2. Build and deployment → Source: **GitHub Actions**
3. Guarda. El workflow `.github/workflows/catalogo.yml` se encargará de desplegar en cada push a `main`.

Tu catálogo quedará en: `https://TU-USUARIO.github.io/arkhe-3d/`

## Paso 3: Configurar los Secrets (credenciales)

En **Settings → Secrets and variables → Actions** agrega los que vayas a usar:

| Secret | Para qué | Ejemplo |
|--------|----------|---------|
| `WHATSAPP_TOKEN` | WhatsApp Business Cloud API | `EAAG...` |
| `WHATSAPP_PHONE_NUMBER_ID` | ID de número de teléfono | `123456789` |
| `WHATSAPP_TO` | Destino de prueba | `5491123456789` |
| `WHATSAPP_NUMERO` | Número para enlaces wa.me | `5491123456789` |
| `META_ACCESS_TOKEN` | Instagram / Facebook | `EAA...` |
| `IG_USER_ID` | ID de cuenta IG | `1784140...` |
| `FB_PAGE_TOKEN` | Token de página FB | `EAAG...` |
| `FB_PAGE_ID` | ID de página FB | `123456789` |
| `TIKTOK_ACCESS_TOKEN` | TikTok Content Posting API | `act_...` |
| `TIKTOK_VIDEO_URL` | URL pública del video para TikTok | `https://tudominio.com/video.mp4` |
| `URL_PUBLICA_BASE` | Carpeta de imágenes publicada por HTTPS | `https://tudominio.com/arkhe/catalogo-v2/img` |
| `GRAPH_API_VERSION` | Versión de Graph API (opcional) | `v21.0` |

> **Nunca subas un archivo `.env` real.** Usa `.env.example` como plantilla local y los Secrets de GitHub para la nube.

## Paso 4: Probar todo automáticamente

### Generar catálogo y desplegar a Pages
Cada vez que hagas `git push origin main`, se ejecuta:
1. `npm run catalogo:v2` → HTML, CSV, JSON, stock, órdenes.
2. `npm run pdf:v2` → `fichas-para-imprimir.pdf` (12 páginas A4).
3. Se sube a GitHub Pages y está online.

### Ejecutar el agente publicador (simulación)
```powershell
npm run ci:agente
```
Esto genera los 48 trabajos (12 SKU × 4 canales) en modo **dry-run** (no publica nada). Revisa `agente-publicador/cola.json`.

### Publicar de verdad (solo con `--confirmar` y secrets)
Desde GitHub Actions (pestaña **Actions → Agente Publicador → Run workflow**):
- Marca **confirmar = true**.
- O desde consola local:
  ```powershell
  npm run agente -- --producto fidget-star --canal WhatsApp --confirmar
  ```

### Crear un release con artefactos
Etiqueta y empuja:
```powershell
git tag v1.0.0
git push origin v1.0.0
```
El workflow `release.yml` crea el release y adjunta `fichas-para-imprimir.pdf`, `catalogo.csv` y `productos.json`.

## Paso 5: Usar Issues y Projects para producción

- **Issues**: crea uno por cada orden de trabajo (OT-001 arranque, OT-002 reposición, OT-003 personalizados).
- **Projects**: tablero Kanban con columnas `Por hacer`, `En producción`, `Listo para vender`, `Vendido`.
- Usa los issue templates si los agregas en `.github/ISSUE_TEMPLATE/`.

## Comandos rápidos

```powershell
# Todo local
npm run catalogo:v2
npm run pdf:v2
npm run agente -- --todos --canal WhatsApp,Instagram,Facebook,TikTok
npm run panel

# Solo listar precios
npm run agente:listar

# Limpiar cola
npm run agente -- --limpiar
```

## Estructura final

```
ARKHE-3D/
├─ .github/
│  ├─ workflows/
│  │  ├─ catalogo.yml      # CI: catálogo + PDF + Pages
│  │  ├─ publicador.yml    # CI: agente publicador (dry-run / real)
│  │  └─ release.yml       # Releases con artefactos
│  └─ ISSUE_TEMPLATE/      # (opcional) plantillas de issues
├─ .gitignore
├─ catalogo-v2/            # generado por CI (no subir)
├─ agente-publicador/
│  ├─ index.mjs
│  ├─ canales.mjs
│  ├─ panel.mjs
│  ├─ precios.mjs
│  ├─ config.json
│  ├─ .env.example
│  └─ panel.html           # generado por CI (no subir)
├─ sistema/
│  ├─ productos-v2.json
│  ├─ precios.mjs
│  ├─ config-v2.json
│  ├─ generar-catalogo-v2.mjs
│  └─ pdf-v2.mjs
├─ LEEME-V2.md
├─ LEEME-GITHUB.md         # este archivo
└─ package.json
```

## ¿Falta algo?

Si quieres agregar **Dependabot** para actualizar `playwright-core` automáticamente, crea `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
```

¿Listo para empujar a GitHub? Si me pasas el URL de tu repositorio, te digo el comando exacto del `git remote add origin`.
