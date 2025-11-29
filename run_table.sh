#!/bin/bash
source .env

echo "Running $SQL_FILE..."
mysql -u root -p"$MYSQL_PWD" < "$SQL_FILE"

echo "Done!"