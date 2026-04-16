---
name: ecommerce-order-flow-check
description: Review catalog-to-checkout changes for cart, checkout, and order-state regressions.
---

# Ecommerce Order Flow Check

## Goal

Protect the core shopping flow when making changes to an e-commerce project.

## When to use

- after changing catalog, cart, checkout, payment, or order-state behavior
- before release when customer-facing buying flow changed
- when the user asks whether checkout or order completion could break

## Check method

1. Identify which stage of the buying flow changed.
2. Trace the customer path from discovery to completed order.
3. Mark where data, pricing, quantity, or state could drift.
4. Check whether admin or backend changes could affect customer flow.
5. Decide what must be verified before shipping.

## Focus

- product to cart flow
- cart to checkout flow
- checkout to order completion flow
- order-state and payment-sensitive transitions
- pricing, totals, discount, and quantity consistency
- stock or availability behavior at critical steps
- confirmation, retry, and failure recovery behavior

## Red flags

- totals or order state can differ between cart, checkout, and completion
- payment-sensitive behavior changed without explicit verification
- cart recovery, retry, or duplicate-submit handling is unclear
- backend order-state logic changed but storefront assumptions were not reviewed

## Output

- affected order flow stages
- likely regressions
- missing checks before shipping
- rollout concerns
- release recommendation: safe / verify more / not ready
