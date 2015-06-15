FROM ruby:2.2.2

RUN \
  apt-get update && \
  apt-get install -y curl vim

# Sinatra Application Setup
ADD dummyfile /data/ 
RUN git clone --depth 1 https://github.com/bergcloud/example-sinatra-site.git myapp

WORKDIR /myapp
COPY ./app/Gemfile /myapp/Gemfile
ADD ./app/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --path /myapp/vendor/bundle

# Setup
ADD ./app /myapp

EXPOSE 9292

CMD ["rackup" , "-s" , "Puma", "-o", "0.0.0.0"]
