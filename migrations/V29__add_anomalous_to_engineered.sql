-- Add anomalous flag to atp.engineered table (matches atp.training.anomalous)

ALTER TABLE atp.engineered
ADD COLUMN anomalous BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN atp.engineered.anomalous IS 'flag for media items that frequently appear as false positives or false negatives in model results, but have been verified to be correct';
