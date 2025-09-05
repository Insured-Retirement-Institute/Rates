# Rate APIs

The goal is to establish industry-wide standards for rate APIs used in the annuity market, enabling consistent, secure and efficient transmission of product rates between carriers, distributors and third-party vendors.  Standardizing these APIs will reduce operational friction, improve data accuracy, shorten product update cycles, and enhance the experience for financial professionals and customers.

Business Case Details: 
-	New issue contract rates or renewal rates for what they would be
- New rates only – not historical rates for comparisons


The initial focus will be on three rate API scenarios:
1.	**Push New Issue Rates**- Push in bluk new business rates for cusips available for sale right now - shared at a product level (e.g., fixed interest rate, RILA/FIA cap and step rates, etc.).
2.	**Pull New Issue Rates**- Pull new business rates for 1 cusip at at time, available for sale right now - shared at a product level (e.g., fixed interest rate, RILA/FIA cap and step rates, etc.).
3.	**Renewal Rates** – Renewal rates for existing contracts approaching renewal. Enable ability to also retrieve renewal rates at the product level.

Day 2 items to be prioritized and better defined later are below: 
**Contract-Specific Renewal Rates** – renewal rates for a specific contract based on that contracts product, state, issue date, renewal date, etc.
**Feature Specific / Rider Rates** – Rates for new contracts, shared at a product level, that apply to features or riders.  
a.	As an example, the client has the option to elect a GWBL rider and the current accumulation rate is 6% and the current withdrawal rate is 7%.


## Get started

Please refer to the [style guide](https://github.com/Insured-Retirement-Institute/Style-Guide) for technical governance of standards, data dictionary, and the code of conduct.

## The Problems these APIs will solve
Currently, the industry lacks a common standard for transmitting rate updates across carriers, distributors, and technology providers.  This creates multiple challenges:
- Inefficiency – Each carrier uses proprietary formats and processes, requiring duplicative integration work for each distributor or vendor
-	Data inconsistency – Rates may be delayed, miscommunicated, or entered incorrectly, leading to compliance risks and potential loss of sales.
- Slower Speed to Market – New or updated rates may take days to propagate across platforms, delaying the ability to present competitive offerings to clients.
-	Higher Cost – Maintaining multiple custom integrations strains IT and operations budgets.
  
Without industry standards, rate distribution will remain fragmented, creating unnecessary costs, errors, and time delays for all parties.

## User Stories, personna - supporting documents for the business case
User stories: Push New Issue Rates
- As a solution provider, I want a bulk load of current rates for new business cusips available for sale.
- As a carrier, I want to push all current rates for new business cusips available for sale.
User stories: Pull New Issue Rates
- As a solution provider/distributor, I want to pull the current rate for a single new business cusip available for sale.
- As a carrier, I want to send the current rate for a single new business cusip available for sale.
User stories: Renewal Rates  
- As a solution provider, I want to know the renewal rate options for the contract that is coming up for renewal. 
- As a carrier, I want to send the renewal rate options for the contract coming up for renewal.

## Business Owners 
- Carrier Business Owner: Pins, Lisa <lpins@brighthousefinancial.com> | Vashisht, Amit <amit.vashisht@jackson.com>
- Distributor Business Owner: Solution providers are implementing on behalf of distribution
- Solution Provider Business Owner: **Nicholas Palmer <Nicholas.Palmer@icapital.com>** (Champion) | Abhishek Damaraju <abhishek.damaraju@icapitalnetwork.com>
- Jeremy Alexander <jeremy@beaconresearch.net>

## How to engage, contribute, and give feedback
- These working groups are being coordinated by Nicholas Palmer <Nicholas.Palmer@icapital.com>** (Champion) .
- Please contact the business owners or IRI (hpikus@irionline.org or kdease@irionline.org) to get added to the working group discussions. 

## Change subsmissions and reporting issues and bugs

Security issues should be reported directly to Katherine Dease kdease@irionline.org. Issues and bugs can be reported directly within the issues tab of a repository. Change requests should follow the standards governance workflow outlined on the [main page](https://github.com/Insured-Retirement-Institute).

## Code of conduct

See [style guide](https://github.com/Insured-Retirement-Institute/Style-Guide)
