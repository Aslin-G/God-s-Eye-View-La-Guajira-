#!/usr/bin/env bash
# Prepara God's Eye View - La Guajira en macOS o Linux.
#
# 1. Verifica Git y Node.js (24.14 o superior, o 26.x). Si Node no sirve y
#    tienes nvm, instala la versión correcta con nvm.
# 2. Descarga (clona) el repositorio si todavía no está en el computador.
# 3. Instala las dependencias exactas (npm ci) y ejecuta el diagnóstico.
# 4. Abre la aplicación en el navegador.
#
# Uso:  bash preparar-mac-linux.sh [--destino RUTA] [--solo-iniciar]
set -euo pipefail

REPOSITORIO="https://github.com/Aslin-G/God-s-Eye-View-La-Guajira-.git"
DESTINO="$HOME/proyectos/God-s-Eye-View-La-Guajira"
DESTINO_ELEGIDO=0
SOLO_INICIAR=0

while [ $# -gt 0 ]; do
  case "$1" in
    --destino)
      DESTINO="${2:?Falta la ruta después de --destino}"
      DESTINO_ELEGIDO=1
      shift
      ;;
    --solo-iniciar) SOLO_INICIAR=1 ;;
    *)
      echo "Opción desconocida: $1" >&2
      exit 1
      ;;
  esac
  shift
done

paso() { printf '\n\033[36m==> %s\033[0m\n' "$1"; }
aviso() { printf '    \033[33m%s\033[0m\n' "$1"; }
fallo() {
  printf '\n\033[31mERROR: %s\033[0m\n' "$1" >&2
  echo 'Consulta la sección "Problemas frecuentes" de GUIA-TRABAJO-LOCAL.md.' >&2
  exit 1
}
existe() { command -v "$1" >/dev/null 2>&1; }
es_proyecto() { [ -f "$1/package.json" ] && grep -q '"name": "gods-eye-view"' "$1/package.json"; }

node_compatible() {
  existe node || return 1
  local version mayor menor
  version="$(node -p 'process.versions.node')"
  mayor="${version%%.*}"
  menor="$(echo "$version" | cut -d. -f2)"
  { [ "$mayor" -eq 24 ] && [ "$menor" -ge 14 ]; } || [ "$mayor" -eq 26 ]
}

printf "\033[32mGod's Eye View - La Guajira: preparación en %s\033[0m\n" "$(uname -s)"

# Si el script está dentro de un clon, trabaja sobre ese clon.
RAIZ_DEL_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ "$DESTINO_ELEGIDO" -eq 0 ] && es_proyecto "$RAIZ_DEL_SCRIPT"; then
  DESTINO="$RAIZ_DEL_SCRIPT"
fi

# 1. Git
paso 'Verificando Git'
if ! existe git; then
  if [ "$(uname -s)" = Darwin ]; then
    fallo 'Git no está instalado. Ejecuta "xcode-select --install" (o "brew install git") y vuelve a correr este script.'
  fi
  fallo 'Git no está instalado. En Ubuntu/Debian: "sudo apt install git". Luego vuelve a correr este script.'
fi
echo "    $(git --version)"

# 2. Node.js
paso 'Verificando Node.js (se necesita 24.14 o superior, o 26.x)'
if ! node_compatible; then
  if existe node; then aviso "Tienes Node $(node --version), que no es compatible."; else aviso 'Node.js no está instalado.'; fi
  NVM_SCRIPT="${NVM_DIR:-$HOME/.nvm}/nvm.sh"
  if [ -s "$NVM_SCRIPT" ]; then
    aviso 'Instalando Node 24 con nvm...'
    set +u
    # shellcheck source=/dev/null
    . "$NVM_SCRIPT"
    nvm install 24
    nvm use 24
    set -u
  fi
  node_compatible || fallo 'Instala Node.js 24 LTS (https://nodejs.org/ o "nvm install 24") y vuelve a correr este script.'
fi
echo "    Node $(node --version), npm $(npm --version)"

# 3. Repositorio
paso "Carpeta del proyecto: $DESTINO"
if es_proyecto "$DESTINO"; then
  echo '    El proyecto ya está descargado. No se modifican tus archivos.'
elif [ -e "$DESTINO" ]; then
  fallo "La carpeta $DESTINO ya existe y no contiene el proyecto. Elige otra con --destino."
else
  paso 'Descargando el repositorio (incluye todo el historial; puede tardar unos minutos)'
  mkdir -p "$(dirname "$DESTINO")"
  git clone "$REPOSITORIO" "$DESTINO"
fi
cd "$DESTINO"

# 4. Dependencias
export PUPPETEER_SKIP_DOWNLOAD=1
if [ "$SOLO_INICIAR" -eq 0 ] || [ ! -d node_modules ]; then
  paso 'Instalando dependencias exactas (npm ci)'
  npm ci
  paso 'Diagnóstico del proyecto (npm run doctor)'
  npm run doctor
fi

# 5. Iniciar
if [ "$SOLO_INICIAR" -eq 0 ]; then
  printf '\n¿Abrir la aplicación ahora? (S/N) '
  read -r RESPUESTA || RESPUESTA=n
  case "$RESPUESTA" in
    [sSyY]*) ;;
    *)
      printf '\n\033[32mListo. Para abrirla más tarde, dentro de %s ejecuta: bash kit-local/iniciar-mac-linux.sh (o npm run dev)\033[0m\n' "$DESTINO"
      exit 0
      ;;
  esac
fi
paso 'Iniciando la aplicación. Se abrirá el navegador. Para detenerla presiona Ctrl+C.'
exec npm run dev -- --open
