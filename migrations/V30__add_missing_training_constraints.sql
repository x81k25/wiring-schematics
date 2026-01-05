-- V30: Add missing constraints to atp.training table
-- Production is missing 9 constraints that exist in dev/staging:
-- 1 PRIMARY KEY, 1 UNIQUE, 7 CHECK constraints
-- This migration is idempotent - skips constraints that already exist

-- First, set imdb_id to NOT NULL (required for PRIMARY KEY)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'atp'
        AND table_name = 'training'
        AND column_name = 'imdb_id'
        AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE atp.training ALTER COLUMN imdb_id SET NOT NULL;
    END IF;
END $$;

-- Add PRIMARY KEY on imdb_id (required for ON CONFLICT upserts)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_pkey'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_pkey PRIMARY KEY (imdb_id);
    END IF;
END $$;

-- Add UNIQUE constraint on tmdb_id
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_tmdb_id_key'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_tmdb_id_key UNIQUE (tmdb_id);
    END IF;
END $$;

-- Add CHECK constraint for imdb_id format (tt followed by 7-8 digits)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_imdb_id_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_imdb_id_check
            CHECK (imdb_id ~ '^tt[0-9]{7,8}$');
    END IF;
END $$;

-- Add CHECK constraint for imdb_rating (0-100 or NULL)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_imdb_rating_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_imdb_rating_check
            CHECK (imdb_rating IS NULL OR (imdb_rating >= 0 AND imdb_rating <= 100));
    END IF;
END $$;

-- Add CHECK constraint for imdb_votes (non-negative)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_imdb_votes_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_imdb_votes_check
            CHECK (imdb_votes >= 0);
    END IF;
END $$;

-- Add CHECK constraint for metascore (0-100 or NULL)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_metascore_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_metascore_check
            CHECK (metascore IS NULL OR (metascore >= 0 AND metascore <= 100));
    END IF;
END $$;

-- Add CHECK constraint for release_year (1850-2100)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_release_year_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_release_year_check
            CHECK (release_year >= 1850 AND release_year <= 2100);
    END IF;
END $$;

-- Add CHECK constraint for rt_score (0-100 or NULL)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_rt_score_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_rt_score_check
            CHECK (rt_score IS NULL OR (rt_score >= 0 AND rt_score <= 100));
    END IF;
END $$;

-- Add CHECK constraint for tmdb_id (positive integer)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'training_tmdb_id_check'
        AND conrelid = 'atp.training'::regclass
    ) THEN
        ALTER TABLE atp.training ADD CONSTRAINT training_tmdb_id_check
            CHECK (tmdb_id > 0);
    END IF;
END $$;

-- Add comment documenting this migration
COMMENT ON TABLE atp.training IS 'ML training data with user labels. V30: Added missing constraints to match dev/staging schema.';
