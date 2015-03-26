#!/usr/bin/env bash

sudo apt-add-repository -y ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get install -y python-dev python-pip
sudo apt-get install -y git vim
sudo apt-get install -y nginx

sudo pip install -U pip
sudo pip install -U setuptools virtualenv pypiserver


# Server setup
mkdir -p /srv/pypi
mkdir -p /srv/deb
chown -R vagrant /srv/pypi
chown -R vagrant /srv/deb
chown -R vagrant /opt
cp /home/vagrant/code/upstart/pypi.conf /etc/init/
cp /home/vagrant/code/*.tar.gz /srv/pypi

cat <<EOF > /etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /usr/share/nginx/html;
    index index.html index.htm;

    # Make site accessible from http://localhost/
    server_name localhost;

    location /deb {
        root /srv;
        autoindex on;
    }

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}

EOF

cat <<EOF > /usr/bin/reindex
pushd /srv/deb && dpkg-scanpackages ./ /dev/null | gzip -9c > Packages.gz && popd
EOF
chmod +x /usr/bin/reindex
service nginx restart
nohup service pypi restart &
