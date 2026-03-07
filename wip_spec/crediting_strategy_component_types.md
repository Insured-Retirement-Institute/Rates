## Crediting Strategy Component Types

### Table of Contents
- [Intent](#intent)
- [Intentional Exclusions](#intentional-exclusions)
  - [General Components](#general-components)
  - [Strategy Fees](#strategy-fees)
- [Explicit Inclusions](#explicit-inclusions)
  - [Upside components](#upside-components)
  - [Downside Components](#downside-components)
    - [Why Downside Protection Is Included](#why-downside-protection-is-included)
    - [Downside Protection Types](#downside-protection-types)
    - [Fully unprotected strategies](#fully-unprotected-strategies)
- [Examples](#examples)

### Intent 
The objective of the Rates API is to communicate rate values — _not to fully define or model product strategies_.

Neither the Rate API nor the Product Dictionary API are intended to provide sufficient information for a recipient to fully “onboard” or construct a strategy within their internal data model using only these APIs. This limitation is intentional.

Service providers across the industry represent and operationalize strategies differently. They require different attributes, different levels of granularity, and different structural groupings to support their specific business use cases (illustrations, comparisons, compliance, analytics, etc.). Attempting to standardize a complete strategy schema across all recipients would introduce unnecessary rigidity and complexity, and would likely fail to meet the diverse needs of the ecosystem.

Accordingly, the APIs focus on establishing shared identity and transmitting rate values, while leaving full strategy modeling to each recipient’s internal system.


### Intentional Exclusions
The following elements are intentionally excluded from both the Product Dictionary API and the Rate API:

#### General Components
- Term 
- Underlier 
- Crediting method (point to point, additive, averaging, annual lock, etc)
- Implied/fixed strategy features such as performance trigger levels, certain bonuses, etc 
- Fees (additional discussion below)

#### Strategy Fees

Strategy fees are intentionally excluded from both the Product Dictionary API and the Rate API.

While fees are expressed as percentages and impact strategy performance, they are not dynamic rate parameters in the same sense as caps, participation rates, spreads, or buffers. Rather, fees are structural attributes of a strategy - similar to term, underlier, or crediting method.

The Rates API is designed to communicate **adjustable performance parameters** that are subject to change and require timely distribution. Fees, by contrast:

- Define how a strategy functions economically 
- Are typically embedded in product configuration 
- Do not vary with the same frequency or operational cadence as rate changes

Including fees in the Rates API would blur the boundary between:

- Strategy definition (structural product attributes), and
- Strategy rate updates (dynamic performance parameters)
- That separation is foundational to the API design.

### Explicit Inclusions
> [!IMPORTANT]  
> This content still needs to be finalized and may be subject to change. The upside component types and their corresponding value definitions are still being refined based on ongoing discussions with carriers and service providers. This list may not be comprehensive

These components should be treated as the lego blocks you will use for constructing your strategy. The structure of the component object makes it simple to add missing lego blocks as we continue to refine the list of supported components and their definitions; and as the industry evolves strategies over time.

#### Upside components
- cap - value represents the cap rate
- spread - value represents the spread rate
- fixed - value represents the fixed rate credited to the client, independent of index performance.
- performance_trigger - value represents the performance trigger level (e.g., 0.05 for 5%)
- participation - value represents the participation rate
- tier - value represents the tier level at which the rate changes. 

#### Downside Components

Downside protection parameters - including buffers, floors, barriers, and downside participation rates - are included in the Rates API.

Although these elements are not always changed as frequently as caps or participation rates, they are core economic parameters of a strategy and are actively managed as part of a product’s pricing profile.

##### Why Downside Protection Is Included

Downside protection levels differ from structural attributes (such as term, underlier, or crediting method) in that they define the economic payoff profile of the strategy at a given point in time.

They function as pricing variables, similar to:

- Cap rates 
- Participation rates 
- Spreads

Carriers may adjust downside protection levels in response to:
- Market conditions
- Hedging costs
- Competitive positioning
- New issuance cycles

##### Downside Protection Types

Here are the “types” that should be supported, with notes about how to treat their corresponding “values”

**Buffer** - value represents the percentage of downside loss absorbed before client exposure begins.

    Example: value = 0.20 represents a 20% buffer.

**Floor** - value represents the maximum loss permitted over the term. The value should be expressed as a positive decimal reflecting the absolute loss limit.

    Example: value = 0.20 represents a -20% floor (maximum loss of 20%).

**Barrier** - value represents the downside threshold beyond which losses are incurred.

    Example: value = 0.20 represents a 20% barrier.

**DownsideParticipation** - value represents the percentage of index loss applied to the client.

    Example: value = 0.80 represents 80% downside participation.

If a strategy provides full downside protection, no downside protection type should be included in the Rate payload. The absence of a downside protection parameter will be interpreted as full protection.

##### Fully unprotected strategies

For fully unprotected strategies, the preferred representation is:

    type = DownsideParticipation
    value = 1

Recipient may normalize 0% Buffer and 0% Barrier as “no protection” as well, but the preference is to treat unprotected strategies as 100% downside participation.


Examples:

> [!NOTE]  
> For brevity this has not been expressed in a formal JSON schema format, but the intention is to convey the general structure of how different strategy types would be represented using the defined component types and values. 
> The actual implementation would look something like this 
> ```json lines
>    {
>        // Strategy reference identifiers
>        // Rate details
>        "components": [
>                {
>                    "type": "Cap",
>                    "value": 0.1
>                },
>                {
>                    "type": "Participation",
>                    "value": 0.5
>                }
>            ]
>        }
>```

| Strategy type | "Components" details | Notes |
|---|---|---|
| Cap | `type: Cap`<br>`value: 0.1` |  |
| Cap with Participation | `type: Cap`<br>`value: 0.1`<br><br>`type: Participation`<br>`value: 0.5` |  |
| Cap with Absolute Return to Buffer | `type: Cap`<br>`value: 0.1` | Dual directional component is designed as up to the buffer, so we exclude the downside cap |
| Cap with Spread | `type: Cap`<br>`value: 0.1`<br><br>`type: Spread`<br>`value: 0.02` |  |
| Cap with Bonus | `type: Cap`<br>`value: 0.1` | Jackson's Performance Boost (boost rate, which we call Bonus, is always equal to buffer, so we exclude it) |
| Cap with Annual Lock | `type: Cap`<br>`value: 0.1` | Annual lock crediting method not relevant for rates |
| Cap (Lock) then Fixed | `type: Cap`<br>`value: 0.1`<br><br>`type: Fixed`<br>`value: 0.01` | Corebridge Lock strategy |
| Cap with Monthly/Annual Sum | `type: Cap`<br>`value: 0.1` | Additive crediting method not relevant for rates |
| Cap with Monthly/Annual Averaging | `type: Cap`<br>`value: 0.1` | Averaging crediting method not relevant for rates |
| Participation | `type: Participation`<br>`value: 0.5` |  |
| Participation with Spread | `type: Participation`<br>`value: 0.5`<br><br>`type: Spread`<br>`value: 0.02` |  |
| Participation with Fixed | `type: Participation`<br>`value: 0.5`<br><br>`type: Fixed`<br>`value: 0.01` | Nationwide New Heights Select |
| Participation with Monthly/Annual Sum | `type: Participation`<br>`value: 0.5` | Additive crediting method not relevant for rates |
| Performance Trigger | `type: PerformanceTrigger`<br>`value: 0.08` |  |
| Performance Trigger Dual Direction | `type: PerformanceTrigger`<br>`value: 0.08` | The trigger condition being the buffer as opposed to 0% return is not relevant for rates |
| Performance Trigger then Participation | `type: PerformanceTrigger`<br>`value: 0.08`<br><br>`type: Participation`<br>`value: 0.6` | Prudential's Step Rate Plus |
| Tiered Participation | `type: Tier`<br>`value: 0.2`<br><br>`type: Participation`<br>`value: 0.9`<br><br>`type: Participation`<br>`value: 1.25` | Not sure if Tier can change. Might be able to exclude it. Order of participation rates specifies which tier it belongs to. |
| Tiered Bonus | `type: Participation`<br>`value: 1`<br><br>`type: Cap`<br>`value: 0.6` | Symetra Buffer Plus. Tier is always equal to the buffer, so we can exclude it here. |
| Tiered Performance Trigger | `type: Tier`<br>`value: 0`<br><br>`type: PerformanceTrigger`<br>`value: 0.06`<br><br>`type: PerformanceTrigger`<br>`value: 0.12` | Transamerica Triple Edge. Order of performance trigger rates specifies which tier it belongs to. |
| Spread | `type: Spread`<br>`value: 0.02` |  |
| Fixed | `type: Fixed`<br>`value: 0.035` |  |
| Fee | `type: Fee`<br>`value: 0.01` |  |
| Sample strategy: Cap with Buffer and Fee | `type: Cap`<br>`value: 0.255`<br><br>`type: Buffer`<br>`value: 0.1`<br><br>`type: Fee`<br>`value: 0.0095` | Athene Amplify 2.0 sample strategy |
