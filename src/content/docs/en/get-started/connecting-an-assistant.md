---
title: Connecting an assistant
description: How to add kumbuka as a custom MCP connector in claude.ai and what an assistant can do once it is live.
---

kumbuka is reached by an AI client as a **custom MCP connector**: you enter the
endpoint URL — nothing else. Once connected, the assistant can call the
memory tools on your behalf — including your own private scope, because the
connection is scoped to *you*, the authenticated user.

This page covers adding the connector in **claude.ai**. For Claude Desktop,
Claude Code, and Claude Mobile, see the
[`kumbuka-server` guide](https://github.com/kumbuka-ai/kumbuka-server#connecting-claude-clients).

## What you need

From the admin console's **connect area on the overview page** (or from your
administrator):

- **Endpoint URL** — the `/mcp` address, e.g. `https://mcp.kumbuka.ai/mcp`
  (your deployment's host; it is configuration, not a fixed value).

That is all. There is **no client id and no client secret** to enter: the AI
client identifies itself to the authorization server and registers at first
authorization. Access is revoked by **disabling the registered client** in the
identity provider — that is the connector-level kill-switch; there is no secret
to rotate.

> Remote MCP connectors in claude.ai require a paid plan. A server added on the
> web is inherited by Claude Mobile.

## Add it in claude.ai

1. Go to **Settings → Connectors → Add custom connector**.
2. Enter the **endpoint URL** from the connect area.
3. Save, then **Connect**. claude.ai discovers the authorization server from the
   endpoint and starts the OAuth flow.
4. **Sign in** at your Keycloak host (e.g. `https://auth.kumbuka.ai`) and approve
   access. You are redirected back and the connector goes live.

### What happens under the hood

The connector is an OAuth client using **PKCE**. claude.ai discovers the
authorization server via OAuth Protected Resource Metadata
(`/.well-known/oauth-protected-resource` → the `kumbuka` Keycloak realm) and
identifies itself through its published client metadata or dynamic client
registration — which is why no client id or secret is entered by hand. It then
runs the authorization-code flow and calls `/mcp` with an audience-bound bearer
token. The token's subject is *you*; your realm role (`member` or `admin`)
determines what you may do. See [Architecture](/en/operations/architecture/) for the full
auth topology.

## What the assistant can then do

With the connector live, the assistant has the five `memory_*` tools (full
reference in [MCP tools](/en/reference/mcp-tools/)):

- **Load context** at the start of a session with `memory_load_context` — a
  typed digest of the rules that should steer its work.
- **Recall** specific entries with `memory_recall` (filter by scope, type, or a
  substring).
- **Remember** new decisions, conventions, or status with `memory_remember`.
- **Forget** entries that no longer hold with `memory_forget`.
- **List scopes** it can see with `memory_scopes` — including your private scope,
  which only you can reach.

Where a new memory lands when you don't name a scope is governed by the team's
default write-scope policy (`ask` by default — the assistant proposes and you
confirm). See [Configuration](/en/reference/configuration/).

A good first move in a project is to tell the assistant to call
`memory_load_context` at session start, so it applies the team's steering
knowledge without being re-told.
