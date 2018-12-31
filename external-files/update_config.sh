#!/bin/bash

# Update local repository with master copy
cd /usr/share/nginx/git-clone/alamy-nginxgateway-docker
git pull origin

# Remove old backup and replace with current files in /etc/nginx 
rm -rf /usr/share/nginx/backup/*
cp -r /etc/nginx/* /usr/share/nginx/backup

# Sync changes to nginx working folder
rm -rf /etc/nginx/{nginx.conf,enabled-sites/,includes/}
rsync -rvp --exclude ".git" --exclude="external-files" /usr/share/nginx/git-clone/alamy-nginxgateway-docker/ /etc/nginx/

# Change permissions on working folder
chown -R root:nginx /etc/nginx
chmod -R 0640 /etc/nginx/{enabled-sites,includes,includes/ipsets}
chmod 0755 /etc/nginx/{enabled-sites,includes,includes/ipsets}

# Move scripts and other files onto filesystem, set executable permission for scripts
cp external-files/alamy_50x.html /usr/share/nginx/html
cp external-files/{update_config.sh,regress_config.sh} /usr/bin
chmod 0755 /usr/bin/{update_config.sh,regress_config.sh}
chmod +x /usr/bin/{update_config.sh,regress_config.sh}

# Show output of nginx config test
echo
echo -e "\e[1;31mNginx config test output, do not release if output contains warnings\e[0m"
nginx -t
