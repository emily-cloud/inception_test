FROM debian:bullseye

EXPOSE 3306

RUN apt-get update && apt-get upgrade && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

COPY /tools/script.sh .

RUN mkdir -p /run/mysqld && chmod +x script.sh

CMD ["./script.sh"]