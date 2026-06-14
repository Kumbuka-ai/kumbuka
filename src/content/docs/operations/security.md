---
title: Security & privacy
description: The private-memory guarantee and how it is structurally enforced, disable vs. erasure, the release-blocking invariants, and the AGPL §13 network-source obligation.
---

This page describes the security model of the Community Edition: the
private-memory guarantee and how it is *structurally* enforced, what disabling
versus erasing a member means for their memory, and the invariants kumbuka treats
as release-blocking.

To **report a vulnerability**, see [SECURITY.md](https://github.com/kumbuka-ai/kumbuka/blob/main/SECURITY.md). Please do not
open a public issue for security problems.

## The private-memory guarantee

A member's **private** scope is owned by them and reachable **only** by them,
**only** through the MCP surface under their own authenticated session.

- **No** admin, **no** console screen, and **no** team-facing API can read it.
- It is enforced at the **data-access layer** — the privileged (admin/console)
  code paths have **no route** that can return private rows.
- It is **not** a configuration toggle that could be flipped, and not a UI-level
  filter that a missing check could bypass.

### How it is structurally enforced

The guarantee does not depend on every caller remembering to add a `WHERE`
clause. The admin/console read paths are served by code that has no method
capable of returning a private row at all — the privileged surface simply cannot
express the query. The private scope is reachable only through the per-user MCP
path, which always runs as the owning, authenticated user.

The console surfaces this promise in several places (the scope browser, the
dashboard, settings, the account screen, and the invite flow) so it reads as a
deliberate guarantee rather than an omission.

> Design rule: when the private guarantee and convenience conflict, the guarantee
> wins.

## Disable vs. erasure

These are two different operations with two different effects on a member's
memory.

- **Disable** *(ratified behavior)* — disabling a user **suspends their
  account**: they can no longer sign in or reach the MCP surface. Their
  **private memory is left untouched and remains theirs**. Re-enabling restores
  access to it. Disable is reversible and destroys nothing.

- **Erasure** *(ratified behavior)* — the deliberate opposite of disable: the
  member's account **and their entire private scope** are removed, so the private
  content is **gone, not merely suspended**. This is the behavior for an
  account-deletion / right-to-erasure request.

How erasure treats what the member touched:

- **Private memory** — deleted in full. Nothing of the member's private scope
  survives erasure.
- **Shared entries they authored** (in `global` / `project` scopes) — **retained**,
  so team knowledge the group relies on is not lost when a person leaves. Their
  **authorship is anonymized** to a tombstone identity (e.g. *former member*).
  This is a server-side deletion event, consistent with the
  [server-derived-authorship invariant](#release-blocking-invariants) — authorship
  is reassigned by the server, never by a client flag.
- **Grace window** — erasure is **reversible for a short, configurable retention
  period (default 30 days)**; after it elapses, deletion is permanent.

## Release-blocking invariants

kumbuka treats the following as gating — a build that violates any of them is not
shippable:

1. **Private never leaks.** No admin, console, or team-facing API path can return
   a member's private rows.
2. **Tenant isolation.** No deployment boundary lets one tenant's data reach
   another. *(In the single-tenant Community Edition there is one tenant; the
   isolation seam exists for forward compatibility and is load-bearing in the
   commercial multi-tenant path.)*
3. **Operator sees no private content.** Running or administering the service
   does not grant a path to members' private memory.
4. **Server-derived authorship.** An entry's author is determined by the write
   channel on the server, never by a client-supplied flag.

## Network source obligation (AGPL §13)

kumbuka is licensed under **AGPL-3.0** and is normally deployed as a
network-accessible service. Under AGPL **§13**, if you run a **modified** version
and let users interact with it over a network, you must offer those users the
**corresponding source** of your modified version. Operating an unmodified
release does not create new obligations beyond the AGPL's terms; modifying it and
exposing it over a network does. See [Editions](/concepts/editions/) and the
[LICENSE](https://github.com/kumbuka-ai/kumbuka/blob/main/LICENSE).

## Reporting

Security reports go to the contact in [SECURITY.md](https://github.com/kumbuka-ai/kumbuka/blob/main/SECURITY.md). We ask for
coordinated disclosure and will work with you on a fix and timeline.
