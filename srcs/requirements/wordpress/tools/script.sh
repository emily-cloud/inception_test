#!/bin/bash

# Navigate to WordPress directory
cd /var/www/html

# Download and setup WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Download WordPress core
./wp-cli.phar core download --allow-root

# Create wp-config.php with environment variables
./wp-cli.phar config create \
    --dbname=${WORDPRESS_NAME} \
    --dbuser=${WORDPRESS_USER} \
    --dbpass=${WORDPRESS_PASSWORD} \
    --dbhost=${WORDPRESS_HOST} \
    --allow-root

# Install WordPress with admin user from environment variables
./wp-cli.phar core install \
    --url=${DOMAIN_NAME} \
    --title="Inception WordPress" \
    --admin_user=${WORDPRESS_ADMIN_USER} \
    --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
    --admin_email=${WORDPRESS_ADMIN_EMAIL} \
    --allow-root

# Create the normal user if variables are provided
if [ -n "${WORDPRESS_USER_NAME}" ] && [ -n "${WORDPRESS_USER_PASSWORD}" ]; then
    ./wp-cli.phar user create ${WORDPRESS_USER_NAME} ${WORDPRESS_USER_EMAIL} \
        --role=author \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --allow-root
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
php-fpm7.4 -F