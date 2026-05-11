# fichas0km — API JSON

API de solo lectura sobre el catálogo de autos 0km vigentes en Argentina
(scrapeado de autocosmos.com.ar).

- **Base URL**: `https://fichas0km.teotec.org/api/`
- **Formato**: JSON (UTF-8, minificado).
- **CORS**: `Access-Control-Allow-Origin: *` (consumible desde cualquier origen).
- **Cache**: `Cache-Control: public, max-age=300, must-revalidate` (5 minutos).
- **Versionado**: cada respuesta incluye `schema_version` y `generated_at` (ISO UTC).

## Quick test

```bash
curl https://fichas0km.teotec.org/api/meta.json
curl https://fichas0km.teotec.org/api/versiones/170292.json
```

## Endpoints

### `GET /api/meta.json`
Metadatos globales: versión del schema, fecha de generación, totales por entidad.

```json
{
  "schema_version": "1.0",
  "generated_at": "2026-05-11T17:00:00Z",
  "source": "https://www.autocosmos.com.ar/catalogo (vigentes Argentina)",
  "stats": { "marcas": 56, "modelos": 402, "versiones": 771 },
  "endpoints": { ... }
}
```

### `GET /api/marcas.json`
Lista plana de marcas con conteos. Útil para poblar selects o índices.

```json
{
  "schema_version": "1.0",
  "count": 56,
  "marcas": [
    { "slug": "toyota", "nombre": "Toyota", "n_modelos": 19, "n_versiones": 54 },
    ...
  ]
}
```

### `GET /api/marcas/{marca_slug}.json`
Marca anidada con todos sus modelos y versiones (fichas inline).

```json
{
  "schema_version": "1.0",
  "slug": "toyota",
  "nombre": "Toyota",
  "n_modelos": 19,
  "n_versiones": 54,
  "modelos": [
    {
      "slug": "hilux",
      "nombre": "Hilux",
      "n_versiones": 17,
      "versiones": [ /* ver shape abajo */ ]
    }
  ]
}
```

### `GET /api/modelos/{marca_slug}__{modelo_slug}.json`
Modelo con todas sus versiones (fichas inline). Notar el separador `__` entre marca y modelo.

```json
{
  "schema_version": "1.0",
  "slug": "hilux",
  "nombre": "Hilux",
  "marca": { "slug": "toyota", "nombre": "Toyota" },
  "n_versiones": 17,
  "versiones": [ ... ]
}
```

### `GET /api/versiones/{id}.json`
Ficha técnica completa de una versión específica + refs a marca/modelo.

```json
{
  "schema_version": "1.0",
  "id": 170292,
  "marca":  { "slug": "toyota", "nombre": "Toyota" },
  "modelo": { "slug": "hilux",  "nombre": "Hilux" },
  "version_slug": "4x4-cabina-doble-srv-28-tdi-aut",
  "nombre_completo": "Toyota Hilux 4X4 Cabina Doble SRV 2.8 TDi Aut",
  "anio": 2026,
  "url_fuente": "https://www.autocosmos.com.ar/...",
  "precio_ars": null,
  "precio_usd": null,
  "ficha": {
    "motor": {
      "combustible": "diesel",
      "cilindrada_cc": 2755,
      "potencia_cv": 204, "potencia_rpm": 3400,
      "torque_nm": 500,   "torque_rpm": "1600-2800",
      "alimentacion": "inyección directa common rail turbo intercooler",
      "cilindros": 4, "disposicion": "en línea",
      "_raw": { "valvulas": "16", "sistema_start_stop": "sí" }
    },
    "performance": { "velocidad_maxima_kmh": null, "aceleracion_0_100_s": null, ... },
    "transmision": {
      "motor_posicion": "delantero", "traccion": "integral",
      "transmision_tipo": "automática", "transmision_marchas": 6,
      "neumaticos": "265/65/R17",
      "frenos_del_tras": "discos ventilados - tambor",
      ...
    },
    "dimensiones": {
      "largo_mm": 5325, "alto_mm": 1815, "peso_kg": 2070,
      "capacidad_tanque_l": 80, "capacidad_de_carga_kg": 1020,
      "remolque_con_frenos_kg": 3500, "despeje_mm": 227,
      ...
    },
    "motor_electrico": { /* solo para EVs/híbridos */ },
    "bateria":         { /* solo para EVs/híbridos */ }
  },
  "equipamiento": {
    "confort":      { "aire_acondicionado": "climatizador bizona", ... },
    "seguridad":    { "abs": "sí", "airbag": "...", ... },
    "comunicacion": { "pantalla": "táctil de 8''", ... }
  }
}
```

### `GET /api/dump.json`
TODO el catálogo en un solo archivo (~5 MB). Útil para cargar en memoria una vez al inicio
y hacer queries arbitrarias en cliente (filtros, búsqueda fuzzy, comparaciones).

```json
{
  "schema_version": "1.0",
  "generated_at": "2026-05-11T17:00:00Z",
  "stats": { "marcas": 56, "modelos": 388, "versiones": 771 },
  "marcas": [ /* mismo shape que /api/marcas/{slug}.json */ ]
}
```

## Notas de schema

- **Precios**: `precio_ars` y `precio_usd` son mutuamente excluyentes en el sitio fuente
  (cada versión publica precio en una sola moneda). Ambos pueden ser `null` (~29% del catálogo).
- **N/D**: lo que el sitio publica como "N/D" se normaliza a `null` en JSON.
- **Campos `_raw`**: dentro de cada sección de `ficha`, el sub-objeto `_raw` preserva
  los pares clave-valor originales del sitio. Útil si necesitan info que aún no normalizamos.
- **EVs e híbridos**: incluyen secciones extra `motor_electrico` y `bateria` (110 versiones del catálogo).
- **`url_fuente`**: link al sitio original, por si necesitan re-validar manualmente algún dato.

## Cache

Los archivos JSON se sirven con headers HTTP:
- `Cache-Control: public, max-age=300, must-revalidate` (5 min)
- `Access-Control-Allow-Origin: *`

## Reportar issues

Si encuentran inconsistencias en la data o necesitan campos adicionales,
levantar un issue indicando el `id` de la versión y la URL fuente.
