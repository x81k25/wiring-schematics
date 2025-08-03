-- create primary engineered table

CREATE TABLE atp.engineered (
    imdb_id varchar(10) PRIMARY KEY,
    media_title varchar(255),
    label integer,
    release_year double precision,
    budget double precision,
    revenue double precision,
    runtime double precision,
    tmdb_rating numeric(5,3),
    tmdb_votes double precision,
    rt_score double precision,
    metascore double precision,
    imdb_rating numeric(4,1),
    imdb_votes double precision,
    production_status varchar(25),
    original_language character(2),
    origin_country smallint[],
    production_countries smallint[],
    spoken_languages smallint[],
    genre smallint[],
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
    updated_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')
);

-- create normalization table 

CREATE TABLE atp.engineered_normalization_table (
    feature varchar(255),
    min double precision,
    max double precision
);

-- create feature mapping table

CREATE TABLE atp.engineered_schema (
    original_column varchar(255),
    exploded_mapping varchar(255)[]
);