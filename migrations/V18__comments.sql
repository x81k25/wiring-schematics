SET search_path TO atp;

--------------------------------------------------------------------------------
-- media comments
--------------------------------------------------------------------------------

-- add table comment
COMMENT ON TABLE media IS 'stores media data for movies, tv shows, and tv seasons';

-- identifier column
COMMENT ON COLUMN media.hash IS 'primary key; unique identifier; and primary element for interaction with transmission';
-- media information
COMMENT ON COLUMN media.media_type IS 'either movie, tv_shows, or tv_season';
COMMENT ON COLUMN media.media_title IS 'either movie or tv show title';
COMMENT ON COLUMN media.season IS 'media season if tv show or tv season; null for movies';
COMMENT ON COLUMN media.episode IS 'episode number within season for tv show, otherwise null';
COMMENT ON COLUMN media.release_year IS 'year the movie was released or the year of the first season of a tv show';
-- pipeline status information
COMMENT ON COLUMN media.pipeline_status IS 'status within the automatic transmission pipeline';
COMMENT ON COLUMN media.error_status IS 'boolean value documenting errors occurring during pipeline';
COMMENT ON COLUMN media.error_condition IS 'details on error status';
COMMENT ON COLUMN media.rejection_status IS 'rejection status based on filters within filter-parameters.json';
COMMENT ON COLUMN media.rejection_reason IS 'details on which filter flags were tagged, if rejection was caused';
-- path information
COMMENT ON COLUMN media.parent_path IS 'parent dir of media library location for item';
COMMENT ON COLUMN media.target_path IS 'file or dir path for media library location';
-- download information
COMMENT ON COLUMN media.original_title IS 'raw item title string value; used for parsing other field values';
COMMENT ON COLUMN media.original_path IS 'original path of item within media-cache';
COMMENT ON COLUMN media.original_link IS 'may contain either the direct download link or the magnet link';
COMMENT ON COLUMN media.rss_source IS 'source of rss feed for item ingestion, if any';
COMMENT ON COLUMN media.uploader IS 'uploading entity of the media item';
-- metadata pertaining to the media item
-- - other id fields
COMMENT ON COLUMN media.imdb_id IS 'from TMDB; IMDB identifier for media item';
COMMENT ON COLUMN media.tmdb_id IS 'from TMDB; identifier for themoviedb.org API';
-- - quantitative details
COMMENT ON COLUMN media.budget IS 'from TMDB; production budget of media item';
COMMENT ON COLUMN media.revenue IS 'from TMDB; current revenue of media item';
COMMENT ON COLUMN media.runtime IS 'from TMDB; runtime in minutes of media item';
-- - country and production information
COMMENT ON COLUMN media.origin_country IS 'from TMDB; primary country of production in iso_3166_1 format';
COMMENT ON COLUMN media.production_companies IS 'from TMDB; array of production companies';
COMMENT ON COLUMN media.production_countries IS 'from TMDB; array of countries where media item was produced in iso_3166_1 format';
COMMENT ON COLUMN media.production_status IS 'from TMDB; current production status of media item';
-- - language information
COMMENT ON COLUMN media.original_language IS 'from TMDB; primary language of media item in ISO 639 format';
COMMENT ON COLUMN media.spoken_languages IS 'from TMDB; array of languages available encoded in ISO 639 format';
-- - other string fields
COMMENT ON COLUMN media.genre IS 'from TMDB; array of genres associated with the movie';
COMMENT ON COLUMN media.original_media_title IS 'from TMDB; original title of media item';
-- - long string fields
COMMENT ON COLUMN media.tagline IS 'from TMDB; tagline for the media item';
COMMENT ON COLUMN media.overview IS 'from TMDB; brief plot synopsis of media item';
-- - ratings info
COMMENT ON COLUMN media.tmdb_rating IS 'from TMDB; rating submitted by TMDB users out of 10';
COMMENT ON COLUMN media.tmdb_votes IS 'from TMDB; number of ratings by TMDB users';
COMMENT ON COLUMN media.rt_score IS 'from OMDb; Rotten Tomatoes score out of 100';
COMMENT ON COLUMN media.metascore IS 'from OMDb; MetaCritic score out of 100';
COMMENT ON COLUMN media.imdb_rating IS 'from OMDb; IMDB rating out of 100';
COMMENT ON COLUMN media.imdb_votes IS 'from OMDb; number of votes on IMDB';
-- metadata pertaining to the video file
COMMENT ON COLUMN media.resolution IS 'video resolution';
COMMENT ON COLUMN media.video_codec IS 'video compression codec';
COMMENT ON COLUMN media.audio_codec IS 'audio codec';
COMMENT ON COLUMN media.upload_type IS 'uploading type indicating source of upload';
-- timestamps
COMMENT ON COLUMN media.created_at IS 'timestamp for initial database creation of item';
COMMENT ON COLUMN media.updated_at IS 'timestamp of last database alteration of item';

