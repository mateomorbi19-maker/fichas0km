FROM nginx:1.27-alpine

# Copia el sitio estático al document root de nginx.
COPY . /usr/share/nginx/html

# Config con CORS para /api/, gzip, y cache diferenciado por tipo.
RUN printf '%s\n' \
  'server {' \
  '  listen 80 default_server;' \
  '  server_name _;' \
  '  root /usr/share/nginx/html;' \
  '  index index.html;' \
  '' \
  '  gzip on;' \
  '  gzip_vary on;' \
  '  gzip_min_length 256;' \
  '  gzip_proxied any;' \
  '  gzip_types text/html text/css text/plain application/json application/javascript text/markdown;' \
  '' \
  '  # API JSON: CORS abierto + cache corto (5 min) - consumido por la IA de Surcars' \
  '  location /api/ {' \
  '    default_type application/json;' \
  '    types { application/json json; text/markdown md; }' \
  '    add_header Access-Control-Allow-Origin "*" always;' \
  '    add_header Access-Control-Allow-Methods "GET, OPTIONS" always;' \
  '    add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;' \
  '    add_header Cache-Control "public, max-age=300, must-revalidate" always;' \
  '    if ($request_method = OPTIONS) { return 204; }' \
  '    try_files $uri $uri.json =404;' \
  '  }' \
  '' \
  '  # ZIPs de PDFs por marca: descarga forzada' \
  '  location ~ ^/marcas/.+\.zip$ {' \
  '    add_header Content-Disposition "attachment";' \
  '    expires 1d;' \
  '  }' \
  '' \
  '  # Sitio HTML' \
  '  location / {' \
  '    try_files $uri $uri/ $uri.html =404;' \
  '  }' \
  '  location ~* \.(html|css)$ {' \
  '    expires 1h;' \
  '    add_header Cache-Control "public, must-revalidate";' \
  '  }' \
  '}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
