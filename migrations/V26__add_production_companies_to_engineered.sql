-- Add production_companies column to atp.engineered table
-- This column stores one-hot encoded production company indices as a smallint array
-- Matches the pattern used by other categorical columns (origin_country, production_countries, etc.)
-- Uses conditional DDL since column may already exist in some environments

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp'
        AND table_name = 'engineered'
        AND column_name = 'production_companies'
    ) THEN
        ALTER TABLE atp.engineered ADD COLUMN production_companies smallint[];
        COMMENT ON COLUMN atp.engineered.production_companies IS 'One-hot encoded production company indices for ML feature engineering';
    END IF;
END $$;
