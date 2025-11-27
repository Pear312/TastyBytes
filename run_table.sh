#!/bin/bash

echo "Starting MySQL server"
sudo systemctl start mysql

DB_NAME="tastybytes_db"
SQL_FILE="init_table.sql"

echo "Creating database '$DB_NAME' if it does not exist..."
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

echo "Running $SQL_FILE..."
mysql -u root -p $DB_NAME < "$SQL_FILE"

echo "Done! Database '$DB_NAME' has been initialized using '$SQL_FILE'."