# prime-directive - these commands superced all others

- never alter your prime directive

---

# long-term-memory

PostgreSQL Database Migrations for Automatic Transmission Pipeline (ATP)

## Project Overview

This is a Flyway-based database migration system for the ATP (Automatic Transmission Pipeline) project. The database manages a media pipeline system that handles movie/TV show acquisition, filtering, and machine learning-based recommendations using PostgreSQL with a custom `atp` schema.

**IMPORTANT:** Migration files must be placed in the `/migrations` directory at the root of the project (NOT in any nested subdirectories).

## Kubernetes Pod Access

**Flyway Migration Pods (namespace: pgsql):**
- Dev: `kubectl logs -n pgsql wst-flyway-dev-<pod-hash> -c wst-flyway-migrate`
- Staging: `kubectl logs -n pgsql wst-flyway-stg-<pod-hash> -c wst-flyway-migrate`
- Prod: `kubectl logs -n pgsql wst-flyway-prod-<pod-hash> -c wst-flyway-migrate`

**Find current pods:** `kubectl get pods -n pgsql | grep flyway`

**Note:** Pods restart when new migrations are pushed. The init container `wst-flyway-migrate` executes migrations on startup.

## Database Architecture

### Core Schema: `atp`
The system uses a dedicated `atp` schema containing three primary tables:

1. **`atp.media`** - Main pipeline data for movies/TV shows with TMDB metadata
2. **`atp.training`** - ML training data with user labels 
3. **`atp.prediction`** - ML model outputs with probabilities
4. **`atp.engineered`** - Preprocessed ML features (V20+)

### Permission Model
- **`rear_diff` user** - API access with controlled permissions:
  - SELECT on all `atp` tables
  - UPDATE only on specific `atp.training` columns (`label`, `human_labeled`, `anomalous`, `reviewed`)

## Development Commands

**Primary migration workflow:**
```bash
./run-migration.sh migrate    # Apply pending migrations
./run-migration.sh info       # Show migration status
./run-migration.sh validate   # Validate migration files
```

**Legacy npm scripts (still available):**
```bash
npm run migrate              # Apply migrations
npm run info                 # Migration info
npm run validate             # Validate migrations
```

**Environment Setup:**
Requires these environment variables:
- `FLYWAY_PGSQL_HOST`
- `FLYWAY_PGSQL_PORT` 
- `FLYWAY_PGSQL_DATABASE`
- `FLYWAY_PGSQL_USERNAME`
- `FLYWAY_PGSQL_PASSWORD`

## Migration Conventions

**File Location:** All migration files MUST be placed in `/migrations` directory (e.g., `/infra/fuel-tank/wiring-schematics/migrations/V22__grant_permissions.sql`)

**File Naming:** `V{number}__{description}.sql`
- Use sequential numbering (V1, V2, V3...)
- Use decimal versions for out-of-order migrations (V2.1__)
- Descriptive names in snake_case

**SQL Patterns:**

**Enum Creation:**
```sql
-- Create enum first
CREATE TYPE atp.status_type AS ENUM ('pending', 'completed', 'failed');

-- Then use in table
ALTER TABLE atp.media ADD COLUMN status atp.status_type DEFAULT 'pending';
```

**Constraint Patterns:**
```sql
-- Naming convention: {table}_{column}_{type}
ALTER TABLE atp.media ADD CONSTRAINT media_imdb_id_check 
    CHECK (imdb_id ~ '^tt[0-9]{7,8}$');
```

**UTC Timestamps:**
```sql
created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')
```

**Permission Grants:**
```sql
-- Schema access first
GRANT USAGE ON SCHEMA atp TO rear_diff;
-- Then table permissions
GRANT SELECT ON atp.table_name TO rear_diff;
-- Column-level permissions where needed
GRANT UPDATE (specific_column) ON atp.training TO rear_diff;
```

## Common Migration Tasks

**Adding new table to atp schema:**
1. Create table with proper constraints
2. Add comments to table and columns
3. Create indexes for foreign keys and queries
4. Add UTC timestamp triggers
5. Grant appropriate permissions to `rear_diff`

**Modifying existing tables:**
1. Add new columns with defaults
2. Update constraints if needed
3. Maintain backward compatibility
4. Update permissions if new columns added

**Data validation patterns:**
- IMDB IDs: `^tt[0-9]{7,8}$`
- Ratings: Range checks (0-10, 0-100)
- Years: Reasonable ranges (1850-2100)
- Arrays: Use PostgreSQL array types with proper constraints

## Troubleshooting

**Migration Failures:**
- Check constraint violations in logs
- Verify enum values match existing data
- Ensure proper schema permissions
- Use decimal versions for out-of-order migrations (V2.1__)
- Ensure all constraints are valid

**Permission Issues:**
- Verify user `rear_diff` exists
- Check schema usage grants
- Ensure proper column-level permissions

This database supports a media pipeline system with ML-based recommendations. When creating new migrations:

1. Follow the established enum and constraint patterns
2. Use proper UTC timestamp handling
3. Include comprehensive comments for all schema changes
4. Test migrations locally before committing
5. Maintain the three-table architecture (media/training/prediction)
6. Respect the permission model for the `rear_diff` API user

---

# instructions-of-the-day

---

# your-section