--------------------------------------------------------------------------------
-- training comments
--------------------------------------------------------------------------------

-- add table comment
COMMENT ON TABLE training IS 'stores training data to be ingested by reel-driver';

-- identifier columns
COMMENT ON COLUMN training.imdb_id IS 'from TMDB; IMDB identifier for media item, and the primary key for this column';
COMMENT ON COLUMN training.tmdb_id IS 'from TMDB; identifier for themoviedb.org API';
-- label columns
COMMENT ON COLUMN training.label IS 'training label enum value for model ingestion';
-- flag columns
COMMENT ON COLUMN training.human_labeled IS 'flag value that indicates a user change of the label value';
COMMENT ON COLUMN training.reviewed IS 'deterines if training label has been confirmed as accurate';
COMMENT ON COLUMN training.anomalous IS 'user set flag for media items frequently appear as false postives or false negatvies in model results, but have been verified to be correct';
-- media identifying information
COMMENT ON COLUMN training.media_type IS 'either movie, tv_shows, or tv_season';
COMMENT ON COLUMN training.media_title IS 'either movie or tv show title';
COMMENT ON COLUMN training.season IS 'media season if tv show or tv season; null for movies';
COMMENT ON COLUMN training.episode IS 'episode number within season for tv show, otherwise null';
COMMENT ON COLUMN training.release_year IS 'year the movie was released or the year of the first season of a tv show';
-- metadata pertaining to the media item
-- - quantitative details
COMMENT ON COLUMN training.budget IS 'from TMDB; production budget of media item';
COMMENT ON COLUMN training.revenue IS 'from TMDB; current revenue of media item';
COMMENT ON COLUMN training.runtime IS 'from TMDB; runtime in minutes of media item';
-- - country and production information
COMMENT ON COLUMN training.origin_country IS 'from TMDB; primary country of production in iso_3166_1 format';
COMMENT ON COLUMN training.production_companies IS 'from TMDB; array of production companies';
COMMENT ON COLUMN training.production_countries IS 'from TMDB; array of countries where media item was produced in iso_3166_1 format';
COMMENT ON COLUMN training.production_status IS 'from TMDB; current production status of media item';
-- - language information
COMMENT ON COLUMN training.original_language IS 'from TMDB; primary language of media item in ISO 639 format';
COMMENT ON COLUMN training.spoken_languages IS 'from TMDB; array of languages available encoded in ISO 639 format';
-- - other string fields
COMMENT ON COLUMN training.genre IS 'from TMDB; array of genres associated with the movie';
COMMENT ON COLUMN training.original_media_title IS 'from TMDB; original title of media item';
-- - long string fields
COMMENT ON COLUMN training.tagline IS 'from TMDB; tagline for the media item';
COMMENT ON COLUMN training.overview IS 'from TMDB; brief plot synopsis of media item';
-- - ratings info
COMMENT ON COLUMN training.tmdb_rating IS 'from TMDB; rating submitted by TMDB users out of 10';
COMMENT ON COLUMN training.tmdb_votes IS 'from TMDB; number of ratings by TMDB users';
COMMENT ON COLUMN training.rt_score IS 'Rotten Tomatoes score';
COMMENT ON COLUMN training.metascore IS 'MetaCritic score';
COMMENT ON COLUMN training.imdb_rating IS 'IMDB rating out of 100';
COMMENT ON COLUMN training.imdb_votes IS 'number of votes on IMDB';
-- timestamps
COMMENT ON COLUMN training.created_at IS 'timestamp for initial database creation of item';
COMMENT ON COLUMN training.updated_at IS 'timestamp of last database alteration of item';

--------------------------------------------------------------------------------
-- prediction comments
--------------------------------------------------------------------------------


-- add table comment
COMMENT ON TABLE prediction IS 'stores training data to be ingested by reel-driver';

-- identifier column
COMMENT ON COLUMN prediction.imdb_id IS 'IMDB identifier for media item, and the primary key for this column';
-- value columns
COMMENT ON COLUMN prediction.prediction IS 'model prediction value, 1 for would_watch and 0 for would_not_watch';
COMMENT ON COLUMN prediction.probability IS 'probability of would_watch on 0 to 1 scale';
COMMENT ON COLUMN prediction.cm_value IS 'confusion matrix value, either ture positive, true negative, false postivie or false negative';
-- timestamps
COMMENT ON COLUMN prediction.created_at IS 'timestamp for initial database creation of item';