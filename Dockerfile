# Simple Dockerfile for running migrations
FROM flyway/flyway:11.20.0-alpine

# Copy migrations
COPY migrations /flyway/migrations/

# Default command
CMD ["info"]