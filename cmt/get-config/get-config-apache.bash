#!/bin/bash


# por W.Patino, 18.04.2020, 17h21
#
# extract config from apache2 docker image

# IMPORTANT:
# first do:  docker pull httpd:latest

## docker pull willianspatino/httpd  # <-- correr si no existe la imagen localmente

# OLD
docker run --rm willianspatino/httpd cat /usr/local/apache2/conf/extra/httpd-ssl.conf > ./httpd-ssl.conf
docker run --rm willianspatino/httpd cat /usr/local/apache2/conf/httpd.conf > ./httpd.conf
 


