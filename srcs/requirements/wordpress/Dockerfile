
FROM debian:bullseye

EXPOSE 9000

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysqli curl \
    && rm -rf /var/lib/apt/lists/*

COPY ./conf/www.conf  /etc/php/7.4/fpm/pool.d/.
COPY ./tools/script.sh .

RUN chmod +x script.sh

# Create /run/php here and set proper ownership
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

CMD ["./script.sh"]
