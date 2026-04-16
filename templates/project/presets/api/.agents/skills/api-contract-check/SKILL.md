---
name: api-contract-check
description: Review an API change for request/response contract drift, compatibility, and integration risk.
---

# API Contract Check

## Goal

Catch breaking or unclear API contract changes before release.

## When to use

- after changing request or response shapes
- after changing validation, auth, or error behavior
- before release when integrations or clients could be affected
- when the user asks whether an API change is safe

## Check method

1. Identify the endpoints or handlers that changed.
2. Compare old behavior assumptions with new contract behavior.
3. Check request shape, response shape, and error contract separately.
4. Mark whether compatibility is preserved, degraded, or broken.
5. List the minimum verification required before release.

## Focus

- request shape changes
- response shape changes
- validation and error contract changes
- backward compatibility risk
- authentication or authorization contract changes
- pagination, filtering, and optional field behavior
- downstream client and integration impact

## Red flags

- response shape changed without versioning or explicit migration guidance
- validation or error payloads changed but clients were not reviewed
- optional fields became required, or required fields became ambiguous
- endpoint behavior changed while docs or schema still describe old behavior

## Output

- contract risk summary
- affected endpoints
- compatibility concerns
- verification needed
- release recommendation: safe / verify more / not ready
