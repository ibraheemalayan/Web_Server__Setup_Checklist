#!/bin/bash

HIGHLIGHT='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ `whoami` != 'root' ]
  then
  
    printf "${RED}[!]${NC}${HIGHLIGHT}You must be root to run this script !\n${NC}"
    exit
fi

# if [ -z "$1" ]
#   then
#     printf "${RED}[!]${NC}No argument supplied, usage : ${HIGHLIGHT}sudo bash setup.sh {website_name}${NC}"
# fi

# Get parameters from paras file as variables
source parameters.sh

printf "${RED}[-]${NC} -- ${HIGHLIGHT}updating system ...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}apt update\n${NC}"
apt update

printf "${RED}[-]${NC} -- ${HIGHLIGHT}upgrading system ...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}apt -y upgrade\n${NC}"
apt -y upgrade

printf "${RED}[-]${NC} -- ${HIGHLIGHT}installing required apt packages ...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}apt install -y apache2 python3-pip libapache2-mod-wsgi-py3 python3-dev apache2-utils\n${NC}"
apt install -y apache2 python3-pip libapache2-mod-wsgi-py3 python3-dev apache2-utils

printf "${RED}[-]${NC} -- ${HIGHLIGHT}installing required pip packages ...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}pip3 install -r ${PathToRequirements}\n${NC}"
pip3 install -r ${PathToRequirements}

printf "${RED}[-]${NC} -- ${HIGHLIGHT}enabling apache modules (mod_wsgi, cache, cache_disk)...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}a2enmod wsgi\n${NC}"
a2enmod wsgi
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}a2enmod cache\n${NC}"
a2enmod cache
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}a2enmod cache_disk\n${NC}"
a2enmod cache_disk
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}a2enmod expires\n${NC}"
a2enmod expires
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}a2enmod headers\n${NC}"
a2enmod headers

printf "${RED}[-]${NC} -- ${HIGHLIGHT}enabling apache service...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}systemctl enable apache2\n${NC}"
systemctl enable apache2

printf "${RED}[-]${NC} -- ${HIGHLIGHT}making website directories...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}mkdir /var/www/${WebsiteName}\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}mkdir /var/www/${WebsiteName}/static\n${NC}"
mkdir /var/www/${WebsiteName}
mkdir /var/www/${WebsiteName}/static

printf "${RED}[-]${NC} -- ${HIGHLIGHT}copying static files, robots.txt and favicon.ico...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}cp -r ${StaticDirPath}/ /var/www/${WebsiteName}/static\n${NC}"
cp -r ${StaticDirPath}/ /var/www/${WebsiteName}
cp ${RobotsFilePath} /var/www/${WebsiteName}/static/
cp ${FaviconPath} /var/www/${WebsiteName}/static/

# Create and copy configuration files
printf "${RED}[-]${NC} -- ${HIGHLIGHT}Creating config files ...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}source fill_configs.sh\n${NC}"
source fill_configs.sh

printf "${RED}[-]${NC} -- ${HIGHLIGHT}Enabling ${WebsiteName} apache website (after disabling default)\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}sudo a2ensite ${WebsiteName}\n${NC}"
a2ensite ${WebsiteName}
a2dissite "000-default.conf"

printf "${RED}[-]${NC} -- ${HIGHLIGHT}Restarting apache ...\n${NC}"
printf "${RED}[<>]${NC} -- ${HIGHLIGHT}sudo systemctl restart apache2.service\n${NC}"
systemctl restart apache2.service
