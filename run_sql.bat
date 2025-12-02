@echo off
setlocal

REM Load environment variables (assuming MYSQL_PWD and SQL_FILE are set)
set /p MYSQL_PWD=Enter MySQL root password: 
set SQL_FILE=C:\Users\Ryan\Desktop\CS 480 Website\TastyBytes\init_table.sql

echo Running %SQL_FILE%...
mysql -u root -p%MYSQL_PWD% < "%SQL_FILE%"

echo Done!
pause