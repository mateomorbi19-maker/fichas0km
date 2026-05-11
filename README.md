# fichas0km

Sitio estático con fichas técnicas de autos 0km vigentes en Argentina, generado a partir del catálogo de autocosmos.com.ar.

## Estructura

```
.
├── index.html                          # listado de marcas
├── styles.css                          # estilos (incluye @media print)
├── marcas/{slug}.html                  # modelos por marca
├── modelos/{marca}__{modelo}.html      # versiones por modelo
├── versiones/{id}.html                 # ficha técnica completa
└── Dockerfile                          # nginx:alpine para deploy
```

## Deploy local

```bash
docker build -t fichas0km .
docker run -p 8080:80 fichas0km
```

Abrir http://localhost:8080

## Uso

Cada ficha tiene un botón **Imprimir / Guardar PDF** que dispara el diálogo de impresión del navegador. El CSS oculta navegación y footer, compactando tipografía y márgenes para que el PDF salga prolijo.

## Regeneración

Generado a partir de [autocosmos-scraper](../) corriendo:

```
python -m scraper.main build-site
```

Esto regenera todos los HTMLs preservando `.git/`, `Dockerfile`, `.gitignore` y este README.
