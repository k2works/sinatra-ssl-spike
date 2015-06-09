FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN \
  apt-get update && \
  apt-get install -y curl vim apache2

COPY ./public-html/ /var/www/html/
COPY ./apache2.conf /etc/apache2/
COPY ./ports.conf /etc/apache2/
COPY ./000-default.conf /etc/apache2/sites-available/

RUN mkdir /myapp
WORKDIR /myapp
ADD start.sh /myapp/bin/
RUN chmod +x /myapp/bin/start.sh
ADD . /myapp

CMD ["bin/start.sh"]
