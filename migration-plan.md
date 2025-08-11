# Migration Plan

## Overview

This document outlines the migration plan for restructuring the ATP (Automatic Transmission Pipeline) database schema to better represent the shape of the data.

## Current State

The current database schema consists of multiple tables across two schemas (`public` and `atp`) that support an automated media acquisition and processing pipeline with machine learning capabilities.

### Current Schema ERD

```mermaid
erDiagram
    MEDIA {
        char(40) hash PK "SHA-1 hash identifier"
        enum media_type "movie|tv_show|tv_season|unknown"
        varchar(255) media_title
        integer season
        integer episode
        integer release_year "1850-2100"
        enum pipeline_status "ingested..complete"
        boolean error_status
        text error_condition
        enum rejection_status "unfiltered|accepted|rejected|override"
        text rejection_reason
        text parent_path
        text target_path
        text original_path
        text original_link
        enum rss_source "yts.mx|episodefeed.com"
        varchar(25) uploader
        varchar(10) imdb_id "^tt[0-9]{7,8}$"
        integer tmdb_id
        bigint budget
        bigint revenue
        integer runtime
        varchar(20)[] genre
        varchar(255)[] production_companies
        char(2)[] production_countries
        char(2)[] origin_country
        char(2) spoken_languages
        char(2) original_language
        text overview
        varchar(255) tagline
        decimal tmdb_rating "0-10"
        integer tmdb_votes
        decimal imdb_rating "0-100"
        integer imdb_votes
        integer rt_score "0-100"
        integer metascore "0-100"
        varchar(10) resolution
        varchar(10) video_codec
        varchar(10) audio_codec
        varchar(10) upload_type
        timestamptz created_at
        timestamptz updated_at
    }

    TRAINING {
        varchar(10) imdb_id PK "^tt[0-9]{7,8}$"
        integer tmdb_id UK
        enum label "would_watch|would_not_watch"
        boolean human_labeled
        boolean anomalous
        boolean reviewed
        enum media_type
        varchar(255) media_title
        smallint season
        smallint episode
        smallint release_year
        varchar(20)[] genre
        varchar(255)[] production_companies
        char(2)[] production_countries
        char(2)[] origin_country
        char(2) original_language
        text overview
        varchar(255) tagline
        decimal tmdb_rating
        integer tmdb_votes
        decimal imdb_rating
        integer imdb_votes
        integer rt_score
        integer metascore
        bigint budget
        bigint revenue
        integer runtime
        timestamptz created_at
        timestamptz updated_at
    }

    PREDICTION {
        varchar(10) imdb_id PK "^tt[0-9]{7,8}$"
        smallint prediction "0 or 1"
        decimal probability "0-1"
        char(2) cm_value "confusion matrix"
        timestamptz created_at
    }

    FLYWAY_SCHEMA_HISTORY {
        integer installed_rank PK
        varchar(50) version
        varchar(200) description
        varchar(5) type
        varchar(1000) script
        integer checksum
        varchar(100) installed_by
        timestamp installed_on
        integer execution_time
        boolean success
    }

    MEDIA ||--o{ TRAINING : "potential via imdb_id"
    TRAINING ||--|| PREDICTION : "imdb_id"
```

### Schema Characteristics

#### Current Architecture Issues
1. **Redundant Data Storage**: Similar columns exist across multiple tables (media, training, engineered)
2. **Denormalized Structure**: Arrays of production companies, genres, countries stored as columns
3. **Mixed Concerns**: Pipeline status, media metadata, and ML features in same tables
4. **Inefficient Lookups**: No proper normalization for frequently queried attributes
5. **Data Type Inconsistencies**: Same fields have different types across tables (e.g., season as integer vs smallint)

## Objectives

1. **Normalize the schema** to reduce redundancy and improve data integrity
2. **Separate concerns** by splitting pipeline management, media metadata, and ML features
3. **Improve query performance** through proper indexing and relationships
4. **Standardize data types** across all tables
5. **Create proper foreign key relationships** to ensure referential integrity

## Scope

### In Scope
- All tables in the `atp` schema
- Migration of existing data to new structure
- Index optimization
- Foreign key constraint implementation
- View updates

### Out of Scope
- Changes to the Flyway migration framework
- Application code changes (to be handled separately)
- Performance testing (separate task)

## Migration Steps

### Phase 1: Preparation
- Document all dependencies
- Backup current database
- Create rollback scripts
- Test migration in development environment

### Phase 2: Execution
- Create new normalized tables
- Migrate data with transformation
- Create foreign key constraints
- Update views and indexes

### Phase 3: Validation
- Verify data integrity
- Check constraint compliance
- Validate application functionality
- Performance testing

### Phase 4: Cleanup
- Drop deprecated tables/columns
- Update documentation
- Archive old schema definitions

## Rollback Plan

1. Keep original tables intact during migration
2. Maintain dual-write capability during transition
3. Create reverse migration scripts
4. Test rollback procedure in staging

## Risk Assessment

### High Risk
- Data loss during migration
- Application downtime
- Foreign key constraint violations

### Medium Risk
- Performance degradation
- Incomplete data migration
- View dependencies

### Low Risk
- Documentation updates
- Index rebuilding time

## Success Criteria

- Zero data loss
- All constraints satisfied
- Application functionality preserved
- Query performance improved or maintained
- Successful rollback test

## Post-Migration Tasks

- Update application ORM mappings
- Refresh materialized views
- Update monitoring dashboards
- Documentation updates
- Performance baseline establishment