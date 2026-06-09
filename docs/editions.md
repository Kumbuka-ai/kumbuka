# Editions

kumbuka follows an **open-core** model: a complete, free, open-source core, with
a planned commercial path for organizations that need more. This page states the
boundary honestly — what the Community Edition is today, and what the commercial
path adds — without overclaiming.

> **The product is pre-beta.** The commercial path below describes intended
> direction. It is **not generally available**, and this page lists **no prices
> and no dates**.

## Community Edition (this repository's subject)

The Community Edition is the **OSS, self-hosted, single-tenant, atomic memory
core** — and it is free.

- **Self-hosted** — you run the Docker Compose stack on your own infrastructure
  ([quickstart.md](quickstart.md)).
- **Single-tenant** — one team per deployment.
- **The atomic memory core** — the full memory model: the six-type entry
  taxonomy, `global` / `project` / `private` scopes, the five `memory_*` MCP
  tools, the admin console, and the **private-memory guarantee** enforced at the
  data-access layer.
- **Licensed AGPL-3.0** — see [Licensing](#licensing).

The private guarantee is **not** an edition-gated feature. It is part of the core
and is present in the Community Edition exactly as described in
[security.md](security.md).

## Commercial path (planned)

For organizations that need capabilities beyond a single self-hosted team, a
commercial path is planned. Stated plainly, without availability claims:

| Capability | What it is |
|---|---|
| **Multi-tenancy** | Many isolated teams on one deployment. The single-tenant core already carries the isolation seam for forward compatibility. |
| **Context Documents** | An extension beyond the atomic memory entries — richer, document-shaped context. |
| **Moderation** | An add-on for reviewing and governing shared memory at scale. |
| **Hosted SaaS** | A managed offering, so you don't self-host. |

These are the commercial additions; the Community Edition does not include them.
We will not imply they are shipped or hardened while the product is pre-beta.

## Licensing

The Community Edition is licensed under the **GNU Affero General Public License
v3.0** ([AGPL-3.0](../LICENSE), ratified). Because kumbuka is deployed as a
network service, AGPL **§13** applies — running a modified version that users
interact with over a network obliges you to offer them its corresponding source
(see [security.md](security.md#network-source-obligation-agpl-13)).

A commercial **dual-license** path is planned for organizations that cannot
operate under the AGPL or that want the commercial-edition features. Details,
terms, and availability are not yet published. `[founder input]`

For how this licensing interacts with contributions, see
[CONTRIBUTING.md](../CONTRIBUTING.md).
