-- Grant SELECT permission on atp.media to rear_diff user
-- This allows rear_diff to read media records

-- Create the user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'rear_diff') THEN
        CREATE USER rear_diff;
    END IF;
END
$$;

-- Grant SELECT permission on atp.media table
GRANT SELECT ON atp.media TO rear_diff;