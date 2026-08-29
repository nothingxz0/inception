FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/generate_ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate_ssl.sh

EXPOSE 443

ENTRYPOINT ["generate_ssl.sh"]