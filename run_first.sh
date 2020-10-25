#!/bin/bash
#
# written by Willians Patiño, 13h07, 25.10.2020
#
# automatization of the container tools environment


. ~/linuxenv/base/styles/setting

update_bash() {
	file=$1
{
	echo '# -- ' >>  ~/$file 
	echo '# Customized Docker environment - https://github.com/wajojo/msa ' 
	echo ' '
	echo 'bash /msa/check_env'

} >> ~/$file
echo -e "$OK $file updated!"

}

update_bash '.bashrc'
update_bash '.bash_profile'
