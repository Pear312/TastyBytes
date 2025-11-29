import mysql.connector
from mysql.connector import Error
from flask import Flask, render_template, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

def get_db_conn():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="tastybytes_db"
        )
        return conn
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None

@app.route('/getTables', methods=['GET'])
def get_tables():
    cursor = con.cursor()
    cursor.execute("SHOW TABLES")
    

if __name__ == "__main__":
    app.run()

