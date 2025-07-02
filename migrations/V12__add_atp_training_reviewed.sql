-- Add 'reviewed' column if it doesn't exist
ALTER TABLE atp.training ADD COLUMN reviewed BOOLEAN DEFAULT FALSE;

-- add comment on column
COMMENT ON COLUMN atp.training.reviewed IS 'denotes whether or not element had been reviewed; determines inclusion into training data set';