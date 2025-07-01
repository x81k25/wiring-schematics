#!/bin/sh
# Load configuration and run Flyway

# Generate Flyway arguments from Node.js config
node -e "
const config = require('./flyway.conf.js');
const args = config.flywayArgs;
const cliArgs = [
  '-url=' + args.url,
  '-user=' + args.user,
  '-password=' + args.password,
  '-locations=filesystem:/flyway/sql'
];
console.log(cliArgs.join(' '));
" > /tmp/flyway-args.txt

# Run Flyway with the generated arguments
exec flyway $(cat /tmp/flyway-args.txt) "$@"