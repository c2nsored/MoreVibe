---
name: morevibe-report-deployment
description: Report deployment status honestly by separating local changes, commit state, push state, and server/application rollout state.
---

# MoreVibe Report Deployment

## Goal

Avoid calling work "deployed" when only part of the path is complete.

## Report by stage

- local working tree
- commit
- push
- server or environment rollout

## Rule

Keep code reflection status separate from runtime deployment status.
