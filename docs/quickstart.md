# Quickstart — self-host the Community Edition

The Community Edition is the free, self-hosted, single-tenant memory core. It
runs as a single Docker Compose stack: the Quarkus backend, PostgreSQL, Keycloak
(the identity provider), a Caddy edge, and the Next.js admin console served at
the root path.

The deployable stack lives in the
[`kumbuka-server`](https://github.com/kumbuka-ai/kumbuka-server) repository. This
page is the project-level walkthrough; the
[`kumbuka-server` runbook](https://github.com/kumbuka-ai/kumbuka-server#quick-start-dev)
is the authoritative, always-current reference for environment variables and
production deployment.

## Prerequisites

- **Docker** and **Docker Compose** (a recent Docker Engine includes Compose v2).
- A host you can reach, and — for a real connector from claude.ai — **DNS and
  TLS** for the hostnames you configure. Caddy provisions certificates
  automatically when the hostnames resolve to your host.

The hostnames are configuration, never hardcoded (see
[configuration.md](configuration.md)). The defaults referenced below —
`kumbuka.ai`, `memory.kumbuka.ai`, `auth.kumbuka.ai` — are examples; set your
own.

## 1. Get the stack

Clone the server and the console **side by side** — the console is wired into the
server's compose stack by a relative path (step 4):

```bash
git clone https://github.com/kumbuka-ai/kumbuka-server
git clone https://github.com/kumbuka-ai/kumbuka-console
cd kumbuka-server
```

## 2. Configure

```bash
cp .env.example .env
```

Edit `.env` and set at least your domain and the secrets. For local development
you can accept the dev defaults; for anything internet-facing, set real
hostnames and strong secrets. The full list of knobs is documented in
[configuration.md](configuration.md) and in the
[`kumbuka-server` README](https://github.com/kumbuka-ai/kumbuka-server#quick-start-dev).

## 3. Start the backend stack

The backend services are gated behind the `app` Compose profile:

```bash
docker compose --profile app up -d
```

This brings up the backend, PostgreSQL, Keycloak (with the `kumbuka` realm
imported), and Caddy. Check health and logs:

```bash
docker compose ps
docker compose logs -f kumbuka-backend
```

At this point the admin API and the `/mcp` endpoint are live, but the **root
path (`/`) returns a 502** — that is the expected "backend-only" state until you
add the console in the next step.

## 4. Add the admin console

The console (a Next.js BFF) lives in its own repository and is wired into the
same stack with a `compose.override.yml` in the `kumbuka-server` directory.
Compose merges this file automatically:

```yaml
# kumbuka-server/compose.override.yml
services:
  kumbuka-console:
    build: ../kumbuka-console        # or: image: ghcr.io/kumbuka-ai/kumbuka-console:latest
    environment:
      NEXT_PUBLIC_APP_NAME: kumbuka.ai
      KUMBUKA_BACKEND_URL: http://kumbuka-backend:8080
    networks: [internal]
    depends_on: [kumbuka-backend]
    profiles: ["app"]
```

Caddy already proxies the root path to this service, so no routing changes are
needed. Bring the console up with the same command — Compose picks up the
override:

```bash
docker compose --profile app up -d
```

The root path now serves the console. It binds only to the internal Docker
network; Caddy remains the sole public entry point. (For local development
against a live or mock backend without Docker, see the
[`kumbuka-console` README](https://github.com/kumbuka-ai/kumbuka-console#running).)

## 5. First run

1. **Sign in to the admin console** at your configured console host (e.g.
   `https://kumbuka.ai`). The first administrator is provisioned during stack
   setup — see the `kumbuka-server` runbook for the exact bootstrap step.
2. **Confirm the `global` scope** exists — it is the always-on baseline; there is
   exactly one and it cannot be removed.
3. **Create a `project` scope** or two if you want to organize shared memory
   (e.g. `billing-platform`).
4. **Invite teammates** from **Team & users**; each gets an enrolment link from
   Keycloak (no password is set on their behalf).
5. **Open the connector card** in **Settings** to get the endpoint URL, client
   id, and client secret you will hand to an AI client.

## 6. Connect an assistant

With the stack up and the connector details in hand, add kumbuka to your AI
client — see [connecting-an-assistant.md](connecting-an-assistant.md).

## Next steps

- [configuration.md](configuration.md) — policies and environment knobs.
- [architecture.md](architecture.md) — what each container does and how requests
  flow.
- [security.md](security.md) — the private guarantee and the operational
  invariants to uphold.
