# Product Dictionary API (WIP)

This document captures the Product Dictionary API details from the provided spec text and session notes.

## Purpose
The Product Dictionary API provides authoritative reference data for annuity products so downstream rate workflows can use consistent identifiers and structures.

## Design context
- Recipients have different operating models and data models.
- The API should be flexible enough to support current and future product innovation.
- The API is intended to support all product and strategy combinations required for rate exchange.

## Data domains
The Product Dictionary API provides:
- Product identifying information
- Product variation information
- Surrender periods
- Premium bands
- Strategies
- Features

## Relationship to Rate API
Rate payloads reference identifiers from the Product Dictionary API.  
Rate API payloads may include:
- Rate variation information
- Rate type (new business, GMIR, renewal, etc.)
- Effective dates
- Rates list
- Premium bands and surrender periods
- Strategy-level state, feature, and rate details

## Representation
### API description (WIP!)
```json lines
[
  {
    // product identifying information
    "id": "String",
    "idSource": "String", // e.g. CUSIP value
    "displayName": "String", 
    
    // product variation information (if any)
    "variationId": "Option[String]", // Only present if product is a varition from the generic version
    "dtccCode": "Option[String]", // Only present if rate specific to a distributor, code used to identify the distributor
    "dtccMemberName,": "Option[String]", // Only present if rate specific to a distributor, name used to note name of distributor

    // product availability information
    "effectiveDate": "String" // e.g. yyyy-mm-dd, when this product is effective
    "expiryDate": "Option[String]" // e.g. yyyy-mm-dd, when this product is no longer availabe for new business
    "applicableJurisdictions": "Option[List[String]]" // e.g. ISO_3166, if product not available in all jurisdictions, specify which ones
    
    "surrenderPeriods": List = [
      "id": "String"
      "period": "String" // e.g. 0y, 3y, 5y, etc.
    ],
    
    "premiumBands": List = [
      {
        "id": "String", // Definition used to refer back to Rate API
        "premiumFrom": "Double", // minimum premium to qualify into band, SHOULD NOT OVERLAP
        "premiumTo":" Option[Double]", // max premium to qualify into band, if not provided, assume no upper limit
      }
    ],
    
    "strategies": "List[Strategy]" = [
      {
        // strategy identifying information  
        "id": "String",
        "displayName": "String",   
        "effectiveDate": "String", // e.g. yyyy-mm-dd, when the strategy is available 
        "expiryDate": "Option[String]", // e.g. yyyy-mm-dd, when the strategy is no longer available
        "applicableJurisdictions": "Option[List[String]]" // e.g. ISO_3166, if not provided, strategy should apply to ALL jurisdictions, else please specify breakdown 
      }
    ],
  
    "features": "Option[List]" = [
      {  
        "id": "String", 
        "displayName": "String", // display name of rider or rider
        "effectiveDate": "String", 
        "expiryDate": "Option[String]",
        "applicableJurisdictions": "Option[List[String]]" // e.g. ISO_3166, if not provided, rate should apply to ALL jurisdictions, else please specify breakdown 
      }
    ]
  },
...
]

```
### Example payload (JSON)
```json
{
  "productId": "PROD-001",
  "productName": "Sample FIA Product",
  "productVariation": "Series A",
  "premiumBands": [
    { "bandId": "PB1", "min": 0, "max": 99999 },
    { "bandId": "PB2", "min": 100000, "max": 999999 }
  ],
  "surrenderPeriods": [
    { "periodId": "SP1", "years": 7 }
  ],
  "strategies": [
    {
      "strategyId": "STRAT-1",
      "strategyName": "1-Year Point-to-Point",
      "states": ["CA", "TX", "NY"]
    }
  ],
  "features": [
    {
      "featureId": "FEAT-GWBL",
      "featureName": "GWBL Rider"
    }
  ]
}
```

## User-story alignment
- New issue workflows require shared product reference data for bulk and single-CUSIP rates.
- Renewal workflows require the same reference model to keep renewal options consistent across systems.
