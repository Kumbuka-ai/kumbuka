# Contributing to kumbuka

Thanks for your interest in kumbuka. Contributions — issues, docs, and code — are
welcome. This repository (`kumbuka`) is the project front door and documentation;
the code lives in the per-repo projects linked below.

## Where the code lives

| Repo | What it is | Dev setup |
|---|---|---|
| [`kumbuka-server`](https://github.com/kumbuka-ai/kumbuka-server) | Quarkus backend, MCP surface, Keycloak realm/theme, Docker Compose stack | See its README |
| [`kumbuka-console`](https://github.com/kumbuka-ai/kumbuka-console) | Next.js admin console | See its README |
| [`kumbuka`](https://github.com/kumbuka-ai/kumbuka) | This repo — public docs | Edit Markdown; preview locally |

Each code repo documents its own build, run, and test workflow. Start there for
environment setup.

## How to contribute

1. **Open an issue first** for anything non-trivial, so we can agree on the
   approach before you invest time.
2. **Fork and branch** from the default branch. Keep changes focused; one logical
   change per pull request.
3. **Match the surrounding code and docs.** Follow existing structure,
   conventions, and the calm, precise documentation voice. Artifacts are in
   **English**.
4. **Write clear commits.** Explain the *why*, not just the *what*.
5. **Keep docs honest.** Where something is undecided, mark it **TBD** or
   `[founder input]` rather than inventing an answer. Don't overclaim maturity —
   the project is pre-beta.
6. **Open a pull request** describing the change and linking the issue. Be ready
   to iterate in review.

For security issues, **do not** open a public issue — follow
[SECURITY.md](SECURITY.md).

## Contributor License Agreement (CLA)

kumbuka is licensed **AGPL-3.0**, with a planned commercial **dual-license** path
(the open-core model). To keep that path open, contributions require agreeing to
the **kumbuka Individual Contributor License Agreement (ICLA), v1.0** — the full
text is in **[CLA.md](CLA.md)**.

In plain terms (the agreement itself governs):

- It is a **license, not an assignment** — you keep all copyright in your
  contributions and may use them elsewhere however you like.
- You grant the project a broad copyright and patent license, **including the
  right to relicense** your contribution under the AGPL *and* under separate
  commercial/proprietary terms — this is what makes the open-core model possible.
- You confirm you are entitled to grant this (e.g. you have your employer's
  permission where relevant) and that your contribution is your original work.

**How acceptance works:** you accept the ICLA electronically and submit your pull
request. Acceptance is recorded by our CLA management tool, which gates merges.

> **Note on tooling and entity contributions (`[founder input]`):** the automated
> CLA tool may not yet be wired into this repository — if it isn't, a maintainer
> will coordinate sign-off before merge; opening a PR is still welcome. The ICLA
> covers **individual** contributors; contributions made on behalf of an
> **organization** are handled by a separate **corporate CLA (CCLA)**, which is
> referenced by the ICLA but **not yet published**. Questions: legal@kumbuka.ai.

## Documentation conventions

- **English** artifacts.
- **Append-only** canonical docs with explicit ratification — decisions are
  recorded, not silently changed; supersessions are noted.
- **Link, don't duplicate.** Point at the canonical source rather than copying it.
- **Plan first** for substantial work: propose the approach and get agreement
  before large changes.
