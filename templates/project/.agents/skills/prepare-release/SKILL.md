---
name: prepare-release
description: Prepare a release by checking versioning, notes, artifacts, and unresolved risk.
---

# Prepare Release

## Goal

Make sure a release is coherent before shipping it.

## When to use

- before tagging, packaging, publishing, or handing off a release build
- when the user asks whether something is ready to ship
- when the repo has moved past implementation and needs release discipline

## Check

- version bump status
- release notes status
- packaged artifact status
- unresolved defects, warnings, or known risks
- docs and handoff completeness
- commit/push/release state consistency
- environment or deployment assumptions that have not been verified

## Release gate questions

1. What exactly is being released?
2. Which version or tag should represent it?
3. Are the source changes committed and pushed?
4. Are release notes accurate for this version?
5. Does the expected artifact actually exist and match the version?
6. Is there any unresolved risk that should block release?

## Red flags

- artifact version and documentation version do not match
- release notes describe work that is not in the pushed commit
- known warnings are present but not called out in the release summary
- packaging succeeded, but runtime verification was skipped without being stated
- deployment status is unclear across local / git / remote / server stages

## Output

- release target summary
- current release state
- blockers
- non-blocking warnings
- missing items
- final release checklist
- ship recommendation: ready / ready with warnings / not ready
