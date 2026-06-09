# Concepts

The kumbuka domain model is small on purpose. Three ideas carry it: the **memory
entry**, the **scope** it lives in, and the **author** that wrote it.

## Memory entry

One unit of remembered knowledge. An entry has:

| Field | Meaning |
|---|---|
| `id` | A stable surrogate identifier. |
| `scope` | The scope the entry belongs to (below). |
| `type` | One of the six fixed types (below). |
| `key` | Optional, lowercase, dot/kebab-namespaced — the address the assistant looks an entry up by, e.g. `db.system-of-record`. |
| `content` | The statement itself, in plain text. |
| `author` | A human (their authenticated identity) or the assistant (`agent`). Derived server-side — see [Authorship](#authorship). |
| `created_at` / `updated_at` | Timestamps. |

An entry is a single, legible statement — not a document. Keep it to one rule,
decision, or definition.

## Entry taxonomy (fixed, six types)

The taxonomy is intentionally small so the memory stays legible. There are
exactly six types and they do not change:

| Type | Use it for |
|---|---|
| `decision` | A settled choice the team has committed to. |
| `convention` | A shared default way of doing things. |
| `constraint` | A hard boundary that must not be crossed. |
| `open_question` | Something unresolved; needs an owner and an answer. |
| `glossary` | A term defined so everyone means the same thing. |
| `status` | The current state of something in motion. |

## Scopes

A scope is a container of entries with an access **kind**. It has a surrogate
primary key, a unique and immutable **slug** (the address the assistant and UI
use), a display name, a kind, a description, and an `archived` (read-only) flag.

| Kind | Visibility | Notes |
|---|---|---|
| `global` | Team-wide | Exactly **one** per organization — the always-on baseline the assistant reads first. It cannot be created or removed. |
| `project` | Team-shared | Many; carve the shared memory into spaces (e.g. `billing-platform`). Members read/write; admins manage. |
| `private` | Owner-only | One per member. Reachable only by its owner through the MCP surface. **Never** appears in the console or any admin/team-facing API. |

The single `global` scope is fixed. `project` scopes are created to organize
shared memory; who may create them is a team policy (see
[configuration.md](configuration.md)). `private` is always available to each
member directly and is never the team's default write target.

A scope's **slug** is immutable even across renames, so the address an assistant
stores stays valid.

## Authorship

An entry's author is either a human or the assistant (`agent`), and provenance
is **derived server-side from the write channel** — never from a client-supplied
flag:

- Writes through the **console** are attributed to the signed-in human.
- Writes through the **MCP surface** are marked "via assistant" (`source = mcp`)
  while still recording the real human subject behind the session.

There is no separate login for the assistant, and no client can claim a
different author than the channel it wrote through. The console's "agent" badge
simply means the entry arrived over MCP.

## How the assistant reads and writes

The assistant interacts with these concepts through five MCP tools
(`memory_remember`, `memory_recall`, `memory_forget`, `memory_scopes`,
`memory_load_context`). Where a new entry lands when no scope is named is
governed by the team's default write-scope policy. See [mcp-tools.md](mcp-tools.md)
and [configuration.md](configuration.md).
