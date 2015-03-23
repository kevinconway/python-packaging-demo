#!/usr/bin/env bash

sudo apt-add-repository -y ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get install -y python-dev python-pip # python2.5 python2.6 python2.7 python3.2 python3.3 python3.4
sudo apt-get install -y git vim enchant
sudo apt-get install -y postgresql-client libpq-dev nginx

sudo pip install -U pip
sudo pip install -U setuptools virtualenv tox pytest gunicorn


# Server setup
mkdir -p /srv/www/static
chown -R vagrant /srv/www/static
chown -R vagrant /opt
cp /home/vagrant/code/upstart/pollster.conf /etc/init/

cat <<EOF > /etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /usr/share/nginx/html;
    index index.html index.htm;

    # Make site accessible from http://localhost/
    server_name localhost;

    location /static {
        autoindex on;
        root /srv/www;
    }

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}

EOF
service nginx restart
