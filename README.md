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

#### リバースプロクシを確認する

    $ curl localhost:9292
    $ sudo docker exec -it web httpd-foreground &
    $ curl localhost:9292
    $ fg

## <a name="2">APサーバ</a>
## <a name="3">アプリケーション</a>

# 参照
+ [OFFICIAL REPO nginx](https://registry.hub.docker.com/_/nginx)
+ [OFFICIAL REPO httpd](https://registry.hub.docker.com/_/httpd/)
