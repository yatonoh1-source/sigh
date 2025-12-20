FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache sqlite python3 make g++ pkg-config pixman-dev cairo-dev jpeg-dev

COPY package*.json ./

RUN npm install --ignore-scripts

COPY . .

RUN mkdir -p /app/data && chmod 755 /app/data

RUN npm run build

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

RUN chown -R nodejs:nodejs /app/data

USER nodejs

EXPOSE 5000

ENV NODE_ENV=production \
    DATABASE_PATH=/app/data/database.db \
    SESSIONS_PATH=/app/data/sessions.db

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:${PORT:-5000}/api/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1))" || exit 1

CMD ["npm", "start"]
