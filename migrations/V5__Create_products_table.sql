-- Create products table in public schema
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on name for better query performance
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);

-- Create index on category for filtering
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);