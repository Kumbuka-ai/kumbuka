---
title: Configuration
description: The team policies set in the console and the deployment knobs set in the environment for the Community Edition.
---

This page describes the configurable behavior of the Community Edition — the
team policies set in the console and the deployment knobs set in the environment.
The authoritative, always-current list of environment variables lives with the
deployable stack in the
[`kumbuka-server` README](https://github.com/kumbuka-ai/kumbuka-server#quick-start-dev);
this page explains the concepts behind them.

## Hostnames are configuration

Hostnames are **never hardcoded**. A deployment sets its own:

| Host | Purpose | Example |
|---|---|---|
| Console | The admin UI | `kumbuka.ai` |
| MCP endpoint | The `/mcp` surface AI clients connect to | `mcp.kumbuka.ai` |
| Keycloak | The identity provider / sign-in host | `auth.kumbuka.ai` |

The examples above are just examples. Set yours in `.env`; Caddy provisions TLS
for the hostnames you configure once they resolve to your host.

## Team policies (set in the console)

These are runtime policies an admin manages from **Settings**. They change
behavior immediately.

### Default write-scope policy

Where the assistant writes when it is **not** told a scope:

| Value | Behavior |
|---|---|
| `ask` *(default)* | The assistant proposes a target and the member confirms. Safest for mixed teams. |
| `project` | The active project scope, with a runtime fallback if it is missing. |
| `global` | The organization-wide baseline. |

**Private is never the team default target.** It is always available to each
member directly; the write-scope policy governs *shared* writes only.

### Who may create project scopes

| Value | Behavior |
|---|---|
| `admins` *(default)* | Only admins create new `project` scopes. |
| `members` | Any member may create `project` scopes. |

The single `global` scope is fixed — it cannot be created or removed regardless
of this policy.

### Invalid default scope (runtime fallback)

If the configured default scope becomes invalid (for example it was archived or
deleted), the backend falls back to **`ask` at runtime without mutating the
stored configuration**, shows an admin banner, and warns proactively at
archive/delete time. The stored policy is left intact so it can be corrected
deliberately.

### Connector details

The connector is configured by its **endpoint URL alone**, shown in the connect
area on the overview page. There is no client id and no client secret: an AI
client identifies itself to the authorization server and registers at first
authorization. The connector-level kill-switch is **disabling the registered
client** in the identity provider — not a secret rotation; there is no secret.

## Deployment knobs (set in `.env`)

Set in the environment before `docker compose up`. Typical categories (see the
`kumbuka-server` README for exact names and defaults):

- **Domain / hostnames** — the three hosts above.
- **Secrets** — database credentials, Keycloak admin and client secrets. Use
  strong values for anything internet-facing.
- **Database** — PostgreSQL connection settings (the app DB is `kumbuka`; schema
  is managed by Flyway).
- **Identity** — Keycloak realm and client configuration (realm `kumbuka`;
  clients `kumbuka-backend`, `kumbuka-admin`; AI clients register themselves at
  first authorization).

See [Quickstart](/en/get-started/quickstart/) to put these together for a first run, and
[Security & privacy](/en/operations/security/) for the invariants a configuration must not break.
