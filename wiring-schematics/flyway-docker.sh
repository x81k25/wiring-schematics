#!/bin/bash
# Wrapper script to ensure Flyway uses system Java in Docker

# Set JAVA_HOME to the system Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# Run the flyway command
exec flyway "$@"