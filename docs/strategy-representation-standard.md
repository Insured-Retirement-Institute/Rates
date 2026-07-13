# Annuity Rates API: Strategy Representation Standard

## Introduction

Within the Rates API, carriers communicate strategy rates using a collection of rate "components" associated with a previously identified strategy.

```json
{
  "strategies": [
    {
      "id": "String",
      "components": [
        {
          "type": "String",
          "value": 0.10
        }
      ]
    }
  ]
}
```

This document defines the approved representations that may be used when communicating strategy rates through the Rates API.

The objective of this standard is to ensure that all carriers communicate economically equivalent strategies in a consistent manner, allowing recipients to reliably consume and process rate information without maintaining carrier-specific translation logic.

This document does not define how recipients should model strategies internally. Recipients are expected to onboard and maintain strategy definitions within their own systems using information provided through the Product Dictionary API and other carrier-supplied product documentation.

By the time a recipient consumes a Rates API payload, the strategy has already been identified, onboarded, and modeled within the recipient's platform. The Rates API exists solely to communicate the economic parameters associated with that strategy.

---

## Design Principles

### Minimal Economic Representation

The purpose of the Rates API is to communicate the minimum set of economic parameters necessary to convey a strategy's current rates.

The Rates API is not intended to communicate a complete strategy definition, payoff formula, or product specification.

As a guiding principle:

> If a parameter does not appear as a variable on a carrier's published rate sheet, it likely does not belong in the Rates API.

Recipients are expected to model strategy mechanics, underliers, crediting methods, observation schedules, calculation methodologies, and other structural attributes within their own systems.

The Rates API exists only to communicate the economic values that are subject to change and are routinely distributed by carriers.

### Canonical Representation

A strategy's economic profile must be represented in a single approved format within the Rates API.

Carriers may not arbitrarily combine supported component types to create custom representations of a strategy.

The purpose of the standard is to ensure that recipients can reliably interpret rate information without maintaining carrier-specific translation logic.

For any approved strategy representation, all carriers must use the same approved component combination and representation.

Consistency of representation is essential for interoperability across the industry.

### Governed Evolution

The annuity industry continues to introduce new strategy designs and payoff structures.

The standard must therefore be capable of evolving while maintaining consistency across carriers and recipients.

New strategy designs should be evaluated through a governance process that determines the appropriate representation of the strategy within the Rates API. Once approved, that representation becomes the canonical representation for that strategy type and should be used consistently across the industry.

---

## Governance Process

### Governance Committee

The governance committee is responsible for maintaining the approved strategy representation catalog and reviewing requests for new strategy representations.

The committee's responsibility is not to approve product designs or assess the competitiveness of a strategy. Rather, its role is to determine how a strategy's economic parameters should be communicated within the Rates API.

Because carriers may have concerns regarding the disclosure of future product designs to competitors, governance should primarily be performed by rate recipients and service providers rather than competing carriers.

Examples include:

- iCapital
- DTCC
- Cannex
- Beacon

Additional governance participants may be added as the industry evolves.

### New Strategy Approval

The Approved Strategy Representation Catalog is intended to support the vast majority of strategy designs currently available in the market.

When a carrier develops a strategy that is not adequately represented by an existing approved representation, the carrier may submit supporting materials describing the strategy's payoff profile to the governance committee.

The carrier may propose a preferred representation; however, the governance committee will determine the final approved representation.

Once approved, the representation becomes part of the standard and should be used consistently by all carriers offering similar payoff structures.

---

## Valid Component Types

The following component types are supported within the Rates API.

