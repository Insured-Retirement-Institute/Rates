$version: "2"

namespace iri.rates.traits

/// Applied to a list shape whose member structure has `premiumFrom` and `premiumTo`
/// numeric fields. Signals that the server must reject payloads where any two entries
/// have overlapping ranges, and that code generators should emit range-overlap validation.
///
/// Build-time: the accompanying validator checks that the annotated list's member
/// structure exposes both `premiumFrom` and `premiumTo` members of a numeric type.
///
/// Runtime: overlap detection must be enforced by the server implementation.
@trait(selector: "list")
structure noOverlappingRanges {}
