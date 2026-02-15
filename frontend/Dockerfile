# ============================================
# [PROJECT_NAME] — Frontend Dockerfile (PRODUCCION)
# ============================================
# Multi-stage build: Node (build) → Nginx (servir)
# Resultado: imagen ligera (~25MB) con solo archivos estaticos

# ---- Stage 1: Build ----
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- Stage 2: Serve ----
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
