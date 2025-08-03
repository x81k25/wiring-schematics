require('dotenv').config({ silent: true });

module.exports = {
  flywayArgs: {
    url: `jdbc:postgresql://${process.env.FLYWAY_PGSQL_HOST}:${process.env.FLYWAY_PGSQL_PORT}/${process.env.FLYWAY_PGSQL_DATABASE}`,
    locations: 'filesystem:migrations',
    user: process.env.FLYWAY_PGSQL_USERNAME,
    password: process.env.FLYWAY_PGSQL_PASSWORD,
    sqlMigrationSuffixes: '.sql',
    baselineOnMigrate: true,
    baselineVersion: '1',
    table: 'flyway_schema_history'
  },
  // Flyway binary download options
  downloads: {
    storageDirectory: './flyway',
    expirationTimeInMs: -1
  }
};