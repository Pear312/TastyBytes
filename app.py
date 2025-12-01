import mysql.connector
from flask import Flask, render_template, request, redirect
from flask import session
from werkzeug.security import generate_password_hash, check_password_hash
import re

app = Flask(__name__)
app.secret_key = "d93f1b063921f64b2f3ea042bd46c1f7fd0d10c55d3be98d5ea83c71e4ac6d4f"

# -----------------------------
# DATABASE CONNECTION
# -----------------------------
con = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="tastybytes_db"
)

# -----------------------------
# HOME PAGE
# -----------------------------
@app.route('/')
def index():
    cursor = con.cursor()
    cursor.execute("SELECT recipe_id, title, description FROM recipes LIMIT 6")
    recipes = cursor.fetchall()
    return render_template('index.html', recipes=recipes)


# -----------------------------
# ALL RECIPES PAGE
# -----------------------------
@app.route('/recipes')
def recipes():
    cursor = con.cursor()
    cursor.execute("SELECT recipe_id, title, description FROM recipes")
    recipes = cursor.fetchall()
    return render_template('recipe.html', recipe_list=recipes)


# -----------------------------
# SINGLE RECIPE PAGE
# -----------------------------
@app.route('/recipe/<int:recipe_id>')
def recipe(recipe_id):

    cursor = con.cursor(dictionary=True)

    # Main recipe info
    cursor.execute("SELECT * FROM recipes WHERE recipe_id=%s", (recipe_id,))
    recipe = cursor.fetchone()

    # Ingredients
    cursor.execute("""
        SELECT ingredients.name, recipe_ingredients.quantity AS qty
        FROM recipe_ingredients
        JOIN ingredients ON ingredients.ingredient_id = recipe_ingredients.ingredient_id
        WHERE recipe_ingredients.recipe_id=%s
    """, (recipe_id,))
    ingredients = cursor.fetchall()

    # Tags
    cursor.execute("""
        SELECT tags.tag_name
        FROM tags
        JOIN recipe_tags ON recipe_tags.tag_id = tags.tag_id
        WHERE recipe_tags.recipe_id=%s
    """, (recipe_id,))
    tags = [t["tag_name"] for t in cursor.fetchall()]

    # COMMENTS + USERNAME
    cursor.execute("""
        SELECT comments.rating, comments.comment, users.username
        FROM comments
        LEFT JOIN users ON comments.user_id = users.user_id
        WHERE comments.recipe_id=%s
        ORDER BY comments.comment_id DESC
    """, (recipe_id,))
    comments = cursor.fetchall()

    return render_template(
        'recipe.html',
        recipe=recipe,
        ingredients=ingredients,
        tags=tags,
        comments=comments
    )


# -----------------------------
# ADD REVIEW (Rating + Comment)
# -----------------------------
@app.route('/review/<int:recipe_id>', methods=['POST'])
def add_review(recipe_id):

    rating = request.form.get("rating")
    comment = request.form.get("comment", "").strip()

    user_id = session.get("user_id")
    if not user_id:
        return redirect("/login")

    if not rating or not comment:
        return redirect(f"/recipe/{recipe_id}")

    cursor = con.cursor()
    cursor.execute(
        "INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES (%s, %s, %s, %s)",
        (recipe_id, user_id, rating, comment)
    )
    con.commit()

    return redirect(f"/recipe/{recipe_id}")



# -----------------------------
# CREATE NEW RECIPE (GET + POST)
# -----------------------------
@app.route('/create', methods=["GET", "POST"])
def create():

    # REQUIRE LOGIN before allowing access to form OR submit
    user_id = session.get("user_id")
    if not user_id:
        return redirect("/login")

    if request.method == "POST":

        # Basic fields
        title = request.form.get("title")
        description = request.form.get("description")
        cook_time = request.form.get("cook_time")
        servings = request.form.get("servings")

        # Lists from dynamic fields
        instructions = request.form.getlist("instruction[]")
        ingredients = request.form.getlist("ingredient[]")

        # Combine instructions into a single text block
        instructions_text = "\n".join([i for i in instructions if i.strip() != ""])

        cursor = con.cursor()

        cursor.execute("""
            INSERT INTO recipes (user_id, title, description, instructions, cook_time_min, servings)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (user_id, title, description, instructions_text, cook_time, servings))

        recipe_id = cursor.lastrowid

        # INSERT INGREDIENTS INTO DATABASE
        for ing in ingredients:
            ing = ing.strip()
            if ing != "":
                cursor.execute("INSERT INTO ingredients (name) VALUES (%s)", (ing,))
                ingredient_id = cursor.lastrowid

                cursor.execute("""
                    INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity)
                    VALUES (%s, %s, %s)
                """, (recipe_id, ingredient_id, ""))

        con.commit()

        # Redirect to the brand new recipe page
        return redirect(f"/recipe/{recipe_id}")

    # GET request → show the form
    return render_template("createRecipe.html")

# -----------------------------
# USER REGISTRATION
# -----------------------------
@app.route('/register', methods=["GET", "POST"])
def register_user():
    if request.method == "POST":

        username = request.form.get("username").strip()
        email = request.form.get("email").strip().lower()
        password = request.form.get("password")

        # Basic validation
        if not username or not email or not password:
            return render_template("register.html", error="All fields are required.")

        cursor = con.cursor(dictionary=True)

        # Check if email already exists
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        exists = cursor.fetchone()
        if exists:
            return render_template("register.html", error="Email already registered.")

        # Hash password
        hashed = generate_password_hash(password)

        cursor.execute("""
            INSERT INTO users (username, email, password_hash)
            VALUES (%s, %s, %s)
        """, (username, email, hashed))

        con.commit()

        return redirect("/login")

    return render_template("register.html")


# -----------------------------
# USER LOGIN
# -----------------------------
@app.route('/login', methods=["GET", "POST"])
def login_user():
    if request.method == "POST":
        email = request.form.get("email").strip().lower()
        password = request.form.get("password")

        cursor = con.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()

        if not user or not check_password_hash(user["password_hash"], password):
            return render_template("login.html", error="Invalid email or password.")

        # Save session
        session["user_id"] = user["user_id"]
        session["username"] = user["username"]

        return redirect("/")

    return render_template("login.html")


# -----------------------------
# LOGOUT
# -----------------------------
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")



# -----------------------------
# SEARCH
# -----------------------------
@app.route('/search')
def search():
    q = request.args.get("q", "")
    cursor = con.cursor()
    cursor.execute(
        "SELECT recipe_id, title, description FROM recipes WHERE title LIKE %s",
        (f"%{q}%",)
    )
    results = cursor.fetchall()
    return render_template('recipe.html', recipe_list=results)


# -----------------------------
# RUN FLASK APP
# -----------------------------
if __name__ == "__main__":
    app.run(debug=True)