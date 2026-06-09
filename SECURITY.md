# Security Policy

We take the security of kumbuka seriously — especially the private-memory
guarantee, which is a hard design constraint, not a feature. Thank you for
helping keep it sound.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, email **security@kumbuka.ai** *(placeholder — to be confirmed; see the
note below)* with:

- a description of the issue and its impact,
- the steps to reproduce it,
- any affected versions or components, and
- your suggested remediation, if you have one.

We ask for **coordinated disclosure**: give us a reasonable window to investigate
and ship a fix before any public disclosure. We will acknowledge your report,
keep you updated, and credit you if you would like.

> **Maintainer note — `[founder input]`:** `security@kumbuka.ai` is a
> **placeholder**. Confirm the real disclosure mailbox (and, if desired, a PGP
> key or a security.txt entry) before this repository is published.

## Supported versions

kumbuka is **pre-beta**. Until a stable release line exists, only the latest
revision of the default branch is supported for security fixes. This section will
be updated when release lines are established.

## Security invariants (release-blocking)

These invariants are treated as **gating** — a build that violates any of them is
not shippable. They are part of how we evaluate any change:

1. **Private never leaks.** No admin, console, or team-facing API path can return
   a member's private rows. Enforced at the data-access layer, not the UI.
2. **Tenant isolation.** No boundary lets one tenant's data reach another. (The
   Community Edition is single-tenant; the isolation seam is load-bearing for the
   commercial multi-tenant path.)
3. **Operator sees no private content.** Running or administering the service
   grants no path to members' private memory.
4. **Server-derived authorship.** An entry's author is set from the write channel
   on the server, never from a client-supplied flag.

A deeper explanation of how the private guarantee is structurally enforced — and
what disable vs. erasure mean for a member's memory — is in
[docs/security.md](docs/security.md).

## Network-deployed service (AGPL §13)

kumbuka is licensed AGPL-3.0 and is typically run as a network service. If you
operate a **modified** version that users interact with over a network, AGPL
**§13** requires you to offer them the corresponding source. This is a licensing
obligation, noted here because it is relevant to anyone deploying the service.
