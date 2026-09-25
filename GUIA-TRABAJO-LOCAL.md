# Trabajar en tu computador: guía paso a paso

Esta guía explica cómo tener **tu propia copia de God's Eye View – La Guajira
en tu computador** para modificarla, personalizarla, experimentar y guardar tus
cambios sin miedo a perder nada.

---

## ¿Cuál es la mejor alternativa?

**Recomendación: clonar el repositorio con Git.** Tu repositorio de GitHub ya
es el "paquete completo": contiene todo el código, todo el historial y la
configuración. Clonarlo descarga una copia exacta en tu computador que queda
conectada con GitHub.

| Opción                              | Ventajas                                                                                                                                        | Desventajas                                                              | Úsala para              |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | ----------------------- |
| **1. Clonar con Git (recomendada)** | Historial completo. Puedes deshacer cualquier cambio, crear copias para experimentar, respaldar en GitHub y traer mejoras del proyecto original | Hay que instalar Git (el kit lo hace por ti en Windows)                  | Trabajar y experimentar |
| 2. Descargar ZIP desde GitHub       | No necesita Git                                                                                                                                 | Sin historial. No puedes deshacer, respaldar ni actualizar con facilidad | Solo mirar el código    |
| 3. Pinokio                          | Instalación con un clic                                                                                                                         | Poco práctico para modificar el código                                   | Solo usar la aplicación |

El **kit de descarga** (`kit-local/`) automatiza la opción 1: verifica las
herramientas, clona el repositorio, instala todo y abre la aplicación.

---

## Paso 1. Instalar las herramientas (una sola vez)

Necesitas tres programas:

| Programa           | Para qué                                       | Versión                            |
| ------------------ | ---------------------------------------------- | ---------------------------------- |
| Git                | Descargar el proyecto y guardar versiones      | Cualquiera reciente                |
| Node.js            | Ejecutar la aplicación                         | **24 LTS (24.14 o superior)** o 26 |
| Visual Studio Code | Editar el código (recomendado, no obligatorio) | Cualquiera reciente                |

> Node 22 y Node 25 **no** sirven. Si ya tienes otra versión, instala la 24.

### Windows

Abre **PowerShell** (menú Inicio → escribe "PowerShell") y ejecuta:

```powershell
winget install --id Git.Git -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Microsoft.VisualStudioCode -e
```