Inclusion in this list does not imply that arbitrary combinations are permitted. Approved component combinations are defined within the [Approved Strategy Representation Catalog](#approved-strategy-representation-catalog).

Values are expressed as decimals (e.g. `0.10` = 10%). A value of `9999` means uncapped/infinite.

### Strategy Components

| Type | Description |
| --- | --- |
| `cap` | Cap rate — maximum return limit |
| `participation` | Participation rate — percentage of index gain credited |
| `spread` | Spread rate — deduction from index return |
| `fixed` | Fixed interest rate — guaranteed credit independent of index performance |
| `performanceTrigger` | Performance trigger rate — threshold-based crediting level |

### Downside Protection Components

| Type | Description |
| --- | --- |
| `buffer` | Downside buffer — percentage of loss absorbed before client exposure begins |
| `floor` | Maximum downside loss — absolute loss limit expressed as a positive decimal |
| `barrier` | Downside barrier — threshold beyond which losses are incurred |
| `downsideParticipation` | Downside participation — percentage of index loss applied to the client |

### Miscellaneous Components

| Type | Description |
| --- | --- |
| `annualFee` | Annual strategy fee — expressed as a decimal (e.g. `0.01` = 1.00% annual fee) |
| `tier` | Tier threshold — used in approved tiered representations |

---

## Exclusions

The objective of the Rates API is to communicate rate values, not to fully define or model product strategies.

Neither the Rates API nor the Product Dictionary API are intended to provide sufficient information for a recipient to fully onboard or construct a strategy using only these APIs.

This limitation is intentional.

Recipients represent and operationalize strategies differently. They require different attributes, different levels of granularity, and different structural groupings to support their business use cases.

Attempting to standardize a complete strategy schema would introduce unnecessary complexity while failing to meet the diverse needs of the ecosystem.

Accordingly, the APIs focus on establishing shared identity and transmitting economic parameters, while leaving full strategy modeling to each recipient's internal systems.

The following elements, among others, are intentionally excluded from both the Product Dictionary API and the Rates API:

- Underlier
- Term
- Crediting method
- Observation schedules
- Calculation methodologies
- Trigger conditions
- Structural bonuses or embedded strategy mechanics
- Illustration logic
- Product-specific payoff formulas
- Interim value calculations
- Rate lock mechanics

These elements remain the responsibility of carrier product documentation and recipient onboarding processes.

---

## Downside Protection

Downside protection parameters are included in the Rates API.

Although these elements may not change as frequently as caps or participation rates, they are core economic parameters of a strategy and directly impact its payoff profile.

### Fully Protected Strategies

If a strategy provides full downside protection, no downside protection component should be included in the payload.

The absence of a downside protection component should be interpreted as full protection.

### Fully Unprotected Strategies

For fully unprotected strategies, the preferred representation is:

```
type = downsideParticipation
value = 1.00
```

Recipients may normalize a 0% buffer or 0% barrier to the same economic outcome, but the preferred representation is 100% downside participation.

---

## Strategy Fees

Strategy fees are supported within the Rates API and should be transmitted using the `annualFee` component type.

Examples:

| Value | Meaning |
| --- | --- |
| `0.01` | 1.00% annual fee |
| `0.0125` | 1.25% annual fee |
| `0.0075` | 0.75% annual fee |

The Rates API does not prescribe how recipients should model fee deduction, compounding, timing of assessment, or other economic mechanics. Those calculations remain the responsibility of each recipient's internal product and illustration models.

---

## Approved Strategy Representation Catalog

The following representations have been approved for use within the Rates API.

For each strategy design, carriers should transmit only the approved economic parameters shown below, regardless of any additional strategy mechanics, crediting methods, underliers, observation schedules, or payoff formula details that may exist within the product.

### Representation Convention

For each component type listed, carriers should provide a corresponding `value` field expressed as a decimal `Double`.

Example:

```json
{
  "type": "cap",
  "value": 0.10
}
```

Unless otherwise noted, every component type shown in the catalog should be accompanied by a corresponding `value`.

| Strategy | Approved Component Types | Justification / Example Products |
| --- | --- | --- |
| Cap | `cap` | Standard cap strategy. |
| Cap with Participation | `cap` `participation` | Both values are published and may vary independently. |
| Cap with Absolute Return to Buffer | `cap` | The dual-directional component is defined by the downside protection structure and does not require additional rate transmission. |
| Cap with Spread | `cap` `spread` | Both values are economically relevant and routinely communicated on rate sheets. |
| Cap with Bonus | `cap` | Certain carrier bonus structures are mechanically derived from other strategy attributes and do not require separate rate transmission. Example: Jackson Performance Boost strategies where the boost is always equal to the buffer. |
| Cap with Annual Lock | `cap` | Annual lock is a crediting method, not a rate parameter. |
| Cap then Fixed | `cap` `fixed` | Both values are published economic parameters. Example: Corebridge Lock strategies. |
| Cap with Monthly/Annual Sum | `cap` | Additive crediting methodology is not relevant for rate communication. |
| Cap with Monthly/Annual Averaging | `cap` | Averaging methodology is not relevant for rate communication. |
| Participation | `participation` | Standard participation strategy. |
| Participation with Spread | `participation` `spread` | Both values are economically relevant and routinely communicated. |
| Participation with Fixed | `participation` `fixed` | Both values are published economic parameters. Example: Nationwide New Heights Select. |
| Participation with Monthly/Annual Sum | `participation` | Additive crediting methodology is not relevant for rate communication. |
| Performance Trigger | `performanceTrigger` | Standard performance trigger strategy. |
| Performance Trigger Dual Direction | `performanceTrigger` | Trigger condition mechanics are part of the strategy design and do not require separate rate transmission. |
| Performance Trigger then Participation | `performanceTrigger` `participation` | Both economic parameters are required to represent the payoff profile. Example: Prudential Step Rate Plus. |
| Tiered Participation | `tier` `participation` `participation` | Multiple participation rates are required to represent the approved tier structure. Order of participation rates corresponds to the applicable tier. |
| Tiered Bonus | `participation` `cap` | Tier thresholds are derived from the protection structure and do not require separate transmission. Example: Symetra Buffer Plus. |
| Tiered Performance Trigger | `tier` `performanceTrigger` `performanceTrigger` | Multiple trigger rates are required to represent the approved tier structure. Order of trigger rates corresponds to the applicable tier. Example: Transamerica Triple Edge. |
| Spread | `spread` | Standard spread strategy. |
| Fixed | `fixed` | Standard fixed-rate strategy. |
| Strategy Fee | `annualFee` | Annual strategy fee expressed as a decimal percentage. |

### Governance Note

The representations listed above are canonical representations approved by the governance committee.

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
