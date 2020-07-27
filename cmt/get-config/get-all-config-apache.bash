#!/bin/bash


# por W.Patino, 18.04.2020, 20h06
#
# extract config from apache2 docker image

######  IMPORTANTE   ###########33
#
#
#      es necesario contar con la imagen ppwillians/apache_ssh
#
#####################

 

docker run -dit --name tzzz -p 8080:80 willianspatino/httpd
docker cp  tzzz:/usr/local/apache2 ./
docker stop tzzz
docker rm tzzz
