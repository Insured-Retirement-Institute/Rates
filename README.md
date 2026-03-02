# Rate APIs

The goal is to establish industry-wide standards for rate APIs used in the annuity market, enabling consistent, secure and efficient transmission of product rates between carriers, distributors and third-party vendors. Standardizing these APIs will reduce operational friction, improve data accuracy, shorten product update cycles, and enhance the experience for financial professionals and customers.

## The Problems these APIs will solve
Currently, the industry lacks a common standard for transmitting rate updates across carriers, distributors, and technology providers.  This creates multiple challenges:
- **Inefficiency** – Each carrier and service provider uses proprietary formats and processes, requiring duplicative integration work for each carrier, distributor or vendor
- **Data inconsistency** – Rates may be delayed, miscommunicated, or entered incorrectly, leading to compliance risks and potential loss of sales.
- **Slower Speed to Market** – New or updated rates may take days to propagate across platforms, delaying the ability to present competitive offerings to clients.
- **Higher Cost** – Maintaining multiple custom integrations strains IT and operations budgets.

Without industry standards, rate distribution will remain fragmented, creating unnecessary costs, errors, and time delays for all parties.

## Context and design assumptions
- Rate recipients have different operating models and data models, which changes the information needed to accept rate updates.
- The industry API should be broadly understandable, flexible for future product innovation, and able to support 100% of product and strategy combinations.
- Scope is focused on current/new and renewal rates (not historical comparison rates).


## API Specification Owners
- Carrier Business Owner: Pins, Lisa <lpins@brighthousefinancial.com> | Vashisht, Amit <amit.vashisht@jackson.com>
- Distributor Business Owner: Solution providers are implementing on behalf of distribution
- Solution Provider Owners:
   - **Nicholas Palmer <Nicholas.Palmer@icapital.com>** (Champion)
   - **Sheldon DSouza <sheldon.dsouza@icapital.com>** (Tech-Champion)
   - Jeremy Alexander <jeremy@beaconresearch.net>


## User Stories, personas - supporting documents for the business case

### User story: New Issue Rates
- As a solution provider/distributor of rate and illustration services (e.g., pricing engines, UI applications, downstream APIs),
  I want a centralized Product Dictionary API that provides authoritative reference data for insurance products,
  so that rate communications are consistent, accurate, and aligned across all systems and channels.
- As a solution provider/distributor, I want a bulk load of current rates for new business cusips available for sale.
- As a solution provider/distributor, I want a bulk load of current rates for new business cusips available for sale at a distributor if it is different.
- As a carrier, I want to send the current rate for one or more new business cusips available for sale.

### User story: Renewal Rates
- As a solution provider/distributor of rate and illustration services (e.g., pricing engines, UI applications, downstream APIs),
  I want a centralized Product Dictionary API that provides authoritative reference data for insurance products,
  so that rate communications are consistent, accurate, and aligned across all systems and channels.
- As a solution provider/distributor, I want a bulk load of renewal rate options for contract that is coming up for renewal.
- As a carrier, I want to send the renewal rate options for the contract coming up for renewal.


## API overview
Two APIs work together to provide and consume rates:

### Product Dictionary API
Provides reference data for rate communications, including:
- Product identifying information
- Product variation information
- Surrender periods
- Premium bands
- Strategies
- Features

### Rate API
Provides rate payloads using Product Dictionary identifiers, including:
- Product identifying and variation information
- Rate variation information
- Rate type (new business, GMIR, renewal, etc.)
- Effective dates
- Rates list
- Premium bands
- Surrender periods
- Strategy-level state, feature, and rate details

## Scenario mappings (initial focus)
1. **Push New Issue Rates** – Push bulk new business rates for CUSIPs available for sale now, shared at a product level (e.g., fixed interest rate, RILA/FIA cap and step rates).
2. **Renewal Rates** – Provide renewal rate options for contracts approaching renewal, including retrieval at the product level.

Day 2 items to be prioritized and better defined later:
- **Contract-Specific Renewal Rates** – Renewal rates for a specific contract based on product, state, issue date, renewal date, etc.
- **Feature Specific / Rider Rates** – Product-level rates that apply to features or riders.
   - Example: a client elects a GWBL rider where accumulation rate is 6% and withdrawal rate is 7%.

## How to engage, contribute, and give feedback
- These working groups are being coordinated by Nicholas Palmer <Nicholas.Palmer@icapital.com>** (Champion) and Sheldon DSouza <sheldon.dsouza@icapital.com>** (Tech-Champion).
- Please contact the business owners or IRI (hpikus@irionline.org or kdease@irionline.org) to get added to the working group discussions.

## Change submissions and reporting issues and bugs

Security issues should be reported directly to Katherine Dease kdease@irionline.org. Issues and bugs can be reported directly within the issues tab of a repository. Change requests should follow the standards governance workflow outlined on the [main page](https://github.com/Insured-Retirement-Institute).

## Code of conduct

See [Digital-First-Specifications](https://github.com/Insured-Retirement-Institute/Digital-First-Specifications) repository
