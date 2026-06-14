# syntax=docker/dockerfile:1
# ---------------------------------------------------------------------------
# kumbuka docs site (docs.kumbuka.ai) — Astro Starlight, built to static HTML
# and served by a tiny Caddy file server. Two stages: node build → caddy serve.
# ---------------------------------------------------------------------------
FROM node:22-alpine AS build
WORKDIR /app
RUN corepack enable
# Install deps against the committed lockfile first (better layer caching).
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
# Build the static site.
COPY . .
RUN pnpm run build

# ---------------------------------------------------------------------------
FROM caddy:2-alpine
# The container only serves static files on :80; TLS + routing live at the edge.
COPY Caddyfile.container /etc/caddy/Caddyfile
COPY --from=build /app/dist /usr/share/caddy
EXPOSE 80
