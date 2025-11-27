CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(255),
    email VARCHAR(255),
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id)
);

CREATE TABLE recipes (
    recipe_id INT AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(255),
    description TEXT,
    instructions TEXT,
    cook_time_min INT,
    servings INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(recipe_id),
    FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT,
    recipe_id INT,
    user_id INT,
    rating INT,
    PRIMARY KEY(comment_id),
    FOREIGN KEY(recipe_id)
        REFERENCES recipes(recipe_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE favorite_recipes (
    user_id INT,
    recipe_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, recipe_id),
    FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(recipe_id)
        REFERENCES recipes(recipe_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE tags (
    tag_id INT AUTO_INCREMENT,
    tag_name VARCHAR(255),
    PRIMARY KEY(tag_id)
);

CREATE TABLE recipe_tags (
    recipe_id INT,
    tag_id INT,
    PRIMARY KEY(recipe_id, tag_id),
    FOREIGN KEY(recipe_id)
        REFERENCES recipes(recipe_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(tag_id)
        REFERENCES tags(tag_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT,
    name VARCHAR(255),
    PRIMARY KEY(category_id)
);

CREATE TABLE recipe_categories (
    recipe_id INT,
    category_id INT,
    PRIMARY KEY(recipe_id, category_id),
    FOREIGN KEY(recipe_id)
        REFERENCES recipes(recipe_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(category_id)
        REFERENCES categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE ingredients (
    ingredient_id INT AUTO_INCREMENT,
    name VARCHAR(255),
    PRIMARY KEY(ingredient_id)
);

CREATE TABLE recipe_ingredients (
    recipe_id INT,
    ingredient_id INT,
    quantity VARCHAR(255),
    PRIMARY KEY(recipe_id, ingredient_id),
    FOREIGN KEY(recipe_id)
        REFERENCES recipes(recipe_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(ingredient_id)
        REFERENCES ingredients(ingredient_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);