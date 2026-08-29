#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

until mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent >/dev/null 2>&1; do
    sleep 1
done

if [ ! -f /var/www/html/wp-config.php ]; then
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz -C /var/www/html --strip-components=1
    rm latest.tar.gz

    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb"

    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}"

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author \
        --user_pass="${WP_USER_PASSWORD}" --allow-root

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F