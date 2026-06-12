# ADR 0002 - Secrets management

**Date:** 2026-06-10
**Status:** Accepted

## Context

The platform handles personal data of elderly users under GDPR and integrates
several external services (database, notifications, email), each with its own
credentials. Credentials must never end up in version control - not even in a
private repository, since a private repository can become public, be cloned, or
have its access widened in the future.

## Decision

Secrets live exclusively in a `.env` file on the server, outside version control.
The repository contains only a `.env.example` with keys and placeholders, never values.

Protection is applied in layers (shift-left), from earliest to latest:

1. `.gitignore` covering `.env`, keys, Terraform state and credentials from the first commit.
2. Secret scanning in the workflow, to block a secret before it leaves the machine.
3. `.env.example` as the contract of what must be filled in, without exposing anything.
4. Exposure response procedure: rotate first (issue a new value and invalidate the old
   one), clean history afterwards. Rotation is what actually neutralizes a leak, because
   whoever already cloned the repository took the old value with them.

## Alternatives considered

- **Secrets only in CI variables:** covers the pipeline but not local development.
  Kept as a complement, not as the single layer.
- **Dedicated vault (HashiCorp Vault / cloud secret manager):** the natural evolution
  once the number of services and environments grows. At the current stage, `.env` on
  the server with rotation discipline does the job at lower operational cost.

## Consequences

- Positive: no secret in repository history; a defined rotation process; a repository
  that is safe to make public.
- Trade-off: discipline depends on process (gitignore + scanning + rotation). That is
  why the layers are automated where possible instead of relying on whoever commits.
