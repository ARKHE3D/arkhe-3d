# ARKHE 3D · Agente de despliegue automático

Este archivo es el **agente que automatiza el despliegue a GitHub**. Como soy una IA, no puedo autenticar en tu cuenta de GitHub ni crear el repositorio por vos, pero este script hace todo lo que se puede hacer desde tu PC.

## Qué hace `deploy-github.ps1`

1. Verifica si **Git** está instalado.
2. Inicializa un repositorio Git local en `ARKHE-3D/`.
3. Agrega todos los archivos (menos `node_modules/` y temporales `_*`).
4. Hace el commit inicial con el catálogo v2 y el agente publicador.
5. Si tenés **GitHub CLI (`gh`)** instalado y autenticado, crea el repositorio remoto y hace `push` automáticamente.
6. Si no tenés `gh`, te pide que crees el repo manualmente en github.com/new y luego pega la URL para que el script haga el `push`.
7. Te da las instrucciones exactas para activar **GitHub Pages** y configurar los **Secrets**.

## Cómo usar el agente

### Opción A: Tenés Git instalado

```powershell
# Ejecutá desde la carpeta ARKHE-3D/
.\deploy-github.ps1
```

Si tenés GitHub CLI (`gh`) instalado y autenticado, el script crea el repo y sube todo solo. Si no, te guía para crearlo manualmente en el navegador.

### Opción B: No tenés Git instalado

1. Instalá Git de https://git-scm.com/download/win
2. Reiniciá la terminal
3. Corrí `.\deploy-github.ps1`

### Opción C: No querés instalar nada

Subí los archivos manualmente desde el navegador:
1. https://github.com/new
2. Nombre: `arkhe-3d`
3. **NO** marques "Add a README file"
4. **NO** marques "Add .gitignore"
5. Click en **uploading an existing file** y arrastre toda la carpeta `ARKHE-3D/` excepto `node_modules/`

## Después de subir (pasos que solo vos podés hacer)

### 1. Activar GitHub Pages
En tu repo: **Settings → Pages → Source: GitHub Actions**

Tu catálogo quedará online en:
```
https://TU-USUARIO.github.io/arkhe-3d/
```

### 2. Configurar Secrets (para publicar en redes sociales)
**Settings → Secrets and variables → Actions**

Agregá solo los canales que vayas a usar:

| Secret | Para qué |
|--------|----------|
| `WHATSAPP_TOKEN` | WhatsApp Business Cloud API |
| `WHATSAPP_PHONE_NUMBER_ID` | ID de número de WhatsApp |
| `WHATSAPP_TO` | Número destino de prueba |
| `WHATSAPP_NUMERO` | Número para enlaces wa.me |
| `META_ACCESS_TOKEN` | Instagram / Facebook |
| `IG_USER_ID` | ID de cuenta Instagram |
| `FB_PAGE_TOKEN` | Token de página Facebook |
| `FB_PAGE_ID` | ID de página Facebook |
| `TIKTOK_ACCESS_TOKEN` | TikTok Content Posting API |
| `TIKTOK_VIDEO_URL` | URL pública del video para TikTok |
| `URL_PUBLICA_BASE` | Carpeta de imágenes públicas (ej: `https://tudominio.com/arkhe/catalogo-v2/img`) |

### 3. Probar el agente publicador
En GitHub: **Actions → Agente Publicador → Run workflow**

- `confirmar = false` (default): solo simula, no publica nada.
- `confirmar = true`: publica de verdad (necesita los secrets).

O localmente:
```powershell
npm run agente -- --todos --canal WhatsApp,Instagram,Facebook,TikTok
```

## Estructura del proyecto

```
ARKHE-3D/
├─ .github/
│  ├─ workflows/
│  │  ├─ catalogo.yml      # CI: genera catálogo + PDF + despliega a Pages
│  │  ├─ publicador.yml    # CI: agente publicador (dry-run / real)
│  │  └─ release.yml       # Releases con PDF, CSV y JSON
│  └─ ISSUE_TEMPLATE/      # plantillas de issues (opcional)
├─ deploy-github.ps1       # ← este agente de despliegue
├─ .gitignore
├─ catalogo-v2/            # generado por CI (no subir manualmente)
├─ agente-publicador/
│  ├─ index.mjs
│  ├─ canales.mjs
│  ├─ panel.mjs
│  ├─ precios.mjs
│  ├─ config.json
│  ├─ .env.example
│  └─ panel.html
├─ sistema/
│  ├─ productos-v2.json
│  ├─ precios.mjs
│  ├─ config-v2.json
│  ├─ generar-catalogo-v2.mjs
│  └─ pdf-v2.mjs
├─ LEEME-V2.md
├─ LEEME-GITHUB.md
└─ package.json
```

## Comandos útiles después del despliegue

```powershell
# Ver precios y costos
npm run agente:listar

# Regenerar catálogo y PDF
npm run ci:catalogo

# Ejecutar agente en modo simulación (dry-run)
npm run ci:agente

# Regenerar panel visual
npm run ci:panel

# Limpiar cola de trabajos
npm run agente -- --limpiar
```

---

**¿Necesitás ayuda con algún paso?** Decime en qué parte te trabás y te guío específicamente.
