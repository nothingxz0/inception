FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.2-fpm php8.2-mysqli php8.2-cli \
    wget curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["setup_wordpress.sh"]