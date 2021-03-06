#!/bin/bash

# W.Patino, 10.4.2020, 20h21
#
#   --- Generador de container para Web Service basado en Apache 2 ---
#
#  CHANGESLOG
#
#   - 13.4.2020  Modificacion del código para automatizar tareas.
#   - 14.4.2020	- entrada especifica de puerto, nombre del contrainer
#			refiere a estos.
#   - 15.4.2020  - agregar puerto SSL/HTTPS y volumen config apache2 
#   - 18.4.2020 new code writing; dir validation, tag, 
#   - 21.4.2020 creacion de certificados SSL, parametrizacion mas detallada
#               validacion de container, creacion de tools para el container
#
##############################################################
#       IMPORTANT
#
#     FIRST OF ALL:  create ssl certificates (.crt/.key)
#                   and save into:  ~/docker/certs
##############################################################
clear && echo -e " $(basename "$0") " 


#--- únicos parámetros asignados por el administrador 

# servers where will be running docker/containers
server_ip="192.168.250.5"

container_name="w3"    ##  Solo esto indica el usuario

# default
domain="kensai.redirectme.net"

# ruta de configs docker
config_docker='/home/wp/docker'

# ruta base del directorio principal para el container
base_dir='/home/wp/containers'

SSLDIR="$config_docker/ssl"
CONFIGFILE="$config_docker/create-ssl/openssl.conf"


# httpd config
html_dir="www"                  # html files
apache2_config="httpd_config"   # httpd configuration (Apache2)
certs="certs"                   # Certificates SSL
run="$base_dir/run"                       # scripts;  run, start, stop...

# Images and ports for create and exposing the container
public_html_port="8095"
private_html_port="443"
httpd_image="ppwillians/apache_ssh"

# httpd tweaks
oldSSLCertificateFile="server.crt"
oldSSLCertificateKeyFile="server.key"

# Certificates SSL :: IMPORTANT: Must be created before run this
servercrt="$domain.crt"
serverkey="$domain.key"
validity="1800"



if [ -f "$SSLDIR/$servercrt" ] && [ "$SSLDIR/$serverkey" ]; then
   echo -e "$msg\n [\e[32mOK\e[0m] Certificados SSL "
else
  echo -e "[\e[31mError!\e[0m] Debe crearse los Certificados en $FILE"
  
  # create SSL certificates
  msg=`sudo openssl req -config $CONFIGFILE -x509 -nodes -days $validity -newkey \
  rsa:8192 -keyout $SSLDIR/$serverkey \
  -out $SSLDIR/$servercrt`
  echo "$msg"
  echo -e "$msg\n [\e[32mCreado!\e[0m] Certificados SSL "
fi


# SSL certificates readable
msg=$(sudo chmod 644 $SSLDIR/$servercrt $SSLDIR/$serverkey)
echo "$msg"
msg=$(ls -lpa $SSLDIR/$domain.*)
echo -e "$msg\n"


# Incluye html as default for apache
install_httpd=false

#---  assign containers's names
if [ $install_httpd ];
then
  apache_container_tag='.'$public_html_port
  apache_container_name=$container_name$apache_container_tag
  #- just only control 
  #echo -e ":: apache container TAG: $apache_container_tag"
  #----container_name=$container_name$apache_container_tag
  echo -e ":: Container: $apache_container_name"
fi

#-- Final container name
container_name=$container_name$apache_container_tag
#---echo -e "\nFinal container name: \n\t$container_name"
container_dir=$base_dir/$container_name
#-- END name assigment


echo -e "Container tools: $run"
#--in case any error --- script for the container,  stop, start, remove
if [  ! -d "$run" ]; then
  msg=`mkdir -p $run`
fi
  echo -e "$msg"
  echo "docker stop $container_name" > $base_dir/run/stop_$container_name
  echo "docker start $container_name" > $base_dir/run/start_$container_name
  echo "docker stop $container_name" > $base_dir/run/remove_$container_name
  echo "docker rm $container_name"  >> $base_dir/run/remove_$container_name
  echo "sudo rm -rf $container_dir" >> $base_dir/run/remove_$container_name
  echo "ls $base_dir" >> $base_dir/run/remove_$container_name
  echo "docker ps -a " >> $base_dir/run/remove_$container_name
  msg=$(chmod ug+x $base_dir/run/*)
  echo -e "$msg"

#ExistContainer=false
#----- apache -----# 
echo "Checking $container_dir"
if [ $install_httpd ]; then
    # create base dir for container
    if [  -d "$container_dir" ]; then
        echo -e "\t\e[31m$container_dir ya existe\e[0m"
        #msg=`ls $container_dir`
        echo -e "$msg"
        ExistContainer=true
    else
        msg=$(mkdir -p $container_dir)
        echo -e "[NUEVO] $msg "
        #echo -e "\t\e[32m$container_dir fue creado nuevo\e[0m"
        ExistContainer=false
    #fi

    #if [ ! $ExistContainer ]; then
      echo -e "\n:: Creando repositorios para apache"
      #echo -e ":: apache container: $apache_container_name"
  
      echo -e "$container_dir/$html_dir"
      mkdir -p $container_dir/$html_dir

      echo -e "$container_dir/$apache2_config"
      mkdir -p $container_dir/$apache2_config 
      rsync -a $config_docker/etc/httpd/apache2/conf/ $container_dir/$apache2_config/

      # Change hostname ServerName - httpd.conf
      sed -i  \
       -e "s/^#ServerName www.example.com/ServerName $server_ip/g" $container_dir/$apache2_config/httpd.conf    
 
      sed -i \
      -e "s/^#ServerName www.example.com/ServerName $server_ip/g" $container_dir/$apache2_config/extra/httpd-ssl.conf


      # change  extra config SSL to listen on port 443
      sed -i \
        -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
       $container_dir/$apache2_config/httpd.conf

      #  change certificates pathfile 
      sed -i \
      -e "s|$oldSSLCertificateFile|$servercrt|g" \
      -e "s|$oldSSLCertificateKeyFile|$serverkey|g" \
      $container_dir/$apache2_config/extra/httpd-ssl.conf

      #echo -e "$container_dir/$certs"  
      #mkdir -p $container_dir/$certs 
      rsync -a $config_docker/ssl/$servercrt $container_dir/$apache2_config/
      rsync -a $config_docker/ssl/$serverkey $container_dir/$apache2_config/
    
      echo -e "\n< Image: $httpd_image >\nInicia creación container $apache_container_name"

  
      docker run --name "$apache_container_name" \
      -p $public_html_port:$private_html_port \
      -v $container_dir/$html_dir:/usr/local/apache2/htdocs/ \
      -v $container_dir/$apache2_config:/usr/local/apache2/conf/ \
      -d $httpd_image 
    fi 
    echo "Bye!"
    
fi
# END apache
echo -e "Container info:"
tree -L 2 $container_dir
echo -e "Containers: \n\t1) $apache_container_name"

