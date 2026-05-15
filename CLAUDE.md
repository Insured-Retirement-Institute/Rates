# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **standards and specification repository** maintained by the Insured Retirement Institute (IRI) to establish industry-wide standards for rate APIs used in the annuity market. This is **not an application codebase** - it contains API specifications, requirements, and documentation to enable consistent rate transmission between carriers, distributors, and service providers.

## Repository Purpose

The repository addresses industry inefficiency, data inconsistency, and integration complexity by standardizing:
- How new business rates are communicated (bulk and single-CUSIP)
- How renewal rates are transmitted
- Product reference data through the Product Dictionary API
- Rate payload structures through the Rate API

## Key Domain Concepts

### Product Types
- **FIA (Fixed Index Annuities)**: Index-linked products with downside protection
- **RILA (Registered Index-Linked Annuities)**: Index-linked products with market risk exposure
- **CUSIP**: Standard product identifier used throughout the industry

### Rate Scopes
- **New Business**: Rates for newly issued contracts
- **GMIR (Guaranteed Minimum Interest Rate)**: Floor rate guarantees
- **Renewal**: Rates for contracts approaching renewal
- **Bailout**: Special rate conditions
- **Lock**: Rate lock mechanisms

### Strategy Components
The API uses a component-based model where strategies are composed of:

**Upside Components** (define performance ceiling/participation):
- `cap`: Maximum return limit
- `participation`: Percentage of index gain credited
- `spread`: Deduction from index return
- `fixed`: Guaranteed credit regardless of index
- `performance_trigger`: Threshold-based crediting
- `tier`: Multi-level rate structures

**Downside Components** (define loss protection):
- `buffer`: Loss absorption before client exposure
- `floor`: Maximum permitted loss
- `barrier`: Threshold beyond which losses apply
- `downside_participation`: Percentage of index loss applied

**Component Value Convention**:
- All rates expressed as decimals (0.25 = 25%)
- Value of 9999 = uncapped/infinite
- Missing downside component = full protection

### Temporal Rate Attributes
- `effectiveDate`: When rate becomes active in market
- `expiryDate`: When rate expires (optional)
- `sweepDate`: When funds begin earning interest (defaults to effectiveDate)
- `publishingDate`: When future rate can be publicized (optional)

## Repository Structure

```
/
├── README.md              # Business context, problems, stakeholders, user stories
├── wip_spec/              # Work-in-progress API specifications (subject to change)
│   ├── product_dictionary.md       # Product reference data API spec
│   ├── rate_api.md                 # Rate transmission API spec
│   └── crediting_strategy_component_types.md  # Component type definitions
└── .github/copilot-instructions.md # Developer guidance
```

## Work-in-Progress Content

The `wip_spec/` directory contains **draft specifications that are subject to change without notice**. These represent active working group discussions and should not be considered final.

## API Architecture

### Product Dictionary API
Provides authoritative reference data for rate communications:
- Product identification (id, CUSIP, displayName)
- Product variations (distributor-specific versions via DTCC codes)
- Availability windows (effectiveDate, expiryDate, jurisdictions)
- Surrender periods (structured surrender schedules)
- Premium bands (tiered rate qualification thresholds)
- Strategies (available crediting options with jurisdictions)
- Features (optional riders like GWBL)

### Rate API
Transmits rate values using Product Dictionary identifiers:
- References products by id/idSource from Product Dictionary
- Specifies rate scope (NewBusiness, GMIR, Renewal, etc.)
- Organizes rates by surrenderPeriodId + bandId combinations
- Provides strategy-level rates with jurisdiction filters
- Uses component-based model for strategy representation
- Includes temporal metadata (effective/expiry/sweep/publishing dates)

### Key Relationship
Rate API payloads reference identifiers from Product Dictionary API. Recipients must consume both APIs to have complete context for rate processing.

## Design Principles

### Intentional Scope Limitations
The APIs are **not designed to fully define or onboard strategies**. They focus on:
- Establishing shared identity (IDs)
- Transmitting rate values
- Providing minimal context for rate application

They deliberately **exclude**:
- Term, underlier, crediting method details
- Implied strategy features
- Strategy fees (treated as structural, not rate parameters)

This is intentional: service providers have different internal models and operational requirements. Full strategy modeling is left to each recipient's system.

### Flexibility for Innovation
The component-based model allows new strategy types to be represented without schema changes. Add new component types as needed using the established value conventions.

## Terminology Standards

Use domain-specific terminology from README.md:
- "new issue rates" (not "new product rates")
- "renewal rates" (not "renewal options")
- "CUSIP" (not "product ID" when referring to securities identifiers)
- "product-level rates" (when referring to non-contract-specific rates)
- "component" (not "rate element" or "strategy parameter")
- "surrender period" (not "surrender schedule")
- "premium band" (not "premium tier")

## Governance and Contribution

### Stakeholders
- **Carrier Business Owners**: Lisa Pins (Brighthouse), Amit Vashisht (Jackson)
- **Solution Provider Owners**: Nicholas Palmer (Champion), Sheldon DSouza (Tech-Champion), Jeremy Alexander
- **IRI Contacts**: hpikus@irionline.org, kdease@irionline.org

### Issue Reporting
- **Security issues**: Report directly to kdease@irionline.org
- **Bugs/Issues**: Use GitHub Issues
- **Change requests**: Follow standards governance workflow per [Digital-First-Specifications](https://github.com/Insured-Retirement-Institute/Digital-First-Specifications)

### Working Group Participation
Contact Nicholas Palmer (Nicholas.Palmer@icapital.com) or Sheldon DSouza (sheldon.dsouza@icapital.com) to join working group discussions.

## Initial Focus Scenarios

1. **Push New Issue Rates**: Bulk push of current new-business CUSIP rates (caps, participation, step rates)
2. **Renewal Rates**: Renewal options retrieval at product level

**Day 2 Items** (lower priority, not yet fully defined):
- Contract-specific renewal rates (based on issue date, renewal date, state)
- Feature-specific/rider rates (e.g., GWBL accumulation/withdrawal rates)

## Development Notes

- No build, test, or lint tooling currently configured
- Repository is specification-focused, not code-focused
- Refer to README.md as primary source of truth for scope and business context
- Check wip_spec/ files for latest API design discussions (but remember they're drafts)
