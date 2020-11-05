#!/bin/bash
#
# written by Willians Patiño, 13h07, 25.10.2020
#
# automatization of the container tools environment


. ~/linuxenv/base/styles/setting

docker_env() { 
   if [ ! -d ~/msa ]  &&  [ ! -d /msa ]; then
      echo  'execute this command first: git clone https://github.com/wajojo/msa'
	    exit 0
   else
   # chequear si fue movido a la raiz del sistema
      if [ -d ~/msa ]; then
         sudo mv ~/msa /
	 echo -e "$OK msa has been moved to root directory"
      else
         check_msa
      fi
   fi 
   # enable Container management scripts
   if [ ! -d /deployments ]; then 
      sudo mkdir -p /deployments/manage && sudo chown -R ${USER}:${USER} /deployments
      export PATH="$PATH:/deployments/manage"
      echo -e "Deployment directory was created at /deployments."
   fi

   if [ ! -d $HOME/deployments-management ]; then
      ln -s /deployments/manage $HOME/deployments-management
   fi 

   if [ ! -d $HOME/deploy-tools ]; then
      ln -s /msa/cmt/deploy ~/deploy-tools
	echo -e " Local link has been enabled as docker-deploy"
   else
      echo -e "$OK Docker link is enabled" 
   fi
}

check_msa() {
	if [ -d /msa ]; then
	   echo -e "$OK Microservice tools are already installed at /msa "

        fi
}

 docker_env




