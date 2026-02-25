# Rate API

## Sample API

**Endpoint:** `GET /product-rates`

This endpoint returns rate information for all available products by a carrier.  
Use `GET /product-details` for enrichment data (for example, mapping rates to premium bands).

## Notes

- A rate `value` of `9999` means uncapped/infinite.
- All date fields use `yyyy-mm-dd` format (for example, `"effectiveDateFrom": "2025-12-01"`).

## Response shape

```json lines
[
  {
    // product identifying information
    "id": "String",
    "idSource": "String" // PRODUCT_DICTIONARY, ACORD
    "variationId": "Option[String]", // e.g. PRODUCT_CODE value
    "rateVariationId": "Option[String]", // e.g. firm identifier 

    // type of product rate 
    "scope": "String", // e.g. NewBusiness, GMIR, Bailout, Renewal, Lock, etc. 

    // temporal rate information 
    "effectiveDate": "String", // When a rate takes effect in the market
    "expiryDate": "Option[String]", // When a rate shold no longer be available. If not provided assumed effective until new one published/received.
    "sweepDate": "Option[String]", // When funds allocated to a strategy begin earning interest. If not provided, assumed same as effectiveDate.
    "publishingDate": "Option[String]", // When a future rate can be publicized as "upcoming".

    "created": "2025-12-02 19:54:05.000", // Audit information for tracking rate changes by the recipient.
    "modified": "2025-12-03 12:14:05.000", // Audit information for tracking rate changes by the recipient.

    // in a RATE entry, the combination of surrender period and premium band id is 
    // needed to identify a group of strategies and their rate components
    "rates": [
      {
        "bandId": "String", // defined in the the product dictionary API
        "surrenderPeriodId": "String", // defined inthe product dictionary API

        "strategies": "List" = [
        {
          "id": "String",
          "applicableJurisdictions": "Option[List[String]]" // e.g. ISO_3166, if not provided, rate should apply to ALL jurisdictions, else please specify breakdown 
          "featureId": "Option[String]" // e.g. ROP, NROP, features associated to this strategy for which the rates are applicable            

          "components": [
            {
              "type": "String", // e.g. Cap, Par, Spread, Fixed, PerformanceTrigger, Buffer,
              "value": "Double", // rate value as a decimal, so value = 0.25 means 25%, if 9999 means uncapped
            }
          ]
        }
      ]
    }
    ]
  },
  ...
]
```

## Field guidance

### Product identifying information
- `id`: product identifier.
- `idSource`: identifier source (for example, `PRODUCT_DICTIONARY`, `ACORD`).
- `variationId`: optional variation identifier (for example, product code).
- `rateVariationId`: optional rate variation identifier (for example, firm identifier).

### Product rate type
- `scope`: rate scope/type (for example, `NewBusiness`, `GMIR`, `Bailout`, `Renewal`, `Lock`).

### Temporal rate information
- `effectiveDate`: when a rate takes effect in market.
- `expiryDate`: optional end date for availability; if omitted, rate is valid until superseded.
- `sweepDate`: optional strategy earning start date; if omitted, assumed equal to `effectiveDate`.
- `publishingDate`: optional date when a future rate can be publicized as upcoming.
- `created` / `modified`: audit timestamps for downstream rate-change tracking.

### Rate grouping and strategy/component model
- In each rate entry, the combination of `surrenderPeriodId` + `bandId` identifies a grouping of strategies and rate components.
- `bandId`: defined in Product Dictionary API.
- `surrenderPeriodId`: defined in Product Dictionary API.
- `strategies[].applicableJurisdictions`: optional list of ISO-3166-style jurisdictions; if omitted, applies to all jurisdictions.
- `strategies[].featureId`: optional feature identifier associated with strategy applicability.
- `components[].type`: component type (for example, `Cap`, `Par`, `Spread`, `Fixed`, `PerformanceTrigger`, `Buffer`).
- `components[].value`: decimal rate value (for example, `0.25` = `25%`); `9999` means uncapped.

