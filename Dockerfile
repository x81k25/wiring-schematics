# Simple Dockerfile for running migrations
FROM flyway/flyway:9.22-alpine

# Copy migrations
COPY migrations /flyway/sql/

# Default command
CMD ["info"]