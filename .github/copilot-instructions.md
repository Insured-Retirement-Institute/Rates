# Copilot Instructions for IRIRates

## Build, test, and lint commands
- No build, test, or lint tooling is currently defined in this repository.
- There is no single-test command available yet because no automated test framework is configured.

## High-level architecture
- This repository currently serves as a standards and requirements source for annuity rate APIs rather than an application codebase.
- The core domain is organized around three API scenarios described in `README.md`:
  - **Push New Issue Rates**: bulk push of current new-business CUSIP rates available for sale.
  - **Pull New Issue Rates**: pull current new-business rate for a single CUSIP.
  - **Renewal Rates**: retrieve renewal options for contracts approaching renewal.
- Scope emphasizes current/new rates and renewal rates; historical comparison rates are explicitly out of scope in the current definition.
- Additional “Day 2” areas are identified (contract-specific renewal rates and feature/rider rates) but are not part of the initial focus.

## Key conventions in this repository
- Treat `README.md` as the primary source of truth for business scope, API scenario definitions, and stakeholder workflow context.
- Align terminology with the README domain language: “new issue rates,” “renewal rates,” “CUSIP,” and “product-level rates.”
- Follow the linked IRI Style Guide for standards governance, data dictionary, and code-of-conduct expectations: `https://github.com/Insured-Retirement-Institute/Style-Guide`.
- For process conventions captured in README:
  - Report security issues directly to `kdease@irionline.org`.
  - Use GitHub Issues for issues/bugs and follow IRI standards governance workflow for change requests.

## Keeping documentation in sync

The API documentation lives in three places that must be kept consistent:

1. **`docs/strategy-representation-standard.md`** — public-facing markdown mirror of the upstream governance document. This is the canonical public reference for component types, design principles, and the Approved Strategy Representation Catalog.
2. **`rate-api-v0.0.1.yaml`** — the OpenAPI spec. Schema `description` fields and `info.description` contain inline summaries that reference the docs file.
3. **Upstream governance source** — the IRI governance committee maintains the authoritative standard; changes flow into this repo via the IRI standards workflow.

### When the governance standard changes

| Change type | What to update |
|---|---|
| New component type approved | Add to `ComponentType` enum in the YAML (with description) **and** update the component type tables in `docs/strategy-representation-standard.md` |
| New strategy representation approved | Add a row to the Approved Strategy Representation Catalog in `docs/strategy-representation-standard.md`; no YAML schema change needed |
| Design principles or governance process updated | Update `docs/strategy-representation-standard.md` and the `info.description` summary in the YAML |
| Enum naming convention | All enum values use camelCase per IRI Digital-First-Specifications (e.g. `annualFee`, not `AnnualFee` or `ANNUAL_FEE`) |
