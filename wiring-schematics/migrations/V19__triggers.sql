SET search_path TO atp;

--------------------------------------------------------------------------------
-- media triggers
--------------------------------------------------------------------------------

-- updated_at trigger
DROP TRIGGER IF EXISTS update_media_updated_at ON media;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_media_updated_at
    BEFORE UPDATE ON media
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ingestion clear trigger
DROP TRIGGER IF EXISTS reset_fields_on_ingestion ON media;

CREATE OR REPLACE FUNCTION reset_on_ingestion()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.pipeline_status = 'ingested' AND OLD.pipeline_status != 'ingested') THEN
        IF (OLD.rejection_status != 'override') THEN
            NEW.rejection_status = 'unfiltered';
        END IF;
        NEW.rejection_reason = NULL;
        NEW.error_status = FALSE;
        NEW.error_condition = NULL;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER reset_fields_on_ingestion
    BEFORE UPDATE ON media
    FOR EACH ROW
    EXECUTE FUNCTION reset_on_ingestion();

-- error_condition clear trigger
DROP TRIGGER IF EXISTS clear_error_condition ON media;

CREATE OR REPLACE FUNCTION reset_error_condition()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.error_status = FALSE) THEN
        NEW.error_condition = NULL;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER clear_error_condition
    BEFORE UPDATE ON media
    FOR EACH ROW
    EXECUTE FUNCTION reset_error_condition();

-- rejection_status clear trigger
DROP TRIGGER IF EXISTS clear_rejection_reason ON media;

CREATE OR REPLACE FUNCTION reset_rejection_reason()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.rejection_status != 'rejected') THEN
        NEW.rejection_reason = NULL;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER clear_rejection_reason
    BEFORE UPDATE ON media
    FOR EACH ROW
    EXECUTE FUNCTION reset_rejection_reason();

--------------------------------------------------------------------------------
-- training triggers
--------------------------------------------------------------------------------

-- Drop existing trigger and function
DROP TRIGGER IF EXISTS trg_training_update_timestamp ON training;
DROP FUNCTION IF EXISTS trg_fn_training_update_timestamp();

-- Create new function
CREATE OR REPLACE FUNCTION trg_fn_training_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create new trigger
CREATE TRIGGER trg_training_update_timestamp
    BEFORE UPDATE ON training
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_training_update_timestamp();

--------------------------------------------------------------------------------
-- prediction triggers
--------------------------------------------------------------------------------

-- Drop existing trigger and function
DROP TRIGGER IF EXISTS trg_predction_update_timestamp ON prediction;
DROP FUNCTION IF EXISTS trg_fn_prediction_update_timestamp();

-- Create new function
CREATE OR REPLACE FUNCTION trg_fn_prediction_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create new trigger
CREATE TRIGGER trg_prediction_update_timestamp
    BEFORE UPDATE ON prediction
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_prediction_update_timestamp();

