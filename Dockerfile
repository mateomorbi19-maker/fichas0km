FROM nginx:1.27-alpine

# Copia el sitio estático al document root de nginx.
COPY . /usr/share/nginx/html

# Sobrescribe la config con caching agresivo para HTML/CSS (cambian poco)
# y compresión gzip para servir más liviano.
RUN printf '%s\n' \
  'server {' \
  '  listen 80 default_server;' \
  '  server_name _;' \
  '  root /usr/share/nginx/html;' \
  '  index index.html;' \
  '  gzip on;' \
  '  gzip_types text/html text/css application/javascript;' \
  '  location / {' \
  '    try_files $uri $uri/ $uri.html =404;' \
  '  }' \
  '  location ~* \.(html|css)$ {' \
  '    expires 1h;' \
  '    add_header Cache-Control "public, must-revalidate";' \
  '  }' \
  '}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
