FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    nginx openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -subj "/C=DE/ST=Berlin/L=Berlin/O=42/OU=Inception/CN=hai.42.fr"


COPY ./conf/default /etc/nginx/sites-available/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
