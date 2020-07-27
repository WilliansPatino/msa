#!/bin/bash


# por W.Patino, 18.04.2020, 20h06
#
# extract config from apache2 docker image


 

docker run -dit --name tzzz -p 8080:80 willianspatino/wordpress
docker cp  tzzz:/etc/apache2 ./etc_apache2
docker stop tzzz
docker rm tzzz