Si `winget` no existe, descarga los instaladores:
[git-scm.com](https://git-scm.com/download/win),
[nodejs.org](https://nodejs.org/) (versión LTS) y
[code.visualstudio.com](https://code.visualstudio.com/).

### macOS

```bash
xcode-select --install      # instala Git
```

Para Node.js, descarga el instalador **LTS** de [nodejs.org](https://nodejs.org/)
o usa [nvm](https://github.com/nvm-sh/nvm) (`nvm install 24`). Visual Studio
Code se descarga en [code.visualstudio.com](https://code.visualstudio.com/).

### Linux (Ubuntu/Debian)

```bash
sudo apt install git
# Node.js con nvm: instala nvm siguiendo https://github.com/nvm-sh/nvm y luego
nvm install 24
```

### Comprobar

**Cierra y vuelve a abrir la terminal** y ejecuta:

```bash
git --version     # cualquier versión
node --version    # debe decir v24.14 o superior, o v26
```

### Configurar tu nombre en Git (una sola vez)

Git firma cada cambio con tu nombre y correo:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@ejemplo.com"
```

---

## Paso 2. Descargar el proyecto

### Opción A: con el kit (la más fácil)

1. Descarga y descomprime el kit (`Kit-GEV-La-Guajira.zip`).
2. **Windows:** doble clic en `1-preparar-windows.bat`.
   **macOS/Linux:** abre una terminal en la carpeta del kit y ejecuta
   `bash preparar-mac-linux.sh`.
3. El script:
   - verifica Git y Node.js (en Windows ofrece instalarlos si faltan);
   - clona el proyecto en `proyectos/God-s-Eye-View-La-Guajira`, dentro de
     tu carpeta de usuario;
   - instala las dependencias y ejecuta el diagnóstico;
   - te pregunta si quieres abrir la aplicación.

Para usar otra carpeta:

```powershell
# Windows (PowerShell, dentro de la carpeta del kit)
powershell -ExecutionPolicy Bypass -File preparar-windows.ps1 -Destino C:\proyectos\gev
```

```bash
# macOS/Linux
bash preparar-mac-linux.sh --destino ~/proyectos/gev
```

> **Windows:** si aparece "Windows protegió su PC", pulsa **Más información →
> Ejecutar de todos modos**. Ocurre con cualquier archivo descargado de
> internet.

### Opción B: a mano

```bash
cd ~                                   # tu carpeta de usuario
mkdir proyectos
cd proyectos
git clone https://github.com/Aslin-G/God-s-Eye-View-La-Guajira-.git God-s-Eye-View-La-Guajira
cd God-s-Eye-View-La-Guajira
npm ci
npm run doctor
```

> **Dónde guardarlo:** usa una carpeta **fuera de OneDrive, Dropbox o iCloud**
> (en Windows, "Documentos" y "Escritorio" suelen estar dentro de OneDrive).
> La sincronización bloquea archivos mientras se instalan las dependencias y
> causa errores `EPERM`. `C:\Users\<tu usuario>\proyectos\` es una buena
> opción.

> Si tu repositorio en GitHub es **privado**, la primera vez Git te pedirá
> iniciar sesión (se abre el navegador).

### Crear la rama `main` (recomendado, una sola vez)

Hoy la única rama del repositorio se llama
`claude/clone-gods-eye-view-electrical-xdxyiv`. Conviene tener una rama
principal llamada `main`:

```bash
git switch -c main
git push -u origin main
```

Luego, en GitHub: **Settings → General → Default branch** → elige `main`.
Desde ese momento `main` es tu versión estable, y las pruebas automáticas de
GitHub (CI) se ejecutan en cada cambio que subas a ella.

---

## Paso 3. Abrir la aplicación

Dentro de la carpeta del proyecto:

```bash
npm run dev
```

Abre **http://localhost:4173** en el navegador (Chrome o Edge recomendados).
Para detenerla, presiona **Ctrl + C** en la terminal.

Con el kit también puedes usar `2-iniciar-windows.bat` (Windows) o
`bash kit-local/iniciar-mac-linux.sh` (macOS/Linux), que además abren el
navegador.

**Primer uso:** elige **Explore Manually** y escribe `Riohacha` en el
buscador. Las claves de API son opcionales; se agregan con el botón
**POWER UP** (ver [GUIA-LA-GUAJIRA.md](GUIA-LA-GUAJIRA.md#3-claves-de-api-opcionales)).

---

## Paso 4. Abrir el proyecto en Visual Studio Code

```bash
code .
```

(o en VS Code: **Archivo → Abrir carpeta**). Mientras `npm run dev` está
activo, **cada vez que guardas un archivo el navegador se actualiza solo**.

### Mapa del proyecto: dónde cambiar cada cosa

| Quiero cambiar…                                             | Archivo o carpeta                                                                  |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| **Colores y tipografías** de toda la interfaz               | `src/ui/styles/foundation.css` (variables `--accent`, `--bg-dark`, `--font-sans`…) |
| Estilo de cada panel (botones, menús, tarjetas)             | `src/ui/styles/*.css` (uno por componente)                                         |
| **Textos y estructura** de la interfaz (título, paneles)    | `src/ui/templates/*.html` (el título está en `scene-chrome.html`)                  |
| Logo e ícono de la pestaña                                  | `public/logo.svg`                                                                  |
| Título de la pestaña del navegador                          | `index.html`                                                                       |
| **Filtros visuales** (CRT, visión nocturna, térmico, noir…) | `src/styles/*.js` (shaders GLSL) y `src/ui/visualPresets.js`                       |
| Vista inicial de la cámara                                  | `src/camera.js` (hoy apunta a Austin, Texas)                                       |
| Lugares predefinidos                                        | `src/locations.js`                                                                 |
| Capas de datos (vuelos, sismos, clima…)                     | `src/layers/<capa>/`                                                               |
| Capas propias con archivos GeoJSON (p. ej. red eléctrica)   | `src/data/infrastructure.js` y `src/data/local_data/`                              |
| Modelos 3D                                                  | `public/models/`                                                                   |
| Servidor local (proxies hacia las fuentes de datos)         | `server/`                                                                          |

### Primer ejercicio: cambiar el color principal

1. Abre `src/ui/styles/foundation.css`.
2. Cambia `--accent: #00d4ff;` (cian) por `--accent: #ffc400;` (amarillo
   eléctrico).
3. Guarda. El navegador cambia de color al instante.

Más ideas para La Guajira están en [GUIA-LA-GUAJIRA.md](GUIA-LA-GUAJIRA.md#5-por-dónde-empezar-la-adaptación-a-redes-eléctricas):
vista inicial en Riohacha, capa de subestaciones y líneas, fuentes de datos.

---

## Paso 5. Experimentar sin miedo (Git)

Dos ideas bastan:

- **Commit:** un punto de guardado. Siempre puedes volver a él.
- **Rama:** una copia paralela del proyecto para probar algo sin tocar tu
  versión estable.

### Flujo recomendado

```bash
git switch -c experimento/colores      # 1. crea una rama para el experimento
# ... haz cambios y pruébalos en el navegador ...
git add -A                             # 2. marca los cambios para guardarlos
git commit -m "Prueba de colores"      # 3. punto de guardado
git switch main                        # 4. vuelve a tu versión estable
```

Después decides:

```bash
git merge experimento/colores          # me gustó: lo llevo a main
git branch -D experimento/colores      # no me gustó: borro el experimento
```

### Comandos de rescate

| Situación                              | Comando                       |
| -------------------------------------- | ----------------------------- |
| Ver qué archivos cambié                | `git status`                  |
| Ver los cambios línea por línea        | `git diff`                    |
| Deshacer todos los cambios sin guardar | `git restore .`               |
| Deshacer cambios de un archivo         | `git restore ruta/al/archivo` |
| Ver el historial                       | `git log --oneline`           |
| Ver en qué rama estoy                  | `git branch --show-current`   |

> **Sin comandos:** en VS Code, el panel **Control de código fuente**
> (Ctrl + Shift + G) hace commits, cambia de rama y deshace cambios con
> botones. [GitHub Desktop](https://desktop.github.com/) es otra alternativa
> visual.

### Respaldar en GitHub

```bash
git push                               # sube la rama actual
git push -u origin experimento/colores # la primera vez que subes una rama nueva
```

La primera vez, Git te pedirá iniciar sesión en GitHub (se abre el navegador).

---

## Paso 6. Duplicar el proyecto (tener varias copias)

| Forma                         | Cuándo usarla                                                     |
| ----------------------------- | ----------------------------------------------------------------- |
| **Ramas** (Paso 5)            | Casi siempre. Una sola carpeta; cambias de copia con `git switch` |
| **Worktree:** segunda carpeta | Quieres dos versiones abiertas a la vez                           |
| **Clonar otra vez**           | Quieres una copia totalmente independiente                        |

**Worktree** (una segunda carpeta que comparte el mismo historial):

```bash
git worktree add ../gev-experimento -b experimento/grande
cd ../gev-experimento
npm ci
```

Para abrir las dos a la vez, la segunda necesita otro puerto:

```bash
PORT=4174 npm run dev                  # macOS/Linux
```

```powershell
$env:PORT = 4174; npm run dev          # Windows PowerShell
```

**Clonar otra vez** en otra carpeta:

```bash
git clone https://github.com/Aslin-G/God-s-Eye-View-La-Guajira-.git gev-copia-2
```

> No copies la carpeta con el explorador de archivos: `node_modules` pesa
> cientos de megabytes. Si lo haces, omite `node_modules` y ejecuta `npm ci`
> en la copia.

---

## Paso 7. Comprobar que todo sigue funcionando

Antes de llevar un cambio a `main`:

```bash
npm test                  # unas 5.000 pruebas; 1–2 minutos
npm run build             # compilación de producción
npm run format            # da formato automático al código JavaScript
```

> Algunas pruebas revisan textos y estructura de la interfaz. Si cambias,
> por ejemplo, el título de la aplicación, una prueba puede fallar a
> propósito. Lee qué prueba falló: si el cambio era intencional, actualiza la
> prueba (archivos `*.test.mjs`); si no, deshazlo con `git restore`.

---

## Paso 8. "Instalar" la versión final

- **En tu computador:** `npm run build` y luego `npm run preview`. Sirve la
  versión optimizada en http://localhost:4173.
- **Para otras personas, con un clic:** en [Pinokio](https://pinokio.co/)
  (8.2 o posterior), pega la URL de tu repositorio en el buscador → Install →
  Start.
- **En tu red local o en internet:** la app usa un servidor local que guarda
  tus claves de API. Antes de exponerla a otros equipos, lee
  [SECURITY.md](SECURITY.md).

---

## Paso 9. Traer mejoras del proyecto original

```bash
git remote add upstream https://github.com/bilawalsidhu/gods-eye-view.git   # solo la primera vez
git fetch upstream
git merge upstream/main
npm ci
npm test
```

Detalles en [GUIA-LA-GUAJIRA.md](GUIA-LA-GUAJIRA.md#4-traer-mejoras-del-proyecto-original).

---

## Paso 10. Copia de respaldo en un solo archivo (sin internet)

Git puede empaquetar **todo el proyecto con su historial completo** en un
único archivo (unos 100 MB), útil para guardarlo en un disco externo o una
memoria USB:

```bash
git bundle create ../gev-respaldo.bundle --all
```

Para restaurarlo en cualquier computador, sin conexión:

```bash
git clone gev-respaldo.bundle God-s-Eye-View-La-Guajira
cd God-s-Eye-View-La-Guajira
npm ci                     # esto sí necesita internet la primera vez
```

---

## Problemas frecuentes

| Problema                                                    | Solución                                                                                                                                                                                                                             |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `EPERM: operation not permitted` al instalar (Windows)      | Cierra la app, VS Code y otras terminales. Asegúrate de que la carpeta **no** esté en OneDrive. Agrega la carpeta como exclusión del antivirus. Borra `node_modules` (`Remove-Item -Recurse -Force node_modules`) y repite `npm ci`. |
| "git" o "node" no se reconoce como comando                  | Cierra y vuelve a abrir la terminal después de instalarlos.                                                                                                                                                                          |
| El diagnóstico dice que la versión de Node no es compatible | `node --version` debe dar 24.14+ o 26. Con nvm: `nvm install 24` y `nvm use 24`.                                                                                                                                                     |
| "La ejecución de scripts está deshabilitada" en PowerShell  | Usa los archivos `.bat` del kit, o ejecuta una vez `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.                                                                                                                            |
| El puerto 4173 está ocupado                                 | La app usa el siguiente libre. Mira en la terminal la línea `Local: http://localhost:...`.                                                                                                                                           |
| El globo se ve azul, sin imágenes                           | Revisa tu conexión a internet o el firewall. Las imágenes satelitales se descargan en vivo.                                                                                                                                          |
| Aparecen palabras como "radar" o "arrow" en lugar de íconos | La fuente de íconos de Google no cargó. Revisa la conexión y recarga la página.                                                                                                                                                      |
| Rompí algo y no sé qué                                      | `git status` para ver qué cambió y `git restore .` para volver al último commit.                                                                                                                                                     |

---

## Opcional: modificarlo con ayuda de IA

[Claude Code](https://code.claude.com/docs) funciona también en tu
computador: ábrelo dentro de la carpeta del proyecto y pídele cambios en
español ("cambia la vista inicial a Riohacha", "crea una capa con las
subestaciones de este archivo GeoJSON"). Cada cambio queda en tus archivos y
lo puedes revisar y deshacer con Git como cualquier otro.
