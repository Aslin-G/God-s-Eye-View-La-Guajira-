<#
  Prepara God's Eye View - La Guajira en un computador con Windows.

  1. Verifica Git y Node.js (24.14 o superior, o 26.x) y ofrece instalarlos
     con winget si faltan.
  2. Descarga (clona) el repositorio si todavía no está en el computador.
  3. Instala las dependencias exactas (npm ci) y ejecuta el diagnóstico.
  4. Abre la aplicación en el navegador.

  Uso normal: doble clic en 1-preparar-windows.bat (o 2-iniciar-windows.bat).
  Desde PowerShell:
    powershell -ExecutionPolicy Bypass -File preparar-windows.ps1 [-Destino C:\ruta] [-SoloIniciar]
#>
param(
  [string]$Destino = (Join-Path $HOME 'proyectos\God-s-Eye-View-La-Guajira'),
  [string]$Repositorio = 'https://github.com/Aslin-G/God-s-Eye-View-La-Guajira-.git',
  [switch]$SoloIniciar
)

$ErrorActionPreference = 'Stop'

function Paso([string]$texto) {
  Write-Host ''
  Write-Host "==> $texto" -ForegroundColor Cyan
}

function Aviso([string]$texto) {
  Write-Host "    $texto" -ForegroundColor Yellow
}

function Fallo([string]$texto) {
  Write-Host ''
  Write-Host "ERROR: $texto" -ForegroundColor Red
  Write-Host 'Consulta la sección "Problemas frecuentes" de GUIA-TRABAJO-LOCAL.md.'
  exit 1
}

function Existe([string]$comando) {
  return [bool](Get-Command $comando -ErrorAction SilentlyContinue)
}

function Actualizar-Path {
  $maquina = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  $usuario = [Environment]::GetEnvironmentVariable('Path', 'User')
  $env:Path = "$maquina;$usuario"
}

function Instalar-ConWinget([string]$id, [string]$nombre) {
  if (-not (Existe 'winget')) { return $false }
  $respuesta = Read-Host "    ¿Instalar $nombre ahora con winget? (S/N)"
  if ($respuesta -notmatch '^[sSyY]') { return $false }
  winget install --id $id -e --accept-source-agreements --accept-package-agreements
  Actualizar-Path
  return $true
}

function Node-Compatible {
  if (-not (Existe 'node')) { return $false }
  $version = [version](& node -p 'process.versions.node')
  return (($version.Major -eq 24 -and $version.Minor -ge 14) -or $version.Major -eq 26)
}

function Es-Proyecto([string]$carpeta) {
  $manifiesto = Join-Path $carpeta 'package.json'
  if (-not (Test-Path $manifiesto)) { return $false }
  return [bool](Select-String -Path $manifiesto -Pattern '"name": "gods-eye-view"' -Quiet)
}

function Ejecutar([string]$descripcion, [scriptblock]$accion) {
  & $accion
  if ($LASTEXITCODE -ne 0) { Fallo "$descripcion terminó con código $LASTEXITCODE." }
}

Write-Host "God's Eye View - La Guajira: preparación en Windows" -ForegroundColor Green

# Si el script está dentro de un clon, trabaja sobre ese clon.
$raizDelScript = Split-Path -Parent $PSScriptRoot
if (-not $PSBoundParameters.ContainsKey('Destino') -and (Es-Proyecto $raizDelScript)) {
  $Destino = $raizDelScript
}

# 1. Git
Paso 'Verificando Git'
if (-not (Existe 'git')) {
  Aviso 'Git no está instalado.'
  if (-not (Instalar-ConWinget 'Git.Git' 'Git') -or -not (Existe 'git')) {
    Fallo 'Instala Git desde https://git-scm.com/download/win, cierra esta ventana y vuelve a ejecutar el script.'
  }
}
Write-Host "    $(git --version)"

# 2. Node.js
Paso 'Verificando Node.js (se necesita 24.14 o superior, o 26.x)'
if (-not (Node-Compatible)) {
  if (Existe 'node') { Aviso "Tienes Node $(node --version), que no es compatible." } else { Aviso 'Node.js no está instalado.' }
  if (-not (Instalar-ConWinget 'OpenJS.NodeJS.LTS' 'Node.js LTS') -or -not (Node-Compatible)) {
    Fallo 'Instala Node.js 24 LTS desde https://nodejs.org/, cierra esta ventana y vuelve a ejecutar el script.'
  }
}
Write-Host "    Node $(node --version), npm $(npm.cmd --version)"

# 3. Repositorio
Paso "Carpeta del proyecto: $Destino"
if ($Destino -match 'OneDrive') {
  Aviso 'La carpeta está dentro de OneDrive. La sincronización suele causar errores EPERM al instalar.'
  Aviso 'Se recomienda una carpeta fuera de OneDrive, por ejemplo C:\proyectos\God-s-Eye-View-La-Guajira.'
}
if (Es-Proyecto $Destino) {
  Write-Host '    El proyecto ya está descargado. No se modifican tus archivos.'
} elseif (Test-Path $Destino) {
  Fallo "La carpeta $Destino ya existe y no contiene el proyecto. Elige otra con -Destino."
} else {
  Paso 'Descargando el repositorio (incluye todo el historial; puede tardar unos minutos)'
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destino) | Out-Null
  Ejecutar 'git clone' { git clone -c core.longpaths=true $Repositorio $Destino }
}
Set-Location $Destino

# 4. Dependencias (npm.cmd evita depender de la política de ejecución de npm.ps1)
$env:PUPPETEER_SKIP_DOWNLOAD = '1'
$faltanDependencias = -not (Test-Path (Join-Path $Destino 'node_modules'))
if (-not $SoloIniciar -or $faltanDependencias) {
  Paso 'Instalando dependencias exactas (npm ci)'
  Ejecutar 'npm ci' { npm.cmd ci }
  Paso 'Diagnóstico del proyecto (npm run doctor)'
  Ejecutar 'npm run doctor' { npm.cmd run doctor }
}

# 5. Iniciar
if (-not $SoloIniciar) {
  $respuesta = Read-Host "`n¿Abrir la aplicación ahora? (S/N)"
  if ($respuesta -notmatch '^[sSyY]') {
    Write-Host ''
    Write-Host 'Listo. Para abrirla más tarde usa 2-iniciar-windows.bat o, en esta carpeta, npm run dev.' -ForegroundColor Green
    exit 0
  }
}
Paso 'Iniciando la aplicación. Se abrirá el navegador. Para detenerla presiona Ctrl+C en esta ventana.'
# Equivale a "npm run dev -- --open"; se llama a Vite directamente porque
# PowerShell puede descartar el "--" al pasarlo a npm.
& node (Join-Path $Destino 'node_modules/vite/bin/vite.js') --open
