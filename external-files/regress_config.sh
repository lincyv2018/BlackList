#!/bin/bash

# Remove current config from /etc/nginx and copy back from backup folder
rm -rf /etc/nginx/*
cp -r /usr/share/nginx/backup/* /etc/nginx/

# Change owner to nginx on working folder group
chown -R root:nginx /etc/nginx

# Show output of nginx config test
echo
echo -e "\e[1;31mNginx config test output, do not release if output contains warnings\e[0m"
nginx -t
