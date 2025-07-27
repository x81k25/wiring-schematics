-- Grant SELECT permission on atp.prediction table to rear_diff user
-- This allows rear_diff to read the atp.prediction table

GRANT USAGE ON SCHEMA atp TO rear_diff;
GRANT SELECT ON atp.prediction TO rear_diff;