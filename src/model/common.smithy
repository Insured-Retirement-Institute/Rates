$version: "2"

namespace iri.rates.common

// ─── Shared date / time types ─────────────────────────────────────────────────

/// Calendar date in yyyy-MM-dd format.
@pattern("^\\d{4}-\\d{2}-\\d{2}$")
string ISO8601Date

/// Audit timestamp in yyyy-MM-dd HH:mm:ss.SSS format.
/// Used for created/modified tracking fields.
@pattern("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3}$")
string AuditTimestamp

// ─── Shared jurisdiction types ────────────────────────────────────────────────

/// ISO 3166-2 jurisdiction code — always country + subdivision (e.g. "US-CA", "US-TX").
@pattern("^[A-Z]{2}-[A-Z0-9]{1,3}$")
string JurisdictionCode

list JurisdictionList {
    member: JurisdictionCode
}

// ─── Standard error schema ────────────────────────────────────────────────────
// Per Digital-First-Specifications: every error response (400–599) must include
// httpStatus, code (domain.category.subcategory), timestamp, correlationId,
// technical message, userMessage, and an optional validationErrors array.

/// Standard error response body per IRI Digital-First-Specifications.
structure ErrorResponse {
    /// Numeric HTTP status code (400–599).
    @required
    httpStatus: Integer

    /// Machine-readable structured identifier in domain.category.subcategory format
    /// (e.g. "rates.validation.missingField").
    @required
    code: String

    /// Timestamp when the error was generated.
    @required
    timestamp: AuditTimestamp

    /// Carries forward the inbound request's correlationId for cross-system tracing.
    @required
    correlationId: String

    /// Developer-focused technical explanation.
    @required
    message: String

    /// End-user-friendly explanation, safe to display in portals.
    @required
    userMessage: String

    /// Domain or business rule violations. Each entry has its own code and message.
    validationErrors: ValidationErrorList
}

/// A single domain or business rule violation within an error response.
structure ValidationErrorDetail {
    /// Machine-readable error code (e.g. "rates.validation.premiumBandOverlap").
    @required
    code: String

    /// Human-readable description of the violation.
    @required
    message: String
}

list ValidationErrorList {
    member: ValidationErrorDetail
}
