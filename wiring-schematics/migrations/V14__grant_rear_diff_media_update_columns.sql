-- Grant UPDATE permission on specific columns of atp.media table to rear_diff user
GRANT UPDATE (pipeline_status, error_status, error_condition, rejection_status, rejection_reason) 
ON atp.media TO rear_diff;