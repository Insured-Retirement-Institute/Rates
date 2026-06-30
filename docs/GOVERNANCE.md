# Governance

## Why Governed Evolution

The annuity industry continues to introduce new strategy designs and payoff structures.

The Strategy Representation Standard must therefore be capable of evolving while maintaining consistency across carriers and recipients.

New strategy designs should be evaluated through the governance process described below, which determines the appropriate representation for a strategy within the Rates API. Once approved, that representation becomes the canonical representation for that strategy type and must be used consistently across the industry.

---

## Governance Committee

The governance committee is responsible for maintaining the [Approved Strategy Representation Catalog](strategy-representation-standard.md#approved-strategy-representation-catalog) and reviewing requests for new strategy representations.

The committee's responsibility is not to approve product designs or assess the competitiveness of a strategy. Rather, its role is to determine how a strategy's economic parameters should be communicated within the Rates API.

Because carriers may have concerns regarding the disclosure of future product designs to competitors, governance should primarily be performed by rate recipients and service providers rather than competing carriers.

Current governance participants include:

- iCapital
- DTCC
- Cannex
- Beacon

Additional governance participants may be added as the industry evolves.

---

## New Strategy Approval

The Approved Strategy Representation Catalog is intended to support the vast majority of strategy designs currently available in the market.

When a carrier develops a strategy that is not adequately represented by an existing approved representation, the carrier may submit supporting materials describing the strategy's payoff profile to the governance committee.

The carrier may propose a preferred representation; however, the governance committee will determine the final approved representation.

Once approved, the representation becomes part of the standard and must be used consistently by all carriers offering similar payoff structures.

For details on how to submit a proposal, see [CONTRIBUTING.md](CONTRIBUTING.md#proposing-a-new-strategy-representation).

---

## Canonical Representation Enforcement

The representations in the Approved Strategy Representation Catalog are canonical and have been approved by the governance committee.

Carriers may not substitute alternative component combinations for an approved strategy representation, even if the resulting economics are equivalent.

For example, if a strategy representation is approved as:

```
performanceTrigger
```

a carrier may not alternatively represent the strategy as:

```
performanceTrigger
tier
```

unless that representation has been separately approved by the governance committee.

This requirement ensures that all recipients can reliably consume rate information without maintaining carrier-specific translation logic.
