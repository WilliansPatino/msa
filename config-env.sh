#!/bin/bash
#  by W.Patino  

#  Enable Microservice area for Docker container Deployment
#

#. ~/linuxenv/base/styles/setting

update_bash() {
	file=$1
{
	echo '# -- ' >>  ~/$file 
	echo '# Customized Docker environment - https://github.com/wajojo/msa ' 
	echo ' '
	echo 'docker_env() { '
	echo '   if [ ! -d ~/msa]; or [ ! -d /msa]; then'
	echo '      echo -e "execute this command first: git clone https://github.com/wajojo/msa" '
	echo '	    exit 0'
	echo '   else'
	echo '   # chequear si fue movido a la raiz del sistema'
	echo '      if [ -d ~/msa ]; then'
	echo '         sudo mv ~/msa /'
	echo '         if [ ! -d ~/docker-deploy ]; then'
	echo '	          ln -s /msa/cmt/deploy ~/docker-deploy'
	echo '         else'
	echo '            echo -e "$OK Docker link has been enabled" '
	echo '         fi'
	echo '      else'
	echo '         echo -e "$OK Custom console environment" '
	echo '      fi'
	echo '	    # enable Container management scripts'
	echo '      if [ ! -d /deployments ]; then '
	echo '	       sudo mkdir /deployments && sudo chown ${USER}:${USER} /deployments'
	echo '         PATH="$PATH:/deployments/manage" && export $PATH'
	echo '      fi'
	echo '   fi '
	echo '}'
	echo ' '
	echo 'if [ -f ~/msa/run-first.sh ]; then'
	echo '	 docker_env'
	echo 'else'
	echo '   if [ -d /msa ]; then'
	echo '	    echo -e "$OK Docker Microservice is available from ~/docker-deploy and" '
	echo '      echo -e "\t\tthe customized docker scripts at /deployments/manage" '
	echo '   fi'
	echo 'fi '

} >> ~/$file
echo -e "$OK $file updated!"

}

update_bash '.bashrc'
update_bash '.bash_profile'
