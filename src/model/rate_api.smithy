$version: "2"

namespace iri.rates.rateapi

use aws.protocols#restJson1
use iri.rates.common#ISO8601Date
use iri.rates.common#AuditTimestamp
use iri.rates.common#JurisdictionList
use iri.rates.common#ErrorResponse

/// Rate API — transmits current and upcoming rate values for annuity products.
/// Recipients must also consume the Product Dictionary API to resolve identifiers.
@restJson1
@title("IRI Rate API")
service RateApiService {
    version: "0.1.0"
    operations: [
        GetProductRate
    ]
    errors: [
        ClientError
        ServerError
    ]
}

// ─── Operations ───────────────────────────────────────────────────────────────

/// Returns rate information for a single product identified by its id.
/// Use the Product Dictionary API to resolve surrender period, premium band,
/// and strategy identifiers in the response.
///
/// All query parameters accept a single value only. If a query parameter is
/// repeated (e.g. `?scope=NEW_BUSINESS&scope=GMIR`), the server will reject
/// the request with a 400 ValidationError. Clients must supply at most one
/// value per parameter.
@readonly
@http(method: "GET", uri: "/product-rates/{id}")
operation GetProductRate {
    input: GetProductRateInput
    output: GetProductRateOutput
    errors: [ClientError]
}

// ─── Input / Output shapes ────────────────────────────────────────────────────

structure GetProductRateInput {
    /// Product identifier from the Product Dictionary.
    @required
    @httpLabel
    id: String

    /// Rate scope to retrieve (e.g. NEW_BUSINESS, GMIR). Single value only.
    @httpQuery("scope")
    scope: RateScope

    /// Effective date filter (yyyy-MM-dd). Returns the rate effective on this date.
    /// Single value only.
    @httpQuery("effectiveDate")
    effectiveDate: ISO8601Date
}

structure GetProductRateOutput {
    @required
    rates: ProductRateList
}

// ─── Core domain shapes ───────────────────────────────────────────────────────

/// A rate entry for a single product covering one or more surrender period /
/// premium band combinations and their associated strategy components.
structure ProductRate {
    // ── Product identification ─────────────────────────────────────────────
    /// Product identifier. The source system is indicated by idSource.
    @required
    id: String

    /// Source system for the product identifier.
    @required
    idSource: RateIdSource

    /// Distributor- or carrier-specific product variation identifier.
    variationId: String

    /// Firm-specific rate variation identifier (e.g. a firm override identifier).
    rateVariationId: String

    // ── Rate scope ─────────────────────────────────────────────────────────
    /// Type of rate being communicated.
    @required
    scope: RateScope

    // ── Temporal information ───────────────────────────────────────────────
    /// Date the rate takes effect in the market (yyyy-MM-dd).
    @required
    effectiveDate: ISO8601Date

    /// Date the rate is no longer available.
    /// If absent, the rate is valid until a new one is published or received.
    expiryDate: ISO8601Date

    /// Date funds allocated to a strategy begin earning interest.
    /// If absent, assumed equal to effectiveDate.
    sweepDate: ISO8601Date

    /// Date a future rate may be publicized as upcoming.
    publishingDate: ISO8601Date

    // ── Audit ──────────────────────────────────────────────────────────────
    /// Timestamp when this rate entry was created. For downstream change tracking.
    @required
    created: AuditTimestamp

    /// Timestamp when this rate entry was last modified. For downstream change tracking.
    @required
    modified: AuditTimestamp

    // ── Rate groups ────────────────────────────────────────────────────────
    /// Rate values grouped by surrender period and premium band combinations.
    /// Each group contains the strategies and their component rates.
    @required
    rates: RateGroupList
}

// ─── Rate groups ──────────────────────────────────────────────────────────────

/// A grouping of strategies keyed by a specific surrender period and premium band.
/// Both identifiers are defined in the Product Dictionary API.
structure RateGroup {
    /// Premium band identifier from the Product Dictionary.
    @required
    bandId: String

    /// Surrender period identifier from the Product Dictionary.
    @required
    surrenderPeriodId: String

    /// Strategies and their rate components for this band/period combination.
    @required
    strategies: StrategyList
}

// ─── Strategies ───────────────────────────────────────────────────────────────

/// A strategy within a rate group, identified by its Product Dictionary id,
/// with optional jurisdiction scoping and an associated feature.
structure Strategy {
    /// Strategy identifier from the Product Dictionary.
    @required
    id: String

    /// ISO 3166-2 jurisdictions this strategy rate applies to.
    /// If absent, applies to all jurisdictions.
    applicableJurisdictions: JurisdictionList

    /// Optional feature identifiers (e.g. riders) associated with this strategy rate.
    featureIds: FeatureIdList

    /// Rate components that define the strategy's performance parameters.
    @required
    components: RateComponentList
}

// ─── Rate components ──────────────────────────────────────────────────────────

/// A single rate component — the atomic unit of strategy rate transmission.
///
/// Values are expressed as decimals (0.25 = 25%). A value of 9999 means uncapped.
/// The absence of a downside component implies full downside protection.
structure RateComponent {
    /// Component type (e.g. CAP, PARTICIPATION, BUFFER).
    @required
    type: ComponentType

    /// Rate value as a decimal. 9999 = uncapped/infinite.
    @required
    value: Double
}

// ─── Enums ────────────────────────────────────────────────────────────────────

/// Source system for the product identifier in a rate entry.
enum RateIdSource {
    /// Identifier originates from the IRI Product Dictionary API.
    PRODUCT_DICTIONARY

    /// Identifier originates from ACORD PPFA Spec.
    ACORD
}

/// Scope of the rate being communicated.
enum RateScope {
    /// Rate applies to newly issued contracts.
    NEW_BUSINESS

    /// Guaranteed Minimum Interest Rate floor.
    GMIR

    /// Bailout rate condition.
    BAILOUT
}

/// Crediting strategy component type.
///
/// Upside components define the performance ceiling or participation:
/// CAP, PARTICIPATION, SPREAD, FIXED, PERFORMANCE_TRIGGER, TIER.
///
/// Downside components define loss protection:
/// BUFFER, FLOOR, BARRIER, DOWNSIDE_PARTICIPATION.
///
/// The absence of any downside component implies full downside protection.
/// For a fully unprotected strategy use DOWNSIDE_PARTICIPATION with value = 1.
enum ComponentType {
    // ── Upside ──────────────────────────────────────────────────────────────
    /// Maximum return limit. Value = cap rate (e.g. 0.10 = 10% cap).
    CAP

    /// Percentage of index gain credited. Value = participation rate (e.g. 0.50 = 50%).
    PARTICIPATION

    /// Deduction from index return. Value = spread rate (e.g. 0.02 = 2%).
    SPREAD

    /// Guaranteed credit independent of index performance. Value = fixed rate.
    FIXED

    /// Threshold-based crediting. Value = trigger level (e.g. 0.05 = 5%).
    PERFORMANCE_TRIGGER

    /// Multi-level rate structure boundary. Value = tier threshold.
    TIER

    // ── Downside ────────────────────────────────────────────────────────────
    /// Loss absorbed before client exposure begins. Value = buffer percentage (e.g. 0.20 = 20%).
    BUFFER

    /// Maximum permitted loss over the term. Value = absolute loss limit (e.g. 0.20 = -20% floor).
    FLOOR

    /// Downside threshold beyond which losses are incurred. Value = barrier percentage.
    BARRIER

    /// Percentage of index loss applied to the client. Value = downside participation rate.
    /// Use value = 1 for a fully unprotected strategy.
    DOWNSIDE_PARTICIPATION
}

// ─── List types ───────────────────────────────────────────────────────────────

@length(min: 1)
list ProductRateList {
    member: ProductRate
}

@length(min: 1)
list RateGroupList {
    member: RateGroup
}

@length(min: 1)
list StrategyList {
    member: Strategy
}

@length(min: 1)
list RateComponentList {
    member: RateComponent
}

list FeatureIdList {
    member: String
}

// ─── Errors ───────────────────────────────────────────────────────────────────
// All error responses use the shared ErrorResponse body from iri.rates.common.

@error("client")
@httpError(400)
structure ClientError {
    @required
    error: ErrorResponse
}

@error("server")
@httpError(500)
structure ServerError {
    @required
    error: ErrorResponse
}
