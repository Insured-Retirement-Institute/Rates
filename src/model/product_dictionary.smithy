$version: "2"

namespace iri.rates.productdictionary

use aws.protocols#restJson1
use iri.rates.traits#noOverlappingRanges
use iri.rates.common#ISO8601Date
use iri.rates.common#JurisdictionCode
use iri.rates.common#JurisdictionList
use iri.rates.common#ErrorResponse

/// Product Dictionary API — provides authoritative reference data for annuity
/// products so downstream rate workflows can use consistent identifiers and structures.
@restJson1
@title("IRI Product Dictionary API")
service ProductDictionaryService {
    version: "0.0.1"
    operations: [
        ListProducts
        GetProduct
    ]
    errors: [
        ClientError
        NotFoundError
        ServerError
    ]
}

// ─── Operations ───────────────────────────────────────────────────────────────

/// Returns a paginated list of all products in the dictionary.
@readonly
@http(method: "GET", uri: "/product-dictionary")
operation ListProducts {
    input: ListProductsInput
    output: ListProductsOutput
}

/// Returns a single product by its internal id.
@readonly
@http(method: "GET", uri: "/product-dictionary/{id}")
operation GetProduct {
    input: GetProductInput
    output: GetProductOutput
    errors: [NotFoundError, ClientError]
}

// ─── Input / Output shapes ────────────────────────────────────────────────────

structure ListProductsInput {
    /// Return only products with this idSource (e.g. CUSIP).
    @httpQuery("idSource")
    idSource: String

    /// Zero-based offset of the first item to return (default 0).
    @httpQuery("offset")
    offset: Integer

    /// Maximum number of items to return per page (default 50).
    @httpQuery("limit")
    limit: Integer
}

structure ListProductsOutput {
    @required
    products: ProductList

    @required
    metadata: PaginationMetadata
}

/// Offset-based pagination metadata included in list responses.
structure PaginationMetadata {
    /// Zero-based offset of the first item in the current page.
    @required
    offset: Integer

    /// Maximum number of items requested for this page.
    @required
    limit: Integer

    /// Offset to use for the next page. Absent when there are no more pages.
    nextOffset: Integer

    /// Total number of items across all pages. May be absent if the total is unknown.
    totalCount: Integer
}

structure GetProductInput {
    @required
    @httpLabel
    id: String
}

structure GetProductOutput {
    @required
    product: Product
}

// ─── Core domain shapes ───────────────────────────────────────────────────────

/// Full product record as stored in the Product Dictionary.
structure Product {
    /// Internal stable identifier for this product record.
    @required
    id: String

    /// Source system that minted the identifier.
    @required
    idSource: IdSource

    /// Human-readable product name.
    @required
    displayName: String

    // ── Variation ──────────────────────────────────────────────────────────
    /// Populated only when this record is a variation of a generic product.
    variationId: String

    /// DTCC member code identifying a distributor-specific variation.
    dtccCode: String

    /// Human-readable name of the DTCC member / distributor.
    dtccMemberName: String

    // ── Availability ───────────────────────────────────────────────────────
    /// Date the product became available for new business (yyyy-MM-dd).
    @required
    effectiveDate: ISO8601Date

    /// Date after which the product is no longer available for new business (yyyy-MM-dd).
    /// Absent means open-ended.
    expiryDate: ISO8601Date

    /// ISO 3166-2 jurisdiction codes in which the product is available.
    /// When absent the product is assumed available in all jurisdictions.
    applicableJurisdictions: JurisdictionList

    // ── Sub-structures ─────────────────────────────────────────────────────
    @required
    surrenderPeriods: SurrenderPeriodList

    @required
    premiumBands: PremiumBandList

    @required
    strategies: StrategyList

    features: FeatureList
}

// ─── Surrender periods ────────────────────────────────────────────────────────

/// A named surrender-charge period associated with a product.
structure SurrenderPeriod {
    /// Stable identifier referenced by Rate API payloads.
    @required
    id: String

    /// Duration in years (e.g. "0y", "3y", "10y") up to 25y.
    @required
    period: SurrenderPeriodDuration
}

// ─── Premium bands ────────────────────────────────────────────────────────────

/// A premium-amount tier that qualifies a contract into a specific rate band.
///
/// Invariants (enforced by the server, not the schema):
/// - `premiumFrom` of each band must be strictly greater than `premiumTo` of the previous band.
/// - No two bands may share an overlapping premium range.
/// - Together the bands should cover the full intended premium range without gaps.
structure PremiumBand {
    /// Stable identifier referenced by Rate API payloads.
    @required
    id: String

    /// Minimum premium (inclusive) required to qualify for this band.
    @required
    premiumFrom: Double

    /// Maximum premium (inclusive) for this band.
    /// When absent there is no upper limit.
    premiumTo: Double
}

// ─── Strategies ───────────────────────────────────────────────────────────────

/// A crediting strategy available on the product (e.g. "1-Year Point-to-Point").
structure Strategy {
    /// Stable identifier referenced by Rate API payloads.
    @required
    id: String

    /// Human-readable strategy name.
    @required
    displayName: String

    /// Date the strategy became available (yyyy-MM-dd).
    @required
    effectiveDate: ISO8601Date

    /// Date the strategy is no longer available (yyyy-MM-dd). Absent means open-ended.
    expiryDate: ISO8601Date

    /// ISO 3166-2 jurisdiction codes in which the strategy is available.
    /// When absent the strategy is available in all jurisdictions.
    applicableJurisdictions: JurisdictionList
}

// ─── Features ─────────────────────────────────────────────────────────────────

/// An optional rider or product feature (e.g. "GWBL Rider").
structure Feature {
    /// Stable identifier referenced by Rate API payloads.
    @required
    id: String

    /// Human-readable feature / rider name.
    @required
    displayName: String

    /// Date the feature became available (yyyy-MM-dd).
    @required
    effectiveDate: ISO8601Date

    /// Date the feature is no longer available (yyyy-MM-dd). Absent means open-ended.
    expiryDate: ISO8601Date

    /// ISO 3166-2 jurisdiction codes in which the feature is available.
    /// When absent the feature is available in all jurisdictions.
    applicableJurisdictions: JurisdictionList
}

// ─── Constrained string types ─────────────────────────────────────────────────

/// Surrender period duration in the format "{n}y" where n is 0–25 (e.g. "0y", "7y", "25y").
@pattern("^(2[0-5]|1[0-9]|[0-9])y$")
string SurrenderPeriodDuration

// ─── Enums ────────────────────────────────────────────────────────────────────

/// Source system that minted a product identifier.
enum IdSource {
    /// CUSIP — Committee on Uniform Securities Identification Procedures identifier.
    CUSIP

    /// Internal proprietary identifier assigned by the carrier or platform.
    INTERNAL
}

// ─── List types ───────────────────────────────────────────────────────────────

@length(min: 1)
list ProductList {
    member: Product
}

@length(min: 1)
list SurrenderPeriodList {
    member: SurrenderPeriod
}

@length(min: 1)
@noOverlappingRanges
list PremiumBandList {
    member: PremiumBand
}

@length(min: 1)
list StrategyList {
    member: Strategy
}

list FeatureList {
    member: Feature
}

// ─── Errors ───────────────────────────────────────────────────────────────────
// All error responses use the shared ErrorResponse body from iri.rates.common.

@error("client")
@httpError(400)
structure ClientError {
    @required
    error: ErrorResponse
}

@error("client")
@httpError(404)
structure NotFoundError {
    @required
    error: ErrorResponse
}

@error("server")
@httpError(500)
structure ServerError {
    @required
    error: ErrorResponse
}
