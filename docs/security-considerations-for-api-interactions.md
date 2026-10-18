# Security Considerations for API Interactions

This document defines the security requirements for the push and pull mechanisms described in [Push and Pull Mechanisms](./push-and-pull-mechanisms.md). The two mechanisms reverse the direction of the connection, so they also reverse who is responsible for access control.

The requirements apply to both the Product Dictionary API and the Rate API.

**Terminology.** The **Data Provider** is the party that publishes rates (a carrier). The **Requestor** is the party that consumes them (a solution provider such as iCapital).

## 1. Summary of responsibilities

| Mechanism | Who calls whom | Who mints credentials | Who enforces authorization | What is enforced |
| --- | --- | --- | --- | --- |
| Push | Data Provider calls the Requestor | Requestor | Requestor | The Data Provider may only update the products it is authorized to update |
| Pull | Requestor calls the Data Provider | Data Provider | Data Provider | The Requestor may only pull the products, or variations of products, it is authorized to access |

In both directions the party that receives the request is the one that authenticates the caller and decides what the caller is allowed to touch.

In this document a product is identified by its canonical product identifier as defined by the carrier (such as a CUSIP).

## 2. Push security requirements

In push, the Data Provider sends rate updates to an endpoint hosted by the Requestor.

- **Credential issuance.** The Requestor mints client credentials for each Data Provider and supplies them to that Data Provider.
- **Data Provider use of credentials.** The Data Provider presents those credentials on every push request.
- **Authorization by product.** The Requestor is responsible for ensuring that a Data Provider updates only the products (including all variations of each product) that it is authorized to update. A push that includes a product outside the Data Provider's authorized set must be rejected.

## 3. Pull security requirements

In pull, the Requestor calls the Data Provider's API. This covers `GET /v1/product-dictionary`, `GET /v1/product-dictionary/{id}`, and `GET /v1/product-rates/{id}`. Responsibility is reversed compared with push.

- **Authorization by product and variation.** The Data Provider is responsible for ensuring that a Requestor can pull only the products, or variations of products, that it is authorized to access.
- **Variation-level scope.** Access to a product does not imply access to all of its variations. The Data Provider must evaluate authorization at the variation level for every request, including change queries that use `modifiedFrom` and `modifiedTo`.
- **Filtering, not failure.** A change query on an authorized product must return only the authorized variations. Unauthorized variations are not returned.

## 4. Authentication and credential lifecycle

These requirements apply in both directions. The party that mints the credentials (see section 1) is responsible for issuing, rotating and revoking them.

### 4.1 Credential types

Client credentials are typically either:

- OAuth 2.0 client credentials, or
- API keys.

### 4.2 API key rotation: overlapping validity

If API keys are used, expiry and reissue must be seamless, with no outage while the caller switches keys. At some point a key will be expiring while a new key has already been minted, so both keys must be active at the same time for a short period.

### 4.3 OAuth 2.0 client credentials

When OAuth is used, the caller exchanges its client credentials for an access token and presents that token on each request. The same seamless-rotation principle applies to the client secret: the issuer should be able to hold a current and a replacement secret active together while the caller switches.

## 5. API responses

Response codes follow the IRI Digital-First specification conventions: a 2xx response means the request was received and acknowledged, any non-2xx response means it failed, and every error response (400–599) carries the standard `ErrorResponse` body defined in `rate-api-v0.0.1.yaml`.

### 5.1 Push responses (Data Provider to Requestor)

| Status | When it is returned |
| --- | --- |
| `200 OK` | Acknowledged. The update was accepted. It was either applied, or valid but changed nothing because the rate already matches what is stored (the response body says which). The Data Provider must not retry. |
| `400 Bad Request` | The payload is malformed or fails validation (for example, a timestamp with no UTC offset). |
| `403 Forbidden` | The caller is not authorized to modify the product (or one of its variations) in the update. |
| Any other non-2xx or a timeout | The delivery failed. The Data Provider must retry under its documented retry policy. IRI recommends exponential backoff with at least 5 attempts over at least 24 hours. |

### 5.2 Pull responses (Requestor to Data Provider)

| Status | When it is returned |
| --- | --- |
| `200 OK` | The request succeeded. The body contains the entries the caller is authorized to see, as described in section 3. |
| `400 Bad Request` | The request is malformed or fails validation (for example, a repeated query parameter, or a `modifiedFrom` with no UTC offset). |
| `403 Forbidden` | The caller is not authorized to access the product. |
| `404 Not Found` | The product `{id}` is not known to the Data Provider. |
| `500 Internal Server Error` | The Data Provider failed to process the request. |
