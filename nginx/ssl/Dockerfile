FROM nginx

RUN \
  apt-get update && \
  apt-get install -y monit && \
  apt-get install -y curl vim apache2

# for nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/ssl.conf /etc/nginx/conf.d/ssl.conf
COPY .ssl/ssl-sample.com.crt.pem /etc/ssl/certs/ssl-sample.com.crt.pem
COPY .ssl/ssl-sample.com.pem /etc/ssl/private/ssl-sample.com.pem

# for monit
EXPOSE 2812
ADD monit/*.conf /etc/monit/conf.d/
ADD ./monit/monitrc /etc/monit/
RUN chmod 0700 /etc/monit/monitrc

# for apache2
EXPOSE 80
COPY ./apache2/public-html/ /var/www/html/
COPY ./apache2/apache2.conf /etc/apache2/
COPY ./apache2/ports.conf /etc/apache2/
COPY ./apache2/000-default.conf /etc/apache2/sites-available/

CMD ["/usr/bin/monit", "-I", "-c", "/etc/monit/monitrc"]