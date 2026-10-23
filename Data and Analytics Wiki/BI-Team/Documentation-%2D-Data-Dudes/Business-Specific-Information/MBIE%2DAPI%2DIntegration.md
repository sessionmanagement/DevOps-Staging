# MBIE API Integration

## Overview
- **Purpose:** Document the RealMe/MBIE API authentication setup for Emerge Aotearoa's analytics platform.
- **Owner:** Malhar Badheka (Data Engineer)
- **Last Updated:** 26 February 2026
- **Scope:** RealMe account creation, API key storage, and security-question handling for MBIE API access.
- **Security Note:** All passwords and security answers reside in Azure Key Vault; nothing sensitive is stored in this wiki.

## RealMe Account Setup
| Item | Details |
| --- | --- |
| Portal URL | https://portal.api.business.govt.nz/ |
| Account Email | businessintelligence@emergeaotearoa.org.nz |
| Username | emergeaotearoaltd |
| Password | Stored in Production Key Vault (`kv-prod-aus-svc-syn-01`) |


## API Key / Secret Management
| Environment | Vault | Contents |
| --- | --- | --- |
| Production | Azure Key ProdVault | MBIE production subscription key / token |
| Dev/Test | Azure Key DEV/TESTVault | Sandbox subscription key / token |

- ADF/Synapse pipelines link to these secrets via Key Vault references.
- Rotate keys per MBIE requirements or when incidents occur.

## Security Questions
| Question ID | Prompt | Answer Location |
| --- | --- | --- |
| Q1 | What road did your best friend in secondary/high school live on? | `kv-prod-aus-svc-syn-01` |
| Q2 | What was name of your favourite childhood friend? | `kv-prod-aus-svc-syn-01` |
| Q3 | What was the name of suburb you were born to? | `kv-prod-aus-svc-syn-01` |

- Answers retrieved only by authorized personnel.
- Update Key Vault entries immediately if questions or answers change.

## Operational Notes
- **Account Recovery:** Use RealMe portal "Forgot password"; retrieve answers from Key Vault as needed.
- **Access Requests:** ServiceNow → Data Platform / External API Access → MBIE API.

---

## Technical Specification

This section documents the **Market Rent API v2** provided by MBIE, which exposes rental bond data collected through the Tenancy Bond service.

- **Base URL (Production):** `https://api.business.govt.nz/gateway/tenancy-services/market-rent/v2`
- **Base URL (Sandbox):** `https://api.int.mbie.govt.nz/gateway/tenancy-services/market-rent/v2`
- **API Version:** v2
- **OpenAPI Spec:** Available as `market-rent.json`

### Authentication

Every request must include the API subscription key in **one** of two ways:

| Method | Location | Header / Param Name |
| --- | --- | --- |
| Header | HTTP request header | `Ocp-Apim-Subscription-Key` |
| Query parameter | URL query string | `subscription-key` |

Keys for each environment are stored in Azure Key Vault (see API Key / Secret Management above). Never hardcode keys in pipelines or source code.

### Endpoints

#### 1. `GET /area-definitions`
Returns all available **geographic grouping types** (area definitions).

- No path or query parameters required.
- Use the returned codes as input to the other endpoints.

**Example response:**
```json
{
  "tableName": "area-definitions",
  "referenceDataItems": [
    { "code": "TA2019", "label": "territorial-authority-2019" }
  ]
}
```

---

#### 2. `GET /area-definitions/{area-definition}`
Returns the list of **named areas** (codes and labels) within a given area definition.

| Parameter | Type | Location | Required | Description |
| --- | --- | --- | --- | --- |
| `area-definition` | string | path | Yes | A code or label returned by endpoint 1. e.g. `TA2019` |

**Example response:** Returns area codes/labels such as `Auckland`, `Wellington City`, `Christchurch City`, etc.

---

#### 3. `GET /statistics`
The primary endpoint — returns **market rent statistics** for the specified criteria.

**Required parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| `period-ending` | string (`yyyy-mm`) | End month of the reporting period. Must be at least 2 months before current date. |
| `num-months` | integer (1–24) | Number of months of history to include. |
| `area-definition` | string | Area definition code from endpoint 1, e.g. `TA2019`. |

**Optional parameters:**

| Parameter | Description |
| --- | --- |
| `area-labels` | Filter by specific area names (e.g. `Auckland`). Cannot be used with `area-codes`. |
| `area-codes` | Filter by specific area codes. Cannot be used with `area-labels`. |
| `dwelling-type` | One or more of: `Apartment`, `BoardingHouse`, `Flat`, `House`, `Room`. |
| `num-bedrooms` | One or more of: `1`, `2`, `3`, `4`, `5+`, `NA`. |
| `include-aggregates` | `true`/`false` — include rolled-up "All" rows. Defaults to `false`. |
| `statistics` | Subset of stat fields to return (e.g. `med`, `mean`, `lq`, `uq`). Omit for all. |
| `user-defined-area-mappings` | Custom area groupings using SA2 codes. Only valid when `area-definition=user-defined`. |

**Response fields per record:**

| Field | Description |
| --- | --- |
| `area` | Area name |
| `dwell` | Dwelling type |
| `nBedrms` | Number of bedrooms |
| `nLodged` | New tenancies started in period (randomly rounded) |
| `nClosed` | Bonds closed/refunded in period (randomly rounded) |
| `nCurr` | Total active bonds at end of period (randomly rounded) |
| `lq` | Lower quartile (25th percentile) weekly rent |
| `med` | Median (50th percentile) weekly rent |
| `uq` | Upper quartile (75th percentile) weekly rent |
| `mean` | Mean weekly rent |
| `sd` | Standard deviation of weekly rent |
| `brr` | Bond-to-rent ratio |
| `slq` / `suq` | Synthetic lower/upper quartiles (log-normal model) |
| `lmean` / `lsd` | Log-normal mean and standard deviation |

---

### Intended Flow

```
Step 1: GET /area-definitions
        → Returns available geographic grouping types (e.g. TA2019, UA2019)

Step 2: GET /area-definitions/{area-definition}
        → Returns named areas within that grouping (e.g. Auckland, Wellington)

Step 3: GET /statistics?area-definition=TA2019&area-labels=Auckland&period-ending=2025-03&num-months=12
        → Returns market rent statistics for the specified area and period
```

This three-step pattern ensures area codes and labels used in statistics queries are always valid for the chosen area definition.

## Change Log
| Date | Change | Author |
| --- | --- | --- |
| 17 Feb 2026 | Initial RealMe login creation, API key vault entries, security questions configured. | Malhar Badheka |
| 23 April 2026 | API information on how it works added. | Malhar Badheka |

---
