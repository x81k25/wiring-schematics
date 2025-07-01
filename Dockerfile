FROM node:20-alpine

# Install Java for Flyway
RUN apk add --no-cache openjdk17-jre

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY flyway.conf.js ./
COPY migrations ./migrations/

# Create a non-root user
RUN addgroup -g 1001 -S flyway && adduser -u 1001 -S flyway -G flyway

# Create flyway download directory and set permissions
RUN mkdir -p flyway && chown -R flyway:flyway /app

# Switch to non-root user
USER flyway

# Default command (can be overridden)
CMD ["npm", "run", "migrate:info"]