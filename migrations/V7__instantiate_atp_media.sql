--------------------------------------------------------------------------------
-- schema config
--------------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS atp;
SET search_path TO atp;

--------------------------------------------------------------------------------
-- enums
--
-- note: if enums are required by one or more elements, the drop will fail
--   silently
--------------------------------------------------------------------------------

-- Create the media_type enum type
DO $$
BEGIN
    DROP TYPE IF EXISTS media_type;
    CREATE TYPE media_type AS ENUM (
        'movie',
        'tv_show',
        'tv_season',
        'unknown'
    );
EXCEPTION
    WHEN others THEN NULL;
END $$;

-- Create the pipeline_status enum type
DO $$
BEGIN
    DROP TYPE IF EXISTS pipeline_status;
    CREATE TYPE pipeline_status AS ENUM (
        'ingested',
        'paused',
        'parsed',
        'rejected',
        'file_accepted',
        'metadata_collected',
        'media_accepted',
        'downloading',
        'downloaded',
        'transferred',
        'complete'
    );
EXCEPTION
    WHEN others THEN NULL;
END $$;

-- Create the rejection_status enum type
DO $$
BEGIN
    DROP TYPE IF EXISTS rejection_status;
    CREATE TYPE rejection_status AS ENUM (
        'unfiltered',
        'accepted',
        'rejected',
        'override'
    );
EXCEPTION
    WHEN others THEN NULL;
END $$;

-- create rss_source enum type
DO $$
BEGIN
    DROP TYPE IF EXISTS rss_source;
    CREATE TYPE rss_source AS ENUM (
        'yts.mx',
        'episodefeed.com'
    );
EXCEPTION
    WHEN others THEN NULL;
END $$;

--------------------------------------------------------------------------------
-- table creation statement
--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS media (
    -- identifier column
    hash CHAR(40) PRIMARY KEY CHECK (hash ~ '^[a-f0-9]+$' AND length(hash) = 40),
    -- media information
    media_type media_type NOT NULL,
    media_title VARCHAR(255),
    season INTEGER,
    episode INTEGER,
    release_year INTEGER CHECK (release_year BETWEEN 1850 AND 2100),
    -- pipeline status information
    pipeline_status pipeline_status NOT NULL DEFAULT 'ingested',
    error_status BOOLEAN DEFAULT FALSE NOT NULL,
    error_condition TEXT,
    rejection_status rejection_status NOT NULL DEFAULT 'unfiltered',
    rejection_reason TEXT,
    -- path information
    parent_path TEXT,
    target_path TEXT,
    -- download information
    original_title TEXT NOT NULL,
    original_path TEXT,
    original_link TEXT,
    rss_source rss_source,
    uploader VARCHAR(25),
    -- metadata pertaining to the media item
    -- - other identifiers
    imdb_id VARCHAR(10) CHECK (imdb_id ~ '^tt[0-9]{7,8}$'),
    tmdb_id INTEGER CHECK (tmdb_id > 0),
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
    -- metadata pertaining to the video file
    resolution VARCHAR(10),
    video_codec VARCHAR(10),
    upload_type VARCHAR(10),
    audio_codec VARCHAR(10),
    -- timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL
);

--------------------------------------------------------------------------------
-- additional indices
--------------------------------------------------------------------------------

-- create additional indexes
CREATE INDEX IF NOT EXISTS idx_media_imdb_id ON media(imdb_id);
CREATE INDEX IF NOT EXISTS idx_media_tmdb_id ON media(tmdb_id);
CREATE INDEX IF NOT EXISTS idx_media_pipeline_status ON media(pipeline_status);
