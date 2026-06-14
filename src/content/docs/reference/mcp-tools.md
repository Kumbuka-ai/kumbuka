---
title: MCP tools
description: The five MCP tools an AI assistant calls to remember, recall, and forget a team's steering knowledge over a remote server.
---

kumbuka exposes a remote **MCP server over Streamable HTTP** at `/mcp`, scoped to
the authenticated user. Five tools make up the surface. The names are kept
functional rather than brand-prefixed — the model reads them, and clarity beats
brand noise.

Tool returns are **structured JSON** (MCP `structuredContent`) so the model can
read fields reliably rather than re-parsing prose.

There is also an MCP **resource** `memory://{scope}` that lists a scope's
contents.

For the underlying concepts (scopes, types, keys, authorship) see
[Concepts](/concepts/data-model/).

---

## `memory_remember`

Write a new entry, or upsert an existing one when a `key` is supplied.

| Parameter | Required | Description |
|---|---|---|
| `content` | yes | The statement to remember (plain text). |
| `type` | yes | One of `decision`, `convention`, `constraint`, `open_question`, `glossary`, `status`. |
| `scope` | no | Target scope slug. If omitted, the team's **default write-scope policy** decides (`ask` / `project` / `global` — see [Configuration](/reference/configuration/)). |
| `key` | no | Lowercase, dot/kebab-namespaced address (e.g. `db.system-of-record`). When given, a matching entry is updated in place rather than duplicated. |

Authorship is recorded automatically from the write channel; a client cannot set
it.

## `memory_recall`

Read entries with filters. All parameters are optional; with none, it returns
what the caller may see in context.

| Parameter | Description |
|---|---|
| `scope` | Restrict to a scope slug. |
| `type` | Restrict to one entry type. |
| `query` | Substring match over content. |
| `include_global` | Whether to fold in the `global` baseline alongside the selected scope. |

`memory_recall` only ever returns entries the calling user is permitted to see.

## `memory_forget`

Remove an entry.

| Parameter | Description |
|---|---|
| `scope` | The scope the entry lives in. |
| `key` *or* `id` | Identify the entry by its `key` within the scope, or by its `id`. |

Private entries are protected by the owner check — only the owner, over their own
session, can forget their private entries.

## `memory_scopes`

List the scopes the caller may see — their own `private` scope plus every shared
scope (`global` and the `project` scopes they have access to). No parameters.

## `memory_load_context`

Return a typed, ready-to-inject **digest** of the relevant rules, grouped by type
(decision / convention / constraint / open_question / glossary / status) and
capped per group. This is the tool to call at the start of a session so the
assistant carries the team's steering knowledge from the first turn.

| Parameter | Description |
|---|---|
| `scope` | Optional scope to focus the digest on; otherwise the relevant baseline is used. |

---

## Notes

- **Scoping to the user.** Every call runs as the authenticated user. That is why
  the same endpoint can serve a member's private scope alongside the shared ones
  without ever exposing one user's private memory to another — see
  [Security & privacy](/operations/security/).
- **Streamable HTTP.** kumbuka uses the modern MCP transport (Streamable HTTP),
  not the older SSE transport.
