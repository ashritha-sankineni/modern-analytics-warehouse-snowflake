# Modern Analytics Warehouse Design with Snowflake

This project demonstrates a **production-style analytics warehouse** built on **Snowflake**, using real-world retail data (Olist).

It focuses on **how analytics systems are designed and operated in production**, not just how data is transformed.

---

## What This Project Shows

- End-to-end **RAW → STAGING → ANALYTICS** warehouse design
- Typed staging with safe casting and validation
- Dimensional modeling (facts and dimensions)
- **Incremental loading using watermark patterns**
- **dbt-style data quality tests implemented in SQL**
- **Freshness / SLA monitoring**
- Failure-mode and impact analysis

---

## Architecture (High Level)

Olist CSVs
↓
RAW (external stage → raw tables)
↓
STAGING (typed, cleaned, validated)
↓
ANALYTICS
├── Dimensions
├── Facts
├── Metrics & Views
└── Data Quality Tests

![Modern Analytics Warehouse Architecture](docs/architecture.png)

---

## Incremental Loading (Production Pattern)

- Incremental loads are implemented using a **watermark table**
- Facts are loaded via **MERGE** (idempotent, update-safe)
- Current watermark uses **business event time** (`ORDER_PURCHASE_TS`)
- Tradeoffs between business-time and ingestion-time watermarks are explicitly considered

📘 *A deeper discussion of watermark design and late-arriving data is documented in*  
`docs/incremental_loading.md`

---

## Data Quality & Testing

Data quality checks follow **dbt-style semantics**, implemented directly in Snowflake SQL:

- Not-null checks
- Uniqueness checks
- Accepted-values validation
- Relationship (foreign key) checks

Each test returns violating rows:
- **0 rows → PASS**
- **>0 rows → FAIL**

A centralized test runner produces a test report for each execution.

---

## Freshness & SLA Monitoring

A freshness check validates that `FACT_ORDERS` data is no more than **24 hours stale** based on business event time.

This helps detect:
- Upstream ingestion delays
- Processing failures
- Data freshness issues impacting analytics

---

## How to Run

### One-time setup
1. Create watermark metadata  
   → `sql/ops/watermarks.sql`

### Initial build
2. Load raw data  
   → `sql/raw/load_raw.sql`

3. Build staging tables  
   → `sql/staging/staging_tables.sql`

4. Build analytics layer  
   → `sql/analytics/dimensions.sql`  
   → `sql/analytics/facts.sql`  
   → `sql/analytics/views.sql`

### Daily execution pattern
5. Incremental fact load  
   → `sql/analytics/fact_orders_incremental.sql`

6. Run data quality tests  
   → `sql/tests/test_runner.sql`

7. Run freshness / SLA checks  
   → `sql/ops/freshness_checks.sql`

---

## Why This Matters

This project emphasizes **production behavior**, including:

- Detecting late or missing data
- Preventing bad data from silently reaching analytics
- Understanding how pipeline failures impact business metrics
- Operating analytics systems reliably over time

---

## Author

**Ashritha Sankineni**  
Senior Data Engineer  
Snowflake • Analytics Engineering • Data Quality • Observability
