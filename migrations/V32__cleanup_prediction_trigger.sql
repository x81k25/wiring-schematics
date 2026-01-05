-- V32: Cleanup orphaned prediction trigger
--
-- V31 incorrectly created a trigger for prediction.updated_at which doesn't exist.
-- This migration drops that orphaned trigger.

SET search_path TO atp;

-- Drop the orphaned trigger (prediction table has no updated_at column)
DROP TRIGGER IF EXISTS trg_prediction_update_timestamp ON prediction;
