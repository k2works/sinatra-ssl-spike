FROM ruby:2.2.2

RUN \
  apt-get update && \
  apt-get install -y monit && \
  apt-get install -y curl vim

# Nginx Setup
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.3-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Monit Setup
EXPOSE 2812
ADD monit/*.conf /etc/monit/conf.d/
ADD ./monit/monitrc /etc/monit/
RUN chmod 0700 /etc/monit/monitrc

# Sinatra Setup
WORKDIR /myapp
ADD ./app/Gemfile /myapp/Gemfile
ADD ./app/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --path /myapp/vendor/bundle
ADD ./app /myapp

CMD ["/usr/bin/monit", "-I", "-c", "/etc/monit/monitrc"]
