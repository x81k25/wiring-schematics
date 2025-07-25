# PostgreSQL Database Migrations

## Overview

This repository manages database schema migrations for PostgreSQL using Flyway. It provides version-controlled, repeatable database changes across all environments.

## Quick Start

### Recommended Approach (Docker)
```bash
# Check migration status
./run-migration.sh info

# Run pending migrations
./run-migration.sh migrate

# Validate migrations
./run-migration.sh validate
```

### Legacy Approach (requires local Flyway)
```bash
# Install dependencies
npm install

# Check migration status
npm run migrate:info

# Run pending migrations
npm run migrate

# Validate migrations
npm run migrate:validate
```

## Project Structure

```
.
├── migrations/              # SQL migration files
│   ├── V1__Drop_test_schemas.sql
│   ├── V2__Create_users_table.sql
│   ├── V3__Drop_users_table.sql
│   ├── V4__Create_test_database.sql
│   └── V5__Create_products_table.sql
├── .github/
│   └── workflows/
│       └── docker-build.yml # CI/CD pipeline
├── flyway/                  # Flyway command-line tools
├── flyway.conf.js          # Flyway configuration (legacy)
├── run-migration.sh        # Migration runner script
├── k8s-example.yaml        # Kubernetes deployment example
├── Dockerfile              # Docker image for Flyway
├── docker-compose.yml      # Docker Compose configuration
├── package.json            # Node.js dependencies and scripts
├── .env                    # Database connection (not in git)
└── .gitignore             # Git ignore patterns
```

## Configuration

### Database Connection

Create a `.env` file with your PostgreSQL connection details:

```
FLYWAY_PGSQL_HOST=your-db-host
FLYWAY_PGSQL_PORT=5432
FLYWAY_PGSQL_DATABASE=postgres
FLYWAY_PGSQL_USERNAME=your-username
FLYWAY_PGSQL_PASSWORD=your-password
```

### Flyway Settings

Configuration is managed in `flyway.conf.js`:
- Connects to the `postgres` database by default
- Migration files stored in `migrations/` directory
- Schema history tracked in `flyway_schema_history` table

## Migration Files

### Naming Convention

Migration files must follow Flyway's naming pattern:

```
V{version}__{description}.sql
```

Examples:
- `V1__Initial_schema.sql`
- `V2__Add_user_tables.sql`
- `V2.1__Add_user_indexes.sql`
- `V3__Update_permissions.sql`

### Writing Migrations

1. Create a new file in the `migrations/` directory
2. Follow the naming convention above
3. Write your SQL DDL/DML statements
4. Test locally before committing

Example migration:
```sql
-- V1__Create_user_table.sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

## Available Commands

### Migration Script (Recommended)
| Command | Description |
|---------|-------------|
| `./run-migration.sh info` | Show migration status and history |
| `./run-migration.sh migrate` | Apply pending migrations |
| `./run-migration.sh validate` | Validate applied migrations |

### Legacy npm Scripts
| Command | Description |
|---------|-------------|
| `npm run migrate` | Apply pending migrations |
| `npm run migrate:info` | Show migration status and history |
| `npm run migrate:validate` | Validate applied migrations |
| `npm run migrate:baseline` | Set baseline for existing database |
| `npm run migrate:repair` | Repair migration history table |
| `npm run migrate:clean` | **DANGER**: Drop all database objects |

## Development Workflow

1. **Create Migration**: Add new SQL file to `migrations/`
2. **Check Status**: Run `./run-migration.sh info`
3. **Test Locally**: Apply with `./run-migration.sh migrate`
4. **Validate**: Run `./run-migration.sh validate`
5. **Commit**: Push migration file to version control
6. **CI/CD**: GitHub Actions will automatically test and build Docker images

## Best Practices

### DO
- Keep migrations small and focused
- Use descriptive migration names
- Test migrations in development first
- Include both schema and data changes in logical groups
- Use transactions where appropriate
- Add helpful comments in complex migrations

### DON'T
- Modify existing migration files
- Skip version numbers
- Use timestamps in version numbers
- Include environment-specific data
- Make assumptions about existing data

## Troubleshooting

### Migration Failed

If a migration fails:
1. Fix the issue in your database manually if needed
2. Run `npm run migrate:repair` to clean up
3. Fix the migration file
4. Run `npm run migrate` again

### Out of Order Migrations

Flyway requires migrations to be applied in order. If you need to add an earlier migration:
1. Use a decimal version (e.g., `V2.1__Missing_table.sql`)
2. Or renumber subsequent migrations (requires `migrate:clean`)

### Validation Errors

Run `npm run migrate:validate` to check for:
- Modified migration files
- Missing migrations
- Checksum mismatches

## Environment Management

### Development
- Use personal database or schema
- Test all migrations locally
- Clean and rebuild as needed

### Staging/Production
- Apply migrations through CI/CD
- Never modify schema manually
- Always backup before major changes

## Security

- Never commit `.env` files
- Use environment variables in CI/CD
- Restrict production database access
- Review migrations for SQL injection risks

## Docker Support

### Building the Image

```bash
docker build -t flyway-migrations .
```

### Running with Docker

```bash
# Check migration status
docker run --rm --env-file .env flyway-migrations

# Run migrations
docker run --rm --env-file .env flyway-migrations npm run migrate

# Validate migrations
docker run --rm --env-file .env flyway-migrations npm run migrate:validate
```

### Using Docker Compose

```bash
# Check migration status
docker-compose run --rm flyway info

# Run migrations
docker-compose run --rm flyway migrate

# Validate migrations
docker-compose run --rm flyway validate
```

## CI/CD Integration

### GitHub Actions

The repository includes a GitHub Actions workflow that:
- Builds Docker images on push to `dev` branch
- Builds on pull requests to `stg` and `main` branches
- Tags images with SHA versioning (e.g., `dev-20250701-abc123`)
- Tests migrations against a temporary PostgreSQL container
- Pushes images to GitHub Container Registry (ghcr.io)

### Docker Image

Pre-built images are available at:
```
ghcr.io/x81k25/wst-flyway:dev
ghcr.io/x81k25/wst-flyway:main
ghcr.io/x81k25/wst-flyway:stg
ghcr.io/x81k25/wst-flyway:<commit-sha>
```

## Kubernetes Deployment

### Using the Migration Script

The `run-migration.sh` script supports both local (.env file) and Kubernetes (environment variables) deployments:

```bash
# With .env file (local development)
./run-migration.sh info

# With environment variables (Kubernetes)
export FLYWAY_PGSQL_HOST=postgres-service
export FLYWAY_PGSQL_PORT=5432
export FLYWAY_PGSQL_DATABASE=mydb
export FLYWAY_PGSQL_USERNAME=user
export FLYWAY_PGSQL_PASSWORD=pass
./run-migration.sh migrate
```

### Kubernetes Example

See `k8s-example.yaml` for a complete example using:
- ConfigMap for database connection settings
- Secret for credentials
- Job for running migrations

## Additional Resources

- [Flyway Documentation](https://flywaydb.org/documentation/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Migration Best Practices](https://flywaydb.org/documentation/bestpractices)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## License

[Your License Here]