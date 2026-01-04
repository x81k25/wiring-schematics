-- Make atp.training.label column nullable
-- This allows training records to exist without a label assignment

ALTER TABLE atp.training ALTER COLUMN label DROP NOT NULL;
