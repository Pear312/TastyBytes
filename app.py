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
    conn = get_db_conn()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor()
    cursor.execute("SHOW TABLES")
    tables = [row[0] for row in cursor.fetchall()]

    cursor.close()
    conn.close()

    return jsonify({"tables": tables})

@app.route("/recipes", methods=["GET"])
def get_recipes():
    conn = get_db_conn()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM recipes")
    recipes = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(recipes)

if __name__ == "__main__":
    app.run()

