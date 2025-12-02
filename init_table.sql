DROP DATABASE IF EXISTS tastybytes_db;
CREATE DATABASE tastybytes_db;
USE tastybytes_db;

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
    rating INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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

INSERT INTO users (username, email, password_hash) VALUES
('chef_john', 'john@example.com', 'hash123');

INSERT INTO recipes (user_id, title, description, instructions, cook_time_min, servings) VALUES
(1, 'Spaghetti Carbonara',
    'Classic Italian pasta with eggs, cheese, pancetta, and pepper.',
    '1. Cook spaghetti.\n2. Fry pancetta.\n3. Mix eggs and cheese.\n4. Combine all ingredients.',
    25, 4),
(1, 'Chocolate Chip Cookies',
    'Soft and chewy cookies loaded with chocolate chips.',
    '1. Mix dry ingredients.\n2. Cream butter and sugar.\n3. Add chocolate chips.\n4. Bake at 350°F for 12 minutes.',
    30, 24),
(1, 'Chicken Stir Fry',
    'Quick stir fried chicken and mixed vegetables with soy sauce.',
    '1. Slice chicken.\n2. Stir fry vegetables.\n3. Add chicken and sauce.\n4. Serve with rice.',
    20, 3),
(1, 'Avocado Toast with Egg',
    'Healthy breakfast toast with mashed avocado and fried egg.',
    '1. Toast bread.\n2. Mash avocado.\n3. Fry egg.\n4. Assemble toast and season.',
    10, 1),
(1, 'BBQ Grilled Chicken',
    'Juicy grilled chicken coated in smoky BBQ sauce.',
    '1. Season chicken.\n2. Grill 6 to 7 min each side.\n3. Add BBQ sauce.\n4. Grill 2 more minutes.',
    35, 4);

INSERT INTO ingredients (name) VALUES
('Spaghetti'),
('Eggs'),
('Pancetta'),
('Parmesan Cheese'),
('Black Pepper'),
('Butter'),
('Sugar'),
('Chocolate Chips'),
('Chicken Breast'),
('Broccoli'),
('Soy Sauce'),
('Rice'),
('Bread'),
('Avocado'),
('Salt'),
('BBQ Sauce'),
('Chicken Thighs'),
('Olive Oil');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(1, 1, '200g'),
(1, 2, '2'),
(1, 3, '100g'),
(1, 4, '50g'),
(1, 5, '1 tsp'),
(2, 6, '100g'),
(2, 7, '150g'),
(2, 8, '200g'),
(2, 2, '1'),
(3, 9, '250g'),
(3, 10, '1 cup'),
(3, 11, '2 tbsp'),
(3, 12, '1 cup'),
(4, 13, '1 slice'),
(4, 14, '1 whole'),
(4, 2, '1'),
(4, 15, '1 pinch'),
(4, 18, '1 tsp'),
(5, 17, '4 pieces'),
(5, 16, '3 tbsp'),
(5, 15, '1 tsp'),
(5, 18, '1 tbsp');

INSERT INTO tags (tag_name) VALUES
('Italian'),
('Dessert'),
('Quick'),
('Healthy'),
('Dinner'),
('Snack'),
('Breakfast'),
('Grilled');

INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
(1, 1),
(1, 5),
(2, 2),
(2, 6),
(3, 3),
(3, 4),
(3, 5),
(4, 4),
(4, 7),
(5, 5),
(5, 8);

INSERT INTO categories (name) VALUES
('Pasta'),
('Baking'),
('Asian'),
('Main Course'),
('Snacks'),
('Breakfast'),
('Grilling');

INSERT INTO recipe_categories (recipe_id, category_id) VALUES
(1, 1),
(1, 4),
(2, 2),
(2, 5),
(3, 3),
(3, 4),
(4, 6),
(5, 4),
(5, 7);

INSERT INTO favorite_recipes (user_id, recipe_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5);

INSERT INTO users (username, email, password_hash) VALUES
('foodlover99', 'foodlover99@example.com', 'hash_abc'),
('chef_maria', 'maria@example.com', 'hash_def'),
('homecook_sam', 'sam@example.com', 'hash_ghi'),
('baker_ella', 'ella@example.com', 'hash_jkl'),
('grillmaster_tom', 'tom@example.com', 'hash_mno'),
('quickmeals_kate', 'kate@example.com', 'hash_pqr');

INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES
(1, 1, 5, 'Authentic flavor and super easy to make!'),
(1, 3, 4, 'Really good, just added extra cheese.'),
(1, 2, 5, 'Tasted exactly like a restaurant dish.'),
(1, 1, 4, 'Quick meal, creamy and delicious.'),

(2, 1, 5, 'Perfectly chewy and full of chocolate chips!'),
(2, 4, 5, 'My kids devoured these! Best cookie recipe so far.'),
(2, 1, 4, 'Great taste. I baked them 2 minutes less for extra softness.'),
(2, 6, 5, 'Crispy edges and gooey center amazing.'),

(3, 1, 5, 'Healthy, quick, and delicious. Definitely making again!'),
(3, 7, 4, 'Great weeknight dinner. Added extra soy sauce.'),
(3, 5, 5, 'Simple and flavorful. Loved it!'),

(4, 5, 4, 'Perfect breakfast! Light and tasty.'),
(4, 1, 5, 'So simple yet so good. The fried egg is the best part.'),
(4, 2, 4, 'Easy and healthy! My new goto morning meal.'),

(5, 3, 5, 'Smoky and tender! Everyone loved it.'),
(5, 1, 4, 'Great flavor. I marinated it longer for extra tenderness.'),
(5, 6, 5, 'Restaurant quality! The BBQ glaze caramelized perfectly.');

INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES
(1, 2, 5, 'Absolutely delicious. Tasted just like what I had in Rome!'),
(1, 3, 4, 'Very good, but I added garlic for extra flavor.'),
(1, 4, 5, 'Perfect weeknight meal simple and creamy.'),
(1, 6, 4, 'Great base recipe. I used guanciale instead of pancetta.'),
(1, 7, 5, 'My kids loved it. Definitely making this again!');

INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES
(2, 2, 5, 'Soft, chewy, and not overly sweet. Perfect!'),
(2, 5, 4, 'Turned out great. I chilled the dough overnight.'),
(2, 6, 5, 'Best cookie recipe online hands down.'),
(2, 7, 4, 'Delicious! I used dark chocolate chunks.'),
(2, 4, 5, 'A huge hit at work, gone in minutes!');

INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES
(3, 3, 5, 'Fast, healthy, and super tasty.'),
(3, 4, 4, 'Nice flavor. I added mushrooms.'),
(3, 5, 5, 'My new favorite stir fry!'),
(3, 6, 4, 'Added chili flakes for heat. Worked great.'),
(3, 7, 5, 'Simple and flavorful perfect quick meal.');

INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES
(4, 2, 4, 'Great breakfast! Added lime.'),
(4, 3, 5, 'I topped it with microgreens! Amazing.'),
(4, 5, 4, 'Used sourdough. Perfect combo.'),
(4, 6, 5, 'Perfect quick meal. Highly recommend.'),
(4, 7, 4, 'Simple and tasty!');

INSERT INTO comments (recipe_id, user_id, rating, comment) VALUES
(5, 2, 5, 'Smoky, tender, and juicy.'),
(5, 3, 4, 'Marinated overnight and turned out amazing.'),
(5, 4, 5, 'Perfect summer grill recipe!'),
(5, 5, 4, 'Used homemade BBQ sauce. Such great flavor.'),
(5, 7, 5, 'My goto grilled chicken recipe now!');
