#!/bin/sh

# Wait so EFS mount is ready
sleep 2

# Copy html from container → EFS
cp -r /usr/share/nginx/html/* /mnt/efs/

# Start nginx in foreground
nginx -g "daemon off;"
