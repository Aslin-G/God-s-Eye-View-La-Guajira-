#!/usr/bin/env bash
# Abre God's Eye View - La Guajira (si falta algo, lo prepara primero).
# Uso:  bash iniciar-mac-linux.sh [--destino RUTA]
set -euo pipefail
exec bash "$(dirname "${BASH_SOURCE[0]}")/preparar-mac-linux.sh" --solo-iniciar "$@"
