# TastyBytes

## Env for database
- Create .env file and put the following inside (replace yourpassword)
```
SQL_FILE=init_table.sql
MYSQL_PWD=yourpassword
```

## Start database (macOS w/ homebrew)
- chmod +x run_table.sh
- brew install mysql
- brew services start mysql
- ./run_table.sh