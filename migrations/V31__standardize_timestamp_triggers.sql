-- V31: Standardize timestamp handling across all atp tables
--
-- This migration:
-- 1. Creates a single shared trigger function for updated_at
-- 2. Migrates all tables to use the shared function
-- 3. Backfills any NULL timestamp values
-- 4. Adds NOT NULL constraints to timestamp columns
-- 5. Ensures proper defaults are set

SET search_path TO atp;

--------------------------------------------------------------------------------
-- Create standardized trigger function
--------------------------------------------------------------------------------

-- Single shared function for all tables
CREATE OR REPLACE FUNCTION atp.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION atp.set_updated_at() IS 'Shared trigger function to set updated_at timestamp on row update';

--------------------------------------------------------------------------------
-- media table: migrate to shared trigger and ensure constraints
--------------------------------------------------------------------------------

-- Drop old trigger and recreate with shared function
DROP TRIGGER IF EXISTS update_media_updated_at ON media;
CREATE TRIGGER update_media_updated_at
    BEFORE UPDATE ON media
    FOR EACH ROW
    EXECUTE FUNCTION atp.set_updated_at();

-- Ensure defaults are set
ALTER TABLE media ALTER COLUMN created_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
ALTER TABLE media ALTER COLUMN updated_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');

-- Backfill NULL values before adding NOT NULL constraints
UPDATE media SET created_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE created_at IS NULL;
UPDATE media SET updated_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE updated_at IS NULL;

-- Add NOT NULL constraints (idempotent - no-op if already NOT NULL)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'media'
        AND column_name = 'created_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE media ALTER COLUMN created_at SET NOT NULL;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'media'
        AND column_name = 'updated_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE media ALTER COLUMN updated_at SET NOT NULL;
    END IF;
END $$;

--------------------------------------------------------------------------------
-- training table: migrate to shared trigger and ensure constraints
--------------------------------------------------------------------------------

-- Drop old trigger and function, recreate with shared function
DROP TRIGGER IF EXISTS trg_training_update_timestamp ON training;
DROP FUNCTION IF EXISTS trg_fn_training_update_timestamp();

CREATE TRIGGER trg_training_update_timestamp
    BEFORE UPDATE ON training
    FOR EACH ROW
    EXECUTE FUNCTION atp.set_updated_at();

-- Ensure defaults are set
ALTER TABLE training ALTER COLUMN created_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
ALTER TABLE training ALTER COLUMN updated_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');

-- Backfill NULL values
UPDATE training SET created_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE created_at IS NULL;
UPDATE training SET updated_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE updated_at IS NULL;

-- Add NOT NULL constraints
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'training'
        AND column_name = 'created_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE training ALTER COLUMN created_at SET NOT NULL;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'training'
        AND column_name = 'updated_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE training ALTER COLUMN updated_at SET NOT NULL;
    END IF;
END $$;

--------------------------------------------------------------------------------
-- prediction table: ensure constraints (no updated_at column exists)
--------------------------------------------------------------------------------

-- Drop orphaned trigger/function from V19 (prediction has no updated_at column)
DROP TRIGGER IF EXISTS trg_prediction_update_timestamp ON prediction;
DROP FUNCTION IF EXISTS trg_fn_prediction_update_timestamp();

-- Ensure default is set
ALTER TABLE prediction ALTER COLUMN created_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');

-- Backfill NULL values
UPDATE prediction SET created_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE created_at IS NULL;

-- created_at is already NOT NULL from V9, but ensure it stays that way
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'prediction'
        AND column_name = 'created_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE prediction ALTER COLUMN created_at SET NOT NULL;
    END IF;
END $$;

--------------------------------------------------------------------------------
-- engineered table: add trigger and ensure constraints
--------------------------------------------------------------------------------

-- Drop any existing trigger
DROP TRIGGER IF EXISTS trg_engineered_update_timestamp ON engineered;

-- Create trigger using shared function
CREATE TRIGGER trg_engineered_update_timestamp
    BEFORE UPDATE ON engineered
    FOR EACH ROW
    EXECUTE FUNCTION atp.set_updated_at();

-- Ensure defaults are set
ALTER TABLE engineered ALTER COLUMN created_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
ALTER TABLE engineered ALTER COLUMN updated_at SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');

-- Backfill NULL values
UPDATE engineered SET created_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE created_at IS NULL;
UPDATE engineered SET updated_at = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') WHERE updated_at IS NULL;

-- Add NOT NULL constraints
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'engineered'
        AND column_name = 'created_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE engineered ALTER COLUMN created_at SET NOT NULL;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp' AND table_name = 'engineered'
        AND column_name = 'updated_at' AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE engineered ALTER COLUMN updated_at SET NOT NULL;
    END IF;
END $$;

--------------------------------------------------------------------------------
-- Cleanup: remove old duplicate trigger functions
--------------------------------------------------------------------------------

-- Keep update_updated_at_column() as it may be used by other triggers on media
-- But we can drop the table-specific ones
DROP FUNCTION IF EXISTS trg_fn_training_update_timestamp();
DROP FUNCTION IF EXISTS trg_fn_prediction_update_timestamp();

--------------------------------------------------------------------------------
-- Documentation
--------------------------------------------------------------------------------

COMMENT ON TABLE media IS 'Main pipeline data for movies/TV shows. V31: Standardized timestamp triggers.';
COMMENT ON TABLE training IS 'ML training data with user labels. V31: Standardized timestamp triggers.';
COMMENT ON TABLE prediction IS 'ML model outputs with probabilities. V31: Standardized timestamp triggers.';
COMMENT ON TABLE engineered IS 'Preprocessed ML features. V31: Standardized timestamp triggers.';
