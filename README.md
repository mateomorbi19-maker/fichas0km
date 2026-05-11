# fichas0km

Catálogo de fichas técnicas de autos 0km vigentes en Argentina (scrapeado de autocosmos.com.ar).

**🌐 Producción:** https://fichas0km.teotec.org

## Dos modos de uso

### 1. Web para humanos
Navegación jerárquica (marca → modelo → versión) con CSS print-friendly y botón de descarga masiva en cada marca (ZIP con todos los PDFs).

- `/` → index de marcas
- `/marcas/{slug}.html` → modelos
- `/modelos/{marca}__{modelo}.html` → versiones
- `/versiones/{id}.html` → ficha técnica completa
- `/marcas/{slug}.zip` → bulk download de PDFs por marca

### 2. API JSON para programas
Endpoints estáticos consumibles desde cualquier origen (CORS abierto). Doc completa en [`api/README.md`](api/README.md).

- `GET https://fichas0km.teotec.org/api/meta.json` → versión + stats
- `GET https://fichas0km.teotec.org/api/marcas.json` → lista de marcas
- `GET https://fichas0km.teotec.org/api/marcas/{slug}.json` → marca anidada
- `GET https://fichas0km.teotec.org/api/versiones/{id}.json` → ficha completa
- `GET https://fichas0km.teotec.org/api/dump.json` → todo el catálogo (3.4 MB)

## Stats actuales

- 56 marcas
- 402 modelos
- 771 versiones con ficha técnica completa
- 110 versiones con sección EV (`motor_electrico` + `bateria`)

## Deploy local

```bash
docker build -t fichas0km .
docker run -p 8080:80 fichas0km
```

Abrir http://localhost:8080

## Regeneración

```bash
# Desde el repo del scraper:
python -m scraper.main discover-all   # refrescar discovery
python -m scraper.main fetch          # bajar fichas pending
python -m scraper.main build-site     # regenerar HTMLs
python -m scraper.main build-pdfs     # regenerar PDFs + ZIPs
python -m scraper.main build-api      # regenerar API JSON
# Luego git push y EasyPanel redeploya.
```
