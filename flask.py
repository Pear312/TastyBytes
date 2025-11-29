import mysql.connector
from flask import Flask

app = Flask(__name__)

con=mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="tastybytes"
)

