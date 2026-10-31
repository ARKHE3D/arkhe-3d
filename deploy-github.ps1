#!/usr/bin/env pwsh
# ==============================================================================
# AGENTE DE DESPLIEGUE AUTOMÁTICO - ARKHE 3D v2
# ==============================================================================
# Este script hace TODO lo que se puede hacer localmente para subir el proyecto
# a GitHub y dejarlo listo para CI/CD. Solo quedan 2 pasos manuales que vos
# tenés que hacer en el navegador (por seguridad, GitHub no permite autenticación
# automática sin tu usuario y contraseña):
#
#   1. Crear el repositorio en https://github.com/new
#   2. Activar GitHub Pages en Settings -> Pages -> Source: GitHub Actions
#
# Todo lo demás lo hace este script: git init, add, commit, remote add, push.
# ==============================================================================

$ErrorActionPreference = "Stop"
$PROJECT_NAME = "arkhe-3d"
$ROOT = Split-Path -Parent $PSCommandPath
Set-Location $ROOT

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  AGENTE DE DESPLIEGUE ARKHE 3D v2" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# --- 1. Verificar si git está instalado ---
Write-Host "[1/7] Verificando Git..." -ForegroundColor Yellow
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git NO está instalado en este equipo." -ForegroundColor Red
    Write-Host ""
    Write-Host "INSTALÁ GIT PRIMERO:" -ForegroundColor Yellow
    Write-Host "  1. Descargalo de: https://git-scm.com/download/win"
    Write-Host "  2. Instalalo con las opciones por defecto"
    Write-Host "  3. Reiniciá la terminal y volvé a correr este script"
    Write-Host ""
    Write-Host "O, en su lugar, subí los archivos manualmente desde el navegador:"
    Write-Host "  https://github.com/new  ->  uploading an existing file  ->  arrastre la carpeta ARKHE-3D (menos node_modules/)"
    Read-Host "Presioná Enter para salir"
    exit 1
}
Write-Host "Git encontrado: $(git --version)" -ForegroundColor Green

# --- 2. Verificar si GitHub CLI (gh) está instalado ---
$ghAvailable = Get-Command gh -ErrorAction SilentlyContinue
if ($ghAvailable) {
    Write-Host "[2/7] GitHub CLI (gh) encontrado: $(gh --version | Select-Object -First 1)" -ForegroundColor Green
} else {
    Write-Host "[2/7] GitHub CLI (gh) NO está instalado. Se usará creación manual de repo." -ForegroundColor Yellow
    Write-Host "   (Opcional: instalalo de https://cli.github.com/ para automatizar el paso de crear el repositorio)"
}

# --- 3. Inicializar repositorio local ---
Write-Host "[3/7] Inicializando repositorio Git local..." -ForegroundColor Yellow
git init
git branch -M main

# --- 4. Agregar archivos (excluyendo node_modules y temporales) ---
Write-Host "[4/7] Agregando archivos al staging..." -ForegroundColor Yellow
git add .
Write-Host "Archivos agregados:" -ForegroundColor Gray
git status --short | Select-Object -First 30

# --- 5. Commit ---
Write-Host "[5/7] Creando commit inicial..." -ForegroundColor Yellow
git commit -m "feat: catálogo v2 y agente publicador con CI/CD

- 12 SKU VERDE con evidencia de mercado y precios en USD
- Generador de catálogo, fichas A4, CSV, stock y órdenes de trabajo
- PDF para imprimir (12 páginas A4)
- Agente publicador: WhatsApp, Instagram, Facebook, TikTok (dry-run por defecto)
- GitHub Actions: catalogo.yml, publicador.yml, release.yml
- GitHub Pages listo para desplegar catalogo-v2/
- .gitignore ajustado: imágenes de referencia se suben, salidas generadas no
- LEEME-V2.md y LEEME-GITHUB.md"

# --- 6. Conectar con repositorio remoto ---
Write-Host "[6/7] Conectando con repositorio remoto..." -ForegroundColor Yellow

if ($ghAvailable) {
    # Intentar autenticar con gh
    $authStatus = gh auth status 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "GitHub CLI no está autenticado. Ejecutando: gh auth login" -ForegroundColor Yellow
        gh auth login
    }

    # Pedir nombre de usuario u organización
    $user = Read-Host "Ingresá tu usuario u organización de GitHub (ej: ARKHE3D)"
    $repoName = Read-Host "Nombre del repositorio (presioná Enter para usar '$PROJECT_NAME')"
    if ([string]::IsNullOrWhiteSpace($repoName)) { $repoName = $PROJECT_NAME }

    Write-Host "Creando repositorio remoto $user/$repoName via GitHub CLI..." -ForegroundColor Yellow
    gh repo create "$user/$repoName" --public --source=. --remote=origin --push
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Repositorio creado y push exitoso!" -ForegroundColor Green
        $remoteUrl = "https://github.com/$user/$repoName"
    } else {
        Write-Host "No se pudo crear el repo automáticamente. Hacelo manualmente en github.com/new" -ForegroundColor Red
        $remoteUrl = ""
    }
} else {
    Write-Host "GitHub CLI no disponible. Hacé esto manualmente:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Abrí https://github.com/new"
    Write-Host "  2. Nombre del repositorio: $PROJECT_NAME"
    Write-Host "  3. NO marques 'Add a README file'"
    Write-Host "  4. NO marques 'Add .gitignore'"
    Write-Host "  5. Click en 'Create repository'"
    Write-Host ""
    $remoteUrl = Read-Host "Una vez creado el repo, pegá acá la URL que te da GitHub (ej: https://github.com/TU-USUARIO/arkhe-3d.git)"
    if (![string]::IsNullOrWhiteSpace($remoteUrl)) {
        git remote add origin $remoteUrl
        git push -u origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Push exitoso!" -ForegroundColor Green
        }
    }
}

# --- 7. Instrucciones finales ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  ¡LISTO! PASOS RESTANTES (solo vos podés hacerlos)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PASO A - Activar GitHub Pages:" -ForegroundColor Yellow
Write-Host "  1. Abrí tu repositorio en GitHub"
Write-Host "  2. Settings -> Pages"
Write-Host "  3. Build and deployment -> Source: GitHub Actions"
Write-Host "  4. Guardá"
Write-Host ""
Write-Host "Tu catálogo quedará en: https://TU-USUARIO.github.io/$PROJECT_NAME/" -ForegroundColor Green
Write-Host ""
Write-Host "PASO B - Configurar Secrets (opcional, para publicar en redes):" -ForegroundColor Yellow
Write-Host "  Settings -> Secrets and variables -> Actions"
Write-Host "  Agregá los que uses: WHATSAPP_TOKEN, META_ACCESS_TOKEN, FB_PAGE_TOKEN, TIKTOK_ACCESS_TOKEN, etc."
Write-Host ""
Write-Host "PASO C - Probar el agente publicador:" -ForegroundColor Yellow
Write-Host "  En GitHub: Actions -> Agente Publicador -> Run workflow"
Write-Host "  O localmente: npm run agente -- --todos --canal WhatsApp,Instagram,Facebook,TikTok"
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  FIN DEL AGENTE DE DESPLIEGUE" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Read-Host "Presioná Enter para salir"
