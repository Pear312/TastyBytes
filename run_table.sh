#!/bin/bash

source .env
echo "Running $SQL_FILE..."
mysql -u root < "$SQL_FILE"

echo "Done!"
