-- Grant SELECT permission on all tables in public schema to rear_diff user
-- This allows rear_diff to read all tables in the public schema

-- Create the user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'rear_diff') THEN
        CREATE USER rear_diff;
    END IF;
END
$$;

-- Grant SELECT permission on all current tables in public schema
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rear_diff;

-- Grant SELECT permission on all future tables in public schema
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO rear_diff;