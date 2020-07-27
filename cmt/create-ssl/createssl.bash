#!/bin/bash

# W.Patino, 21.04.2020, 12h55

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
CACRT="CA.crt"

echo $(basename "$0") 

echo -e "Check  $SSLDIR..."
if [ -d "$SSLDIR" ]; then
	echo -e ":: 0 - [\e[32mCreada!\e[0m] $SSLDIR"
fi
# openssl genrsa -out $SSLDIR/$CAKEY 8192
msg=`openssl genrsa -out $SSLDIR/$CAKEY 8192 2>&1`
echo -e "[$msg\n \e[32mCreado!\e[0m] Certification Authority  $SSLDIR/$CAKEY"


echo -e ":: 1 - Creating $CACSR  using $SSLDIR/$CAKEY"
msg=`openssl req -config $CONFIGFILE \
-new -key $SSLDIR/$CAKEY -out $SSLDIR/$CACSR -nodes`
echo -e "$msg\n [\e[32mCreado!\e[0m] $SSLDIR/$CAKEY"


echo -e ":: 2 - Creating the CA's key  using: days: $validity "
echo -e "::: Out: $CACSR, signkey: $CAKEY"
msg=`openssl x509  -req  -days $validity -in $SSLDIR/$CACSR -out $SSLDIR/$CACRT -signkey $SSLDIR/$CAKEY`
echo -e "$msg\n [\e[32mCreado!\e[0m] $SSLDIR/$CACRT"


# Generate SSL certificates for the site
echo -e ":: 3 - Generating server.key key: $SSLDIR/$serverkey"
msg=$(openssl genrsa -out $SSLDIR/$serverkey 8192)
echo -e "[$msg\n \e[32mCreado!\e[0m] $SSLDIR/$CACRT"

mkdir $SSLDIR/demoCA
touch $SSLDIR/demoCA/index.txt
echo 01 > $SSLDIR/demoCA/index.txt

# 
echo -e ":: 4 - Generating $SSLDIR/$servercsr and $SSLDIR/$servercrt
using $SSLDIR/$CAKEY - $SSLDIR/$CACSR"
 msg=`openssl ca -days $validity -in $SSLDIR/$servercsr -cert $SSLDIR/$CACRT -key $SSLDIR/$CAKEY -out $SSLDIR/$servercrt`
 echo -e "$msg\n [\e[32mCreado!\e[0m] $SSLDIR/$servercrt"
