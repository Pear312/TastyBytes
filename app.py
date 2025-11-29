import mysql.connector
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

con=mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="tastybytes_db"
)


if __name__ == "__main__":
    app.run()

