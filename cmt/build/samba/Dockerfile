# Pull the latest image
FROM ubuntu:18.04

# List all the packages that we want to install
ENV PACKAGES vim ccze net-tools samba smbldap-tools
#slapd ldap-utils 

# Install Packages
RUN apt-get update && apt-get install -y $PACKAGES 
    

