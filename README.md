SinatraアプリケーションにおけるSSL構成検証
===
# 目的
# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| Unbuntu   　　　|14.04 LTS     |             |
| Docker         |1.6.2         |             |
| Chef Development Kit　　| 0.6.0    |             |


# 構成
+ [セットアップ](#0)
+ [Webサーバ](#1)
+ [APサーバ](#2)
+ [アプリケーション](#3)

# 詳細
## <a name="0">セットアップ</a>

    $ vagrant up
    $ vagrant ssh

## <a name="1">Webサーバ</a>
### Nginxの設定
#### Nginxのセットアップ

    $ cd /vagrant/nginx/base
    $ sudo docker build -t k2works/nginx-sample .
    $ sudo docker run --name nginx-sample -d -p 9292:80 k2works/nginx-sample
    $ crul localhost:9292
    $ sudo docker exec -it  nginx-sample /bin/bash
    # curl localhost

#### 設定ファイルをカスタムできるようにする

    $ sudo docker cp nginx-sample:/etc/nginx/nginx.conf /vagrant/nginx/base/nginx.conf
    $ mkdir conf.d
    $ sudo docker cp nginx-sample:/etc/nginx/conf.d/default.conf /vagrant/nginx/base/conf.d/

_Dockerfile_ に以下を追加する

    COPY nginx.conf /etc/nginx/nginx.conf
    COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

カスタムイメージをビルドする

    $ sudo docker build -t k2works/nginx-sample-custom .
    $ sudo docker run --name nginx-sample-custom -d k2works/nginx-sample-custom

### リバースプロキシ
#### Apacheのセットアップ

    $ sudo docker cp web:/usr/local/apache2/conf/httpd.conf /vagrant/nginx/reverse_proxy/httpd.conf
    $ sudo docker build -t k2works/revpro-sample .
    $ sudo docker run -d -p 9292:80 --name web k2works/revpro-sample

#### リバースプロキシを確認する

    $ curl localhost:9292
    $ sudo docker exec -it web service apache2 stop
    $ curl localhost:9292
    $ sudo docker exec -it web service apache2 start
    $ curl localhost:9292

### SSL
#### SSL証明書の生成にOpenSSLを使用する

1. 秘密鍵を生成する

        $ cd /vagrant/nginx/ssl
        $ mkdir .ssl
        $ openssl genrsa 2048 > .ssl/ssl-sample.com.pem

1. 証明書発行依頼書の作成

        $ openssl req -new -key .ssl/ssl-sample.com.pem -out .ssl/ssl-sample.com.csr.pem
        You are about to be asked to enter information that will be incorporated
        into your certificate request.
        What you are about to enter is what is called a Distinguished Name or a DN.
        There are quite a few fields but you can leave some blank
        For some fields there will be a default value,
        If you enter '.', the field will be left blank.
        -----
        Country Name (2 letter code) [AU]:JP
        State or Province Name (full name) [Some-State]:Hiroshima
        Locality Name (eg, city) []:Hiroshima-Shi
        Organization Name (eg, company) [Internet Widgits Pty Ltd]:Sample Corp
        Organizational Unit Name (eg, section) []:sample
        Common Name (e.g. server FQDN or YOUR name) []:www.ssl-sample.com
        Email Address []:

        Please enter the following 'extra' attributes
        to be sent with your certificate request
        A challenge password []:
        An optional company name []:

1. サーバー証明書（自己証明）の作成

        $ openssl x509 -req -days 365 -in .ssl/ssl-sample.com.csr.pem -signkey .ssl/ssl-sample.com.pem -out .ssl/ssl-sample.com.crt.pem

#### リバースプロキシをSSL対応する

設定ファイルの追加

+ _nginx/ssl/conf.d/ssl.conf_

Dockerfileの編集

+ _nginx/ssl/Dockerfile_

カスタムイメージをビルドする

    $ sudo docker build -t k2works/ssl-sample .
    $ sudo docker run -d -p 9292:443 --name web-ssl k2works/ssl-sample

#### SSLでアクセスできてかつリバースプロキシが機能しているかを確認する

    $ curl -k https://localhost:9292
    $ sudo docker exec -it web-ssl service nginx stop
    $ curl -k https://localhost:9292
    $ sudo docker exec -it web-ssl service nginx start
    $ curl -k https://localhost:9292


## <a name="2">APサーバ</a>
### Unicornの設定
#### リバースプロキシ構成（SSL無し）

    $ cd /vagrant/sinatra/unicorn/reverse_proxy/
    $ sudo docker build -t k2works/sinatra-unicorn-revpro .  
    $ sudo docker run -d -p 9292:80 --name app k2works/sinatra-unicorn-revpro

#### リバースプロキシされているか確認する

    $ curl localhost:9292/hello.rb
    hello world!

#### リバースプロキシ構成（SSLあり）

    $ cd /vagrant/sinatra/unicorn/ssl/
    $ sudo docker build -t k2works/sinatra-unicorn-ssl-revpro .  
    $ sudo docker run -d -p 9292:443 --name ssl-app k2works/sinatra-unicorn-ssl-revpro

#### リバースプロキシされているか確認する

    $ curl -k https://localhost:9292/hello.rb
    hello world!

### Pumaの設定
#### リバースプロキシ構成（SSL無し）

    $ cd /vagrant/sinatra/puma/reverse_proxy/
    $ sudo docker build -t k2works/sinatra-puma-revpro .  
    $ sudo docker run -d -p 9292:80 --name app k2works/sinatra-puma-revpro

#### リバースプロキシされているか確認する

    $ curl localhost:9292
    It works!

#### リバースプロキシ構成（SSLあり）

    $ cd /vagrant/sinatra/puma/ssl/
    $ sudo docker build -t k2works/sinatra-puma-ssl-revpro .  
    $ sudo docker run -d -p 9292:443 --name ssl-app k2works/sinatra-puma-ssl-revpro

#### リバースプロキシされているか確認する

    $ curl -k https://localhost:9292
    It works!

## <a name="3">アプリケーション</a>

# 参照
+ [OFFICIAL REPO nginx](https://registry.hub.docker.com/_/nginx)
+ [OFFICIAL REPO httpd](https://registry.hub.docker.com/_/httpd/)
+ [Dockerで複数デーモンを起動する手法をまとめてみる](https://www.hilotech.jp/blog/it/290)
+ [nginx + Unicorn + Sinatraでhello world](http://hayo0914.hatenablog.com/entry/2014/09/15/163648)
+ [puma/puma](https://github.com/puma/puma)
+ [ctalkington / Gemfile](https://gist.github.com/ctalkington/4448153)
