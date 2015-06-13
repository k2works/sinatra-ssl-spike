FROM ruby:2.2.2

RUN \
  apt-get update && \
  apt-get install -y curl vim

# Nginx Setup
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.1-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/proxy_params /etc/nginx/proxy_params
COPY ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY .ssl/ssl-sample.com.crt.pem /etc/ssl/certs/ssl-sample.com.crt.pem
COPY .ssl/ssl-sample.com.pem /etc/ssl/private/ssl-sample.com.pem

# Sinatra Setup
# Sinatra Application Setup
ADD dummyfile /data/
RUN git clone --depth 1 https://github.com/bergcloud/example-sinatra-site.git myapp
RUN mkdir -p /myapp/tmp/puma
RUN mkdir /myapp/log

WORKDIR /myapp
ADD ./app/Gemfile /myapp/Gemfile
ADD ./app/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --path /myapp/vendor/bundle
ADD ./app/config/puma.rb /myapp/config/puma.rb

# Setup
ADD start.sh /myapp/bin/
RUN chmod +x /myapp/bin/start.sh
ADD ./app /myapp

CMD ["bin/start.sh"]
