#!/bin/bash

# Always ensure the database and user are set up correctly
echo "Setting up MariaDB database and user..."

# Check if MySQL data directory is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL data directory..."
    # Initialize MySQL data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MySQL temporarily to set up database and user
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Set root password
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');

-- Create database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create user and grant permissions
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    echo "MySQL initialization completed."
else
    echo "MySQL data directory exists. Ensuring user and database are configured..."
    
    # Start MySQL in background to create user if needed
    mysqld --user=mysql --skip-networking --socket=/tmp/mysql_temp.sock &
    MYSQL_PID=$!
    
    # Wait for MySQL to start
    sleep 5
    
    # Connect and ensure database and user exist
    mysql -u root -p${MYSQL_ROOT_PASSWORD} --socket=/tmp/mysql_temp.sock << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    
    # Stop the temporary MySQL process
    kill $MYSQL_PID
    wait $MYSQL_PID
    
    echo "User and database configuration completed."
fi

# Start MySQL server
echo "Starting MariaDB server..."
exec mysqld --user=mysql