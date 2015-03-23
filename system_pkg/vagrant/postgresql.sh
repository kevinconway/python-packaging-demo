#!/usr/bin/env bash

apt-get update
apt-get install -y postgresql git vim

sudo -u postgres psql -c "CREATE USER pollster WITH PASSWORD 'pollster' SUPERUSER;"
sudo -u postgres psql -c "CREATE DATABASE pollster;"
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf

service postgresql restart
