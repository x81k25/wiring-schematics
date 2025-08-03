# Simple Dockerfile for running migrations
FROM flyway/flyway:11.10.0-alpine

# Copy migrations
COPY migrations /flyway/sql/

# Default command
CMD ["info"]