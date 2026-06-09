# Quickstart — self-host the Community Edition

The Community Edition is the free, self-hosted, single-tenant memory core. It
runs as a single Docker Compose stack: the Quarkus backend, PostgreSQL, Keycloak
(the identity provider), and a Caddy edge.

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

```bash
git clone https://github.com/kumbuka-ai/kumbuka-server
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

## 3. Start it

```bash
docker compose up -d
```

This brings up the backend, PostgreSQL, Keycloak (with the `kumbuka` realm
imported), and Caddy. Check health and logs:

```bash
docker compose ps
docker compose logs -f kumbuka-backend
```

## 4. First run

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

## 5. Connect an assistant

With the stack up and the connector details in hand, add kumbuka to your AI
client — see [connecting-an-assistant.md](connecting-an-assistant.md).

## Next steps

- [configuration.md](configuration.md) — policies and environment knobs.
- [architecture.md](architecture.md) — what each container does and how requests
  flow.
- [security.md](security.md) — the private guarantee and the operational
  invariants to uphold.
