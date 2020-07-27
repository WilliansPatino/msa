#!/bin/bash

# W.Patino, 21.04.2020, 16h55

# Create Certificados SSL 

config_docker='/home/wp/docker'

CONFIGFILE="$config_docker/create-ssl/openssl.conf"

SSLDIR="$config_docker/ssl"

# default
domain="grupojules.com"

# no need changes
servercrt="$domain.crt"
serverkey="$domain.key"
servercsr="$domain.csr"

validity=1825

#--------------------------------------
# Certificacion Authority
CAKEY="CA.key"
CACSR="CA.csr"


sudo openssl req -config $CONFIGFILE -x509 -nodes -days 365 -newkey \
rsa:2048 -keyout $SSLDIR/$serverkey \
-out $SSLDIR/$servercrt

