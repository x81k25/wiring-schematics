-- Create an arbitrary test table in public schema
CREATE TABLE IF NOT EXISTS public.test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    metadata JSONB
);

-- Add an index on the name column
CREATE INDEX idx_test_table_name ON public.test_table(name);

-- Add a comment to the table
COMMENT ON TABLE public.test_table IS 'Arbitrary test table for testing purposes';