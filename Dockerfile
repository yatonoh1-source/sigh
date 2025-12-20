COPY EVERYTHING BELOW AND PASTE INTO YOUR GITHUB DOCKERFILE
====================================================================

FROM node:20

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    sqlite3 python3 make g++ pkg-config \
    libpixman-1-dev libcairo2-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./

RUN npm install --ignore-scripts

COPY . .

RUN mkdir -p /app/data && chmod 755 /app/data

RUN npm run build

RUN addgroup --gid 1001 nodejs && adduser --disabled-password --gecos '' --uid 1001 nodejs

RUN chown -R nodejs:nodejs /app/data

USER nodejs

EXPOSE 5000

ENV NODE_ENV=production \
    DATABASE_PATH=/app/data/database.db \
    SESSIONS_PATH=/app/data/sessions.db

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:${PORT:-5000}/api/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1))" || exit 1

CMD ["npm", "start"]

====================================================================
THAT'S IT - COPY EVERYTHING ABOVE AND PASTE INTO YOUR GITHUB DOCKERFILE
