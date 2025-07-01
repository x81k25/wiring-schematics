-- Drop the users table and all associated objects
DROP TABLE IF EXISTS users CASCADE;

-- The CASCADE will automatically drop:
-- - All indexes on the table
-- - The trigger update_users_updated_at
-- - Any foreign key constraints referencing this table

-- Drop the trigger function if it's no longer needed
DROP FUNCTION IF EXISTS update_updated_at_column();