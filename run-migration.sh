#!/bin/bash
# Script to run Flyway migrations with Docker

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Check if required environment variables are set
if [ -z "$FLYWAY_PGSQL_HOST" ] || [ -z "$FLYWAY_PGSQL_PORT" ] || \
   [ -z "$FLYWAY_PGSQL_DATABASE" ] || [ -z "$FLYWAY_PGSQL_USERNAME" ] || \
   [ -z "$FLYWAY_PGSQL_PASSWORD" ]; then
  echo "Error: Required environment variables are not set."
  echo "Please ensure the following variables are set:"
  echo "  FLYWAY_PGSQL_HOST"
  echo "  FLYWAY_PGSQL_PORT"
  echo "  FLYWAY_PGSQL_DATABASE"
  echo "  FLYWAY_PGSQL_USERNAME"
  echo "  FLYWAY_PGSQL_PASSWORD"
  exit 1
fi

# Run the Docker container with environment variables
docker run --rm \
  -e FLYWAY_URL="jdbc:postgresql://${FLYWAY_PGSQL_HOST}:${FLYWAY_PGSQL_PORT}/${FLYWAY_PGSQL_DATABASE}" \
  -e FLYWAY_USER="${FLYWAY_PGSQL_USERNAME}" \
  -e FLYWAY_PASSWORD="${FLYWAY_PGSQL_PASSWORD}" \
  -e FLYWAY_LOCATIONS="filesystem:/flyway/sql" \
  -v "$(pwd)/migrations:/flyway/sql:ro" \
  flyway/flyway:9.22-alpine \
  "$@"