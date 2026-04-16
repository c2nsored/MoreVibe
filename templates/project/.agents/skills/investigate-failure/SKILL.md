---
name: investigate-failure
description: Trace a failure by separating symptoms, environment, likely causes, and next checks.
---

# Investigate Failure

## Goal

Reduce guesswork when something fails unexpectedly.

## Principles

- do not jump straight to a fix
- separate observed facts from interpretation
- identify the execution environment before blaming infra
- prefer the next highest-signal check, not the broadest possible check

## Steps

1. Restate the symptom.
2. Identify where it happens.
3. Separate observed facts from assumptions.
4. Narrow likely causes.
5. Decide the next best check.

## Environment split

Always classify which environment the failure belongs to before concluding anything:

- local working shell
- project runtime or container
- deployed server or remote environment
- external integration or third-party dependency

## Focus

- trigger condition
- exact symptom and affected boundary
- first known failing point
- recent changes that could plausibly matter
- what evidence is missing

## Red flags

- the proposed cause is based on intuition instead of observed evidence
- local build errors are reported as production failures without environment proof
- multiple unrelated root causes are mixed together
- the next diagnostic step is too broad to meaningfully reduce uncertainty

## Output

- symptom
- environment
- confirmed facts
- likely causes
- next diagnostic step
- explicitly rejected assumptions
