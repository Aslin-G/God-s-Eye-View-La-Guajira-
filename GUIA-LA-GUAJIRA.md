# God's Eye View — La Guajira (guía en español)

Este repositorio es una copia completa, con todo su historial de Git, del
proyecto de código abierto
[bilawalsidhu/gods-eye-view](https://github.com/bilawalsidhu/gods-eye-view)
(licencia MIT, © 2026 Bilawal Sidhu). Sirve de base para un visor 3D de
**redes eléctricas en el departamento de La Guajira (Colombia)**.

- **Punto de partida:** commit `b210ab0` de `main` en el proyecto original
  (versión `0.1.1`), con las etiquetas `v0.1.0` y `v0.1.1`.
- **Estado:** el código es el original, sin cambios funcionales. Solo se
  cambiaron los datos del repositorio (`package.json`, `CODEOWNERS`, enlaces
  de issues) y se agregaron `.nvmrc`, el kit de instalación `kit-local/` y
  las guías.
- **Para trabajar en tu computador**, paso a paso, consulta
  [GUIA-TRABAJO-LOCAL.md](GUIA-TRABAJO-LOCAL.md).

---

## 1. Requisitos

| Herramienta | Versión                                                               |
| ----------- | --------------------------------------------------------------------- |
| Node.js     | **24.x (24.14.0 o superior)** o 26.x. Node 22 y 25 no son compatibles |
| npm         | El que trae Node (11 o superior)                                      |
| Git         | Cualquier versión reciente                                            |

El archivo `.nvmrc` fija Node 24. Con `nvm` basta ejecutar `nvm use` dentro
de la carpeta.

## 2. Instalar y ejecutar

```bash
git clone https://github.com/Aslin-G/God-s-Eye-View-La-Guajira-.git
cd God-s-Eye-View-La-Guajira-
npm ci            # instala exactamente las versiones del package-lock.json
npm run doctor    # revisa Node, dependencias y claves configuradas
npm run dev       # arranca el servidor local
```

Abre **http://localhost:4173** en el navegador. En el primer inicio elige
**Explore Manually** y escribe `Riohacha` en el buscador para volar a La
Guajira.

**Con Pinokio (sin terminal):** en Pinokio → _Explore_, pega la URL de este
repositorio en el buscador (_paste a GitHub URL_) e instálalo. Usa Pinokio 8.2
o posterior.

### Comandos útiles

| Comando                    | Para qué sirve                                    |
| -------------------------- | ------------------------------------------------- |
| `npm run dev`              | Servidor de desarrollo en `http://localhost:4173` |
| `npm test`                 | Pruebas unitarias (unas 5.000, tarda 1–2 minutos) |
| `npm run build`            | Compilación de producción en `dist/`              |
| `npm run preview`          | Sirve la compilación de `dist/`                   |
| `npm run format:check`     | Revisa el formato (Prettier)                      |
| `npm run check:boundaries` | Revisa las fronteras entre módulos                |

## 3. Claves de API (opcionales)

La aplicación funciona **sin claves**: mapa satelital de Esri, terreno,
vuelos, satélites, sismos y clima. Las claves agregan funciones. Se
configuran desde la propia app con el botón **POWER UP** (esquina inferior
derecha). Se guardan en `.env`, que Git ignora, así que nunca se suben al
repositorio.

| Clave                | Qué activa                                    | Dónde obtenerla                                   |
| -------------------- | --------------------------------------------- | ------------------------------------------------- |
| Cesium ion           | 3D fotorrealista y terreno mundial            | https://cesium.com/ion (gratis, uso no comercial) |
| Google Maps          | 3D fotorrealista directo y búsqueda de Google | Google Cloud Console (con facturación)            |
| OpenAI               | Control por voz                               | https://platform.openai.com                       |
| AISStream            | Barcos en tiempo real                         | https://aisstream.io                              |
| NASA FIRMS           | Incendios activos                             | https://firms.modaps.eosdis.nasa.gov/api/         |
| TomTom               | Tráfico real                                  | https://developer.tomtom.com                      |
| OpenSky (ID/secreto) | Vuelos con menos límites                      | https://opensky-network.org                       |

La plantilla completa de variables está en `.env.example`. Más detalle en la
sección _API Keys_ del [README](README.md#-api-keys) y en
[SECURITY.md](SECURITY.md).

## 4. Traer mejoras del proyecto original

El proyecto original cambia a diario. Para incorporar sus cambios:

```bash
git remote add upstream https://github.com/bilawalsidhu/gods-eye-view.git   # solo la primera vez
git fetch upstream
git merge upstream/main
npm ci && npm test
```

Si hay conflictos, suelen aparecer en los archivos que hayas modificado para
La Guajira. Mantener el código propio en archivos y carpetas nuevas reduce
esos conflictos.

## 5. Por dónde empezar la adaptación a redes eléctricas

### 5.1 Vista inicial en La Guajira

La cámara inicial apunta a Austin (Texas). Está en `src/camera.js` (líneas 9,
56 y 68, coordenadas `-97.7431, 30.2672`). Para iniciar sobre Riohacha, usa
`-72.9072, 11.5444`. Los lugares predefinidos están en `src/locations.js`.

### 5.2 Nueva capa de red eléctrica

La plantilla más cercana son las capas de **represas** y **centros de datos**:

- `src/data/infrastructure.js` crea esas capas con `createLocalGeoJsonLayer`.
- Los datos viven en `src/data/local_data/<capa>/` en formato `.geojsonl`
  (una entidad GeoJSON por línea), junto a un `README.md` con la fuente y la
  licencia.
- La interfaz de estas capas está documentada en
  [docs/INFRASTRUCTURE-LAYERS.md](docs/INFRASTRUCTURE-LAYERS.md).

Una forma de hacerlo:

1. Crear `src/data/local_data/red_electrica_guajira/` con subestaciones,
   líneas, torres y plantas de generación.
2. Registrar la capa en `src/data/infrastructure.js`, igual que `local-dams`.
3. Si agregas módulos nuevos, regístralos en
   `scripts/package-boundaries.json` y, si se exportan, en `exports` de
   `package.json`. Después ejecuta `npm run check:boundaries`.
4. Ejecutar `npm test` y `npm run build` antes de cada `push`.

### 5.3 Fuentes de datos para Colombia y La Guajira

| Fuente                                     | Qué ofrece                                                                               | Licencia / notas                   |
| ------------------------------------------ | ---------------------------------------------------------------------------------------- | ---------------------------------- |
| OpenStreetMap (Overpass API)               | `power=line`, `power=substation`, `power=tower`, `power=plant`, `power=generator`        | ODbL: atribución y compartir igual |
| Open Infrastructure Map (openinframap.org) | Visor de los datos eléctricos de OSM, útil para revisar la cobertura                     | Mismos datos de OSM                |
| UPME                                       | Planes de expansión de transmisión y generación, información georreferenciada del sector | Revisar términos de cada conjunto  |
| XM (operador del SIN)                      | Datos de operación y del mercado (generación, demanda) mediante su API pública           | Revisar términos de uso            |
| IPSE                                       | Zonas No Interconectadas, relevantes en la Alta Guajira                                  | Revisar términos                   |

Ejemplo de consulta Overpass para la red eléctrica del departamento (el
recuadro cubre La Guajira de forma aproximada):

```
[out:json][timeout:120];
(
  way["power"="line"](10.4,-73.7,12.5,-71.1);
  node["power"="substation"](10.4,-73.7,12.5,-71.1);
  way["power"="substation"](10.4,-73.7,12.5,-71.1);
  node["power"="generator"]["generator:source"="wind"](10.4,-73.7,12.5,-71.1);
  way["power"="plant"](10.4,-73.7,12.5,-71.1);
);
out geom;
```

El proyecto ya incluye capas que sirven de contexto para una red eléctrica en
La Guajira: **viento y clima** (`src/layers/wind`, `src/layers/weather`) para
los parques eólicos, **incendios** (FIRMS) cerca de las líneas y **sismos**.

### 5.4 Qué conviene retirar o revisar

- **Cables submarinos (TeleGeography):** licencia CC BY-NC-SA, **no apta para
  uso comercial**. Si el proyecto va a ser comercial, elimina
  `src/data/local_data/telegeography_submarine_cables/`.
- **Escena de la inundación de Nepal:** también es CC BY-NC (no comercial).
- **Cámaras, ALPR y tránsito de ciudades de EE. UU. y Europa:** no aplican a
  La Guajira. Se pueden ocultar o eliminar.
- **User-Agent:** algunos servicios públicos (Overpass, CelesTrak, Nominatim)
  piden identificar la aplicación. Si publicas el proyecto, cambia las URL de
  contacto en `server/providers/overpass/constants.js`,
  `server/providers/regional/place.js`,
  `server/providers/space/celestrak.js` y `src/data/transitProxy.js`.

## 6. Licencia

El código se distribuye bajo la licencia **MIT** del autor original. Conserva
el archivo [LICENSE](LICENSE) y el aviso de copyright. Los datos de terceros
tienen sus propias licencias. Consulta [DATA_SOURCES.md](DATA_SOURCES.md) y
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
