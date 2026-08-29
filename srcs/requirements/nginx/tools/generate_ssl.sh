#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MA/ST=Oriental/L=Nador/O=1337/OU=Student/CN=${DOMAIN_NAME}"
    chmod 600 /etc/nginx/ssl/inception.key
    chmod 644 /etc/nginx/ssl/inception.crt
fi

envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

nginx -t
exec nginx -g "daemon off;"