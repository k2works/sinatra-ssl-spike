FROM nginx

# Install curl.
RUN \
  apt-get update && \
  apt-get install -y curl vim

COPY static-html-directory /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf
