--------------------------------------------------------------------------------
-- schema config
--------------------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_namespace WHERE nspname = 'atp'
    ) THEN
        RAISE EXCEPTION 'Schema "atp" does not exist';
    END IF;
END $$;

SET search_path TO atp;

--------------------------------------------------------------------------------
-- enums
--
-- requires the following enums from _00_instantiate-schema.sql
-- - media_type
--------------------------------------------------------------------------------


-- Create the label enum type
DO $$
BEGIN
    DROP TYPE IF EXISTS label_type;
    CREATE TYPE label_type AS ENUM (
        'would_watch',
        'would_not_watch'
    );
EXCEPTION
    WHEN others THEN NULL;
END $$;

--------------------------------------------------------------------------------
-- table creation statement
--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS training (
    -- identifier columns
    imdb_id VARCHAR(10) PRIMARY KEY CHECK (imdb_id ~ '^tt[0-9]{7,8}$'),
    tmdb_id INTEGER UNIQUE CHECK (tmdb_id > 0),
    -- label columns
    label label_type NOT NULL,
    -- flag columns
    human_labeled BOOLEAN NOT NULL DEFAULT FALSE,
    confirmed BOOLEAN NOT NULL DEFAULT FALSE,
    anomalous BOOLEAN NOT NULL DEFAULT FALSE,
    -- media identifying information
    media_type media_type NOT NULL,
    media_title VARCHAR(255) NOT NULL,
    season SMALLINT,
    episode SMALLINT,
    release_year SMALLINT CHECK (release_year BETWEEN 1850 AND 2100) NOT NULL,
    -- metadata pertaining to the media item
    -- - quantitative details
    budget BIGINT CHECK (budget >= 0),
    revenue BIGINT CHECK (revenue >= 0),
    runtime INTEGER CHECK (runtime >= 0),
    -- - country and production information
    origin_country CHAR(2)[],
    production_companies VARCHAR(255)[],
    production_countries CHAR(2)[],
    production_status VARCHAR(25),
    -- - language information
    original_language CHAR(2),
    spoken_languages CHAR(2)[],
    -- - other string fields
    genre VARCHAR(20)[],
    original_media_title VARCHAR(255),
    -- - long string fields
    tagline VARCHAR(255),
    overview TEXT,
    -- - ratings info
    tmdb_rating DECIMAL(5,3) CHECK (tmdb_rating BETWEEN 0 AND 10),
    tmdb_votes INTEGER CHECK (tmdb_votes >= 0),
    rt_score INTEGER CHECK (rt_score IS NULL OR (rt_score BETWEEN 0 AND 100)),
    metascore INTEGER CHECK (metascore IS NULL OR (metascore BETWEEN 0 AND 100)),
    imdb_rating DECIMAL(4,1) CHECK (imdb_rating IS NULL OR (imdb_rating BETWEEN 0 AND 100)),
    imdb_votes INTEGER CHECK (imdb_votes >= 0),
    -- timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL
);

--------------------------------------------------------------------------------
-- additional indices
--------------------------------------------------------------------------------

-- create additional indexes
CREATE INDEX IF NOT EXISTS idx_training_tmdb_id ON training(tmdb_id);