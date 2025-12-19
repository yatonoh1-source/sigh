# Dockerfile optimized for Railway.app deployment with SQLite persistence
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install SQLite dependencies and build tools
RUN apk add --no-cache sqlite python3 make g++

# Copy package files first for better caching
COPY package*.json ./

# Install ALL dependencies (including dev dependencies for build)
RUN npm ci

# Copy entire project
COPY . .

# Create data directory with proper permissions
RUN mkdir -p /app/data && chmod 755 /app/data

# Build the production version
RUN npm run build

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

# Change ownership of data directory
RUN chown -R nodejs:nodejs /app/data

# Switch to non-root user
USER nodejs

# Expose port (Railway will use PORT env var)
EXPOSE 5000

# Set environment variables for Railway
ENV NODE_ENV=production \
    DATABASE_PATH=/app/data/database.db \
    SESSIONS_PATH=/app/data/sessions.db

# Health check for Railway monitoring
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:${PORT:-5000}/api/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1))" || exit 1

# Start the application
CMD ["npm", "start"]
