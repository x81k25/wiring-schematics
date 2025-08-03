-- Create view that joins atp.training and atp.prediction tables
CREATE VIEW atp.movies AS
SELECT 
    t.imdb_id,
    t.tmdb_id,
    t.label,
    t.human_labeled,
    t.anomalous,
    t.media_type,
    t.media_title,
    t.season,
    t.episode,
    t.release_year,
    t.budget,
    t.revenue,
    t.runtime,
    t.origin_country,
    t.production_companies,
    t.production_countries,
    t.production_status,
    t.original_language,
    t.spoken_languages,
    t.genre,
    t.original_media_title,
    t.tagline,
    t.overview,
    t.tmdb_rating,
    t.tmdb_votes,
    t.rt_score,
    t.metascore,
    t.imdb_rating,
    t.imdb_votes,
    t.reviewed,
    p.prediction,
    p.probability,
    p.cm_value,
    t.created_at AS training_created_at,
    t.updated_at AS training_updated_at,
    p.created_at AS prediction_created_at
FROM atp.training t
INNER JOIN atp.prediction p ON t.imdb_id = p.imdb_id;

-- Add comment to the view
COMMENT ON VIEW atp.movies IS 'Combined view of training and prediction data joined by imdb_id';

-- Grant SELECT permissions to rear_diff user
GRANT SELECT ON atp.movies TO rear_diff;