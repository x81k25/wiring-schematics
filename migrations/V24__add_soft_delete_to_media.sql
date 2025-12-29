--------------------------------------------------------------------------------
-- V24: Add soft delete support to atp.media
--
-- Adds deleted_at column for soft deletion pattern, with trigger to
-- automatically set rejection_status and rejection_reason when deleted.
--------------------------------------------------------------------------------

SET search_path TO atp;

--------------------------------------------------------------------------------
-- add deleted_at column
--------------------------------------------------------------------------------

ALTER TABLE media ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NULL;

COMMENT ON COLUMN media.deleted_at IS 'Soft delete timestamp. NULL = active, timestamp = deleted.';

--------------------------------------------------------------------------------
-- grant update permission to rear_diff
--------------------------------------------------------------------------------

GRANT UPDATE (deleted_at) ON atp.media TO rear_diff;

--------------------------------------------------------------------------------
-- trigger function: set rejection status on soft delete
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION set_rejection_on_soft_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
        NEW.rejection_status := 'rejected';
        NEW.rejection_reason := 'user deletion';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------
-- trigger: fire on update when deleted_at changes
--------------------------------------------------------------------------------

CREATE TRIGGER trg_media_soft_delete
    BEFORE UPDATE ON media
    FOR EACH ROW
    WHEN (OLD.deleted_at IS DISTINCT FROM NEW.deleted_at)
    EXECUTE FUNCTION set_rejection_on_soft_delete();
