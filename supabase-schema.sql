-- ============================================
-- SUPABASE SCHEMA PRO RECEPTY JEDNODUŠE
-- ============================================

-- 1. Tabulka kategorií
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    emoji VARCHAR(10) DEFAULT '🍴',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Tabulka receptů
CREATE TABLE IF NOT EXISTS recipes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    description TEXT,
    category_id INTEGER REFERENCES categories(id),
    image_url TEXT,
    time_minutes INTEGER DEFAULT 30,
    servings INTEGER DEFAULT 4,
    difficulty VARCHAR(20) DEFAULT 'medium', -- easy, medium, hard
    rating DECIMAL(2,1) DEFAULT 0,
    rating_count INTEGER DEFAULT 0,
    author_id UUID REFERENCES auth.users(id),
    is_public BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Tabulka ingrediencí
CREATE TABLE IF NOT EXISTS ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    amount VARCHAR(100),
    order_index INTEGER DEFAULT 0
);

-- 4. Tabulka kroků přípravy
CREATE TABLE IF NOT EXISTS steps (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    emoji VARCHAR(10) DEFAULT '👨‍🍳',
    order_index INTEGER DEFAULT 0
);

-- 5. Tabulka diet
CREATE TABLE IF NOT EXISTS diets (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    emoji VARCHAR(10) DEFAULT '🥗'
);

-- 6. Vazební tabulka recept-dieta
CREATE TABLE IF NOT EXISTS recipe_diets (
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    diet_id INTEGER REFERENCES diets(id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id, diet_id)
);

-- 7. Tabulka oblíbených receptů (pro přihlášené uživatele)
CREATE TABLE IF NOT EXISTS favorites (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, recipe_id)
);

-- 8. Tabulka hodnocení
CREATE TABLE IF NOT EXISTS ratings (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, recipe_id)
);

-- ============================================
-- INDEXY PRO RYCHLEJŠÍ VYHLEDÁVÁNÍ
-- ============================================

CREATE INDEX IF NOT EXISTS idx_recipes_category ON recipes(category_id);
CREATE INDEX IF NOT EXISTS idx_recipes_difficulty ON recipes(difficulty);
CREATE INDEX IF NOT EXISTS idx_recipes_time ON recipes(time_minutes);
CREATE INDEX IF NOT EXISTS idx_recipes_public ON recipes(is_public);
CREATE INDEX IF NOT EXISTS idx_ingredients_recipe ON ingredients(recipe_id);
CREATE INDEX IF NOT EXISTS idx_steps_recipe ON steps(recipe_id);
CREATE INDEX IF NOT EXISTS idx_favorites_user ON favorites(user_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Zapnout RLS na všech tabulkách
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

-- Policies pro recipes
CREATE POLICY "Veřejné recepty jsou viditelné pro všechny"
    ON recipes FOR SELECT
    USING (is_public = true);

CREATE POLICY "Uživatelé vidí své vlastní recepty"
    ON recipes FOR SELECT
    USING (auth.uid() = author_id);

CREATE POLICY "Přihlášení uživatelé mohou vytvářet recepty"
    ON recipes FOR INSERT
    WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Uživatelé mohou upravovat své recepty"
    ON recipes FOR UPDATE
    USING (auth.uid() = author_id);

CREATE POLICY "Uživatelé mohou mazat své recepty"
    ON recipes FOR DELETE
    USING (auth.uid() = author_id);

-- Policies pro ingredients
CREATE POLICY "Ingredience viditelné podle receptu"
    ON ingredients FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM recipes WHERE recipes.id = ingredients.recipe_id 
        AND (recipes.is_public = true OR recipes.author_id = auth.uid())
    ));

CREATE POLICY "Uživatelé mohou přidávat ingredience ke svým receptům"
    ON ingredients FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM recipes WHERE recipes.id = ingredients.recipe_id 
        AND recipes.author_id = auth.uid()
    ));

-- Policies pro steps
CREATE POLICY "Kroky viditelné podle receptu"
    ON steps FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM recipes WHERE recipes.id = steps.recipe_id 
        AND (recipes.is_public = true OR recipes.author_id = auth.uid())
    ));

-- Policies pro favorites
CREATE POLICY "Uživatelé vidí své oblíbené"
    ON favorites FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou přidávat do oblíbených"
    ON favorites FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou mazat z oblíbených"
    ON favorites FOR DELETE
    USING (auth.uid() = user_id);

-- Policies pro ratings
CREATE POLICY "Hodnocení jsou veřejně viditelná"
    ON ratings FOR SELECT
    USING (true);

CREATE POLICY "Přihlášení uživatelé mohou hodnotit"
    ON ratings FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou měnit svá hodnocení"
    ON ratings FOR UPDATE
    USING (auth.uid() = user_id);

-- ============================================
-- FUNKCE PRO AKTUALIZACI HODNOCENÍ
-- ============================================

CREATE OR REPLACE FUNCTION update_recipe_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE recipes 
    SET rating = (
        SELECT AVG(rating)::DECIMAL(2,1) 
        FROM ratings 
        WHERE recipe_id = NEW.recipe_id
    ),
    rating_count = (
        SELECT COUNT(*) 
        FROM ratings 
        WHERE recipe_id = NEW.recipe_id
    )
    WHERE id = NEW.recipe_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_rating_change
    AFTER INSERT OR UPDATE OR DELETE ON ratings
    FOR EACH ROW
    EXECUTE FUNCTION update_recipe_rating();

-- ============================================
-- VLOŽENÍ VÝCHOZÍCH DAT
-- ============================================

-- Kategorie
INSERT INTO categories (slug, name, emoji) VALUES
('snidane', 'Snídaně', '🌅'),
('obedy', 'Obědy', '🍽️'),
('vecere', 'Večeře', '🌙'),
('dezerty', 'Dezerty', '🍰'),
('zdrave', 'Zdravé', '🥗')
ON CONFLICT (slug) DO NOTHING;

-- Diety
INSERT INTO diets (slug, name, emoji) VALUES
('vegetarian', 'Vegetariánské', '🥕'),
('vegan', 'Veganské', '🌱'),
('gluten-free', 'Bezlepkové', '🌾'),
('low-carb', 'Low carb', '📉')
ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- REALTIME SUBSCRIPTIONS
-- ============================================

-- Povolit realtime pro tabulky
ALTER PUBLICATION supabase_realtime ADD TABLE recipes;
ALTER PUBLICATION supabase_realtime ADD TABLE favorites;
ALTER PUBLICATION supabase_realtime ADD TABLE ratings;
