-- Drop metadata columns from atp.media
-- These columns are now used exclusively in atp.training and are redundant in atp.media

ALTER TABLE atp.media
DROP COLUMN IF EXISTS budget,
DROP COLUMN IF EXISTS revenue,
DROP COLUMN IF EXISTS runtime,
DROP COLUMN IF EXISTS origin_country,
DROP COLUMN IF EXISTS production_companies,
DROP COLUMN IF EXISTS production_countries,
DROP COLUMN IF EXISTS production_status,
DROP COLUMN IF EXISTS original_language,
DROP COLUMN IF EXISTS spoken_languages,
DROP COLUMN IF EXISTS genre,
DROP COLUMN IF EXISTS original_media_title,
DROP COLUMN IF EXISTS tagline,
DROP COLUMN IF EXISTS overview,
DROP COLUMN IF EXISTS tmdb_rating,
DROP COLUMN IF EXISTS tmdb_votes,
DROP COLUMN IF EXISTS rt_score,
DROP COLUMN IF EXISTS metascore,
DROP COLUMN IF EXISTS imdb_rating,
DROP COLUMN IF EXISTS imdb_votes;
