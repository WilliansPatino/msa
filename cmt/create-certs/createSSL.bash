#!/bin/bash

# W.Patino, 21.04.2020, 16h55

# Create Certificados SSL 

#  es necesario ingresar el dominio
if [ -z "$1" ]; then
      echo "Debe ingresar un dominio"
      exit 1
else
      echo "Dominio: $1"
fi


if [ -z "$2" ]; then
      echo "Debe ingresar la ubicación del openssl.conf en su forma: /path/dir/openssl.conf"
      exit 1
else
      echo "Dominio: $2"
fi

config_docker='/home/wp/docker'

#CONFIGFILE="$config_docker/create-certs/openssl.conf"
CONFIGFILE=$2

SSLDIR="$config_docker/certs"

if [ -f $CONFIGFILE ]; then
      echo "Se utilizará: $CONFIGFILE"
else
      echo "Es necesario un archivo de config openssl.conf"
fi

domain=$1

# no need changes
servercrt="$domain.crt"
serverkey="$domain.key"
servercsr="$domain.csr"

validity=1825



sudo openssl req -config $CONFIGFILE -x509 -nodes -days $validity -newkey \
rsa:2048 -keyout $SSLDIR/$serverkey \
-out $SSLDIR/$servercrt

sudo chmod 644 $SSLDIR/$servercrt $SSLDIR/$serverkey 

echo -e "Los certificados puede encontrar en: $SSLDIR"

