import mysql.connector
from flask import Flask, render_template, request, redirect
import re

app = Flask(__name__)

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

    # Placeholder until login system exists
    user_id = 1

    # Must have BOTH
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
@app.route('/create', methods=['GET', 'POST'])
def create():

    if request.method == "GET":
        return render_template('createRecipe.html')

    # -------------------------
    # Process the form submission
    # -------------------------

    title = request.form.get("title")
    description = request.form.get("description")

    # Clean cook time (strip "min", "minutes", etc.)
    cook_time_raw = request.form.get("cook_time", "").strip()
    cook_time = int(re.sub(r"\D", "", cook_time_raw) or 0)

    # Clean servings
    servings_raw = request.form.get("servings", "").strip()
    servings = int(re.sub(r"\D", "", servings_raw) or 0)

    instructions_list = request.form.getlist("instructions")
    instructions = "\n".join(instructions_list)

    ingredients_list = request.form.getlist("ingredients")

    cursor = con.cursor()

    # Insert recipe
    cursor.execute("""
        INSERT INTO recipes (user_id, title, description, instructions, cook_time_min, servings)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (1, title, description, instructions, cook_time, servings))

    con.commit()

    recipe_id = cursor.lastrowid

    # Insert ingredients
    for ing in ingredients_list:
        ing = ing.strip()
        if ing == "":
            continue

        cursor.execute("INSERT INTO ingredients (name) VALUES (%s)", (ing,))
        ingredient_id = cursor.lastrowid

        cursor.execute(
            "INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES (%s, %s, %s)",
            (recipe_id, ingredient_id, ""))
        con.commit()

    return redirect(f"/recipe/{recipe_id}")


# -----------------------------
# LOGIN / REGISTER
# -----------------------------
@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/register')
def register():
    return render_template('register.html')


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
