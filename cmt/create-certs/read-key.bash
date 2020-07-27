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


config_docker='/home/wp/docker'

CONFIGFILE="$config_docker/create-certs/openssl.conf"

SSLDIR="$config_docker/certs"


domain=$1

# no need changes
servercrt="$domain.crt"
serverkey="$domain.key"
servercsr="$domain.csr"

validity=1825

openssl x509 -text -noout -in  $SSLDIR/$serverkey


exit 0


