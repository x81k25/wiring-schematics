-- Remove 'confirmed' column if it exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'atp' 
          AND table_name = 'training' 
          AND column_name = 'confirmed'
    ) THEN
        ALTER TABLE atp.training DROP COLUMN confirmed;
    END IF;
END $$;

-- Add 'reviewed' column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'atp' 
          AND table_name = 'training' 
          AND column_name = 'reviewed'
    ) THEN
        ALTER TABLE atp.training ADD COLUMN reviewed BOOLEAN DEFAULT FALSE;
    END IF;
END $$;

-- add comment on column
COMMENT ON COLUMN atp.training.reviewed IS 'denotes whether or not element had been reviewed; determines inclusion into training data set';