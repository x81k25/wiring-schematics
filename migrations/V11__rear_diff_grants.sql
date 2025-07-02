-- Create user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'rear_diff') THEN
        CREATE USER rear_diff;
    END IF;
END
$$;

-- Grant SELECT permission for full read access
GRANT SELECT ON atp.training TO rear_diff;

-- Grant UPDATE permission on specific columns
GRANT UPDATE (label, human_labeled, reviewed) ON atp.training TO rear_diff;