# Modern Analytics Warehouse Design with Snowflake

This project demonstrates a **production-style analytics warehouse** built on **Snowflake**, using real-world retail data (Olist).

It showcases how modern data platforms are designed, tested, and operated — beyond just loading data.

---

## What This Project Demonstrates

- RAW → STAGING → ANALYTICS layered architecture
- Typed staging with safe casting
- Dimensional modeling (facts + dimensions)
- Incremental loading using watermark patterns
  ## Incremental Loading: INGESTED_AT vs ORDER_PURCHASE_TS (Watermark Design)

Incremental loads need a *watermark column* to decide “what’s new since last run”.
There are two common choices:

### Option A — Use `INGESTED_AT` (preferred for operational correctness)
**Definition:** the timestamp when the record landed in the warehouse (RAW/STAGING).

**Pros**
- Reliable for incremental ingestion (monotonic in normal pipelines)
- Handles late-arriving events naturally (arrive today even if event happened months ago)
- Great for “did my pipeline ingest new data?” monitoring

**Cons**
- Not always available in source extracts unless you add it
- Doesn’t directly represent business time

### Option B — Use `ORDER_PURCHASE_TS` (business time; good for analytics but tricky for ingestion)
**Definition:** the timestamp when the customer placed the order.

**Pros**
- Intuitive for analysts (business-time driven)
- Useful for time-based backfills and “as-of” analyses

**Cons**
- Late-arriving orders from the source can be **missed** if watermark uses business time
- Not guaranteed to be monotonic (out-of-order arrivals happen)

### What this project does
- Uses a **watermark table** (`sql/ops/watermarks.sql`)
- Loads `FACT_ORDERS` incrementally via **MERGE** (`sql/analytics/fact_orders_incremental.sql`)
- Watermark column is currently `ORDER_PURCHASE_TS` (business-time watermark)

> Production note: In real systems, you often keep **both**:
> - `ORDER_PURCHASE_TS` = business event time
> - `INGESTED_AT` = operational ingestion time (best for incremental ingestion + observability)

- dbt-style data quality tests implemented in pure SQL
- SLA / freshness checks
- Failure-mode and impact analysis


---
## Architecture Overview

Olist CSVs
↓
RAW (external stage → raw tables)
↓
STAGING (typed, cleaned, validated)
↓
ANALYTICS
├── Dimensions
├── Facts
├── Metrics Views
└── Data Quality Tests


---

## Tech Stack

- Snowflake
- SQL (analytics engineering)
- Dimensional modeling
- Data quality & observability patterns

---

## How to Run

1. Load raw data  
   → `sql/raw/load_raw.sql`

2. Build staging tables  
   → `sql/staging/staging_tables.sql`

3. Build analytics layer  
   → `sql/analytics/dimensions.sql`  
   → `sql/analytics/facts.sql`  
   → `sql/analytics/views.sql`

4. Run data quality tests  
   → `sql/tests/test_runner.sql`

---

## Why This Matters

This project focuses on **how analytics systems behave in production**:
- What happens when data is late
- How bad data is detected early
- How failures impact business metrics

---

## Author

**Ashritha Sankineni**  
Senior Data Engineer  
Snowflake • Analytics Engineering • Data Quality • Observability
