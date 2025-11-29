#!/bin/bash
source .env

echo "Starting MySQL server..."
sudo systemctl start mysql

SQL_FILE="init_table.sql"

echo "Running $SQL_FILE..."
mysql -u root < "$SQL_FILE"

echo "Done!"
