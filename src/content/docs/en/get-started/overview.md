---
title: Overview
description: What kumbuka is, the personal/shared boundary that defines it, and where it runs.
---

kumbuka is an open-source **team memory system for AI assistants**. It gives a
team a durable, shared place for the knowledge an assistant should carry across
conversations, and serves that knowledge to MCP-capable AI clients over a remote
server. A web admin console lets the team curate it.

This page orients you. For the precise domain model see
[Concepts](/en/concepts/data-model/); for how an assistant calls it see the
[MCP tools](/en/reference/mcp-tools/).

## What it is for

Teams using AI assistants re-explain the same steering knowledge in every
session — the decisions, conventions, and constraints that should shape how the
assistant works. kumbuka turns that into a first-class, team-owned asset so it is
applied without being re-told.

It captures **work-steering knowledge**, deliberately small and typed:

- the rules and definitions that guide how the assistant works, **not** a copy
  of the team's documents or source (those stay in their own systems);
- shared and curatable, so the team sees and edits what the assistant relies on
  rather than each person accumulating an opaque, divergent context;
- portable, so any MCP-capable assistant reads and writes it through one
  endpoint.

## The personal / shared boundary

kumbuka has two halves, and the line between them is the product's defining
principle.

- **Shared memory** is what the team curates together — the `global` baseline
  and any number of `project` scopes. It is visible in the console and editable
  by the team according to role.
- **Private memory** is each member's own working space. It is reachable **only**
  by that member, **only** through their own authenticated MCP session. No admin,
  no console screen, and no team-facing API can read it. This is enforced
  structurally, not by a setting (see [Security & privacy](/en/operations/security/)).

When the two ever appear to conflict, the private guarantee wins over
convenience.

## Where it runs

kumbuka is a single Docker Compose stack: a Quarkus backend, PostgreSQL,
Keycloak (the identity provider), and a Caddy edge, with the Next.js admin
console. The deployable stack lives in
[`kumbuka-server`](https://github.com/kumbuka-ai/kumbuka-server). See the
[Quickstart](/en/get-started/quickstart/) to self-host it and the
[Architecture](/en/operations/architecture/) for the topology.

## Editions

The **Community Edition** documented here is the free, self-hosted, single-tenant
memory core. A commercial path (multi-tenancy, the Context Documents extension, a
moderation add-on, and hosted SaaS) is planned but pre-beta — see
[Editions](/en/concepts/editions/). It is described honestly: no overclaiming, no
prices, no dates.
