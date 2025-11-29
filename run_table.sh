#!/bin/bash

echo "Running $SQL_FILE..."
mysql -u root < "$SQL_FILE"

echo "Done!"
