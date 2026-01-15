# Incremental Loading Design


---

## Why Incremental Loading Matters

In production analytics systems:

- Full table rebuilds are inefficient and costly
- Data arrives continuously and often out of order
- Late or corrected records must be handled safely
- Pipelines must be restartable without data corruption

Incremental loading addresses these challenges by processing **only new or changed data** since the last successful run.

---

## Watermark-Based Incremental Pattern

This project uses a **watermark-based approach** to determine which records should be processed during each run.

### Watermark Table

A dedicated metadata table tracks the last successfully processed timestamp:

```sql
RETAIL_ANALYTICS.OPS.WATERMARKS
```

### Each entry stores:

Pipeline name

Target table

Watermark column

Last processed value

Last updated timestamp

This decouples incremental state from the data itself and enables:

Safe restarts

Multiple independent pipelines

Clear operational visibility

## Watermark Column Choices

Selecting the correct watermark column is critical.

#### Option 1 — INGESTED_AT (Operational Time)

Definition: Timestamp when a record is ingested into the warehouse (RAW or STAGING).

##### Characteristics

Monotonic under normal operation

Ideal for pipeline correctness and monitoring

Naturally handles late-arriving source data

##### Tradeoffs

Must be explicitly added during ingestion

Does not represent business event time

##### Typical use

Pipeline freshness monitoring

Incremental ingestion correctness

Operational alerting

### Option 2 — ORDER_PURCHASE_TS (Business Event Time)

Definition: Timestamp when the customer placed the order.

##### Characteristics

Meaningful for analytics and reporting

Useful for business-time backfills and historical analysis

##### Tradeoffs

Not guaranteed to be monotonic

Late-arriving records may be missed if used alone

Less reliable for ingestion correctness

Typical use

Business-time analytics

Historical trend analysis

### What This Project Implements

This project currently uses business event time as the incremental watermark:

Watermark column: ORDER_PURCHASE_TS

Target table: ANALYTICS.FACT_ORDERS

Incremental logic implemented using MERGE

The implementation is intentionally designed to:

Demonstrate business-time incremental tradeoffs

Remain simple and reproducible

Highlight design decisions rather than hide them

Production note: Real-world systems typically track both business time and ingestion time:

ORDER_PURCHASE_TS → analytics and reporting

INGESTED_AT → ingestion correctness and observability

## Incremental MERGE Strategy

Incremental loads into FACT_ORDERS are performed using a MERGE statement:

Existing records are updated when matched

New records are inserted when not matched

Duplicate inserts are prevented

Re-runs are idempotent

##### This allows:

Safe retries after failures

Late corrections from upstream sources

Consistent downstream analytics

##### Implementation:

sql/analytics/fact_orders_incremental.sql

Watermark Advancement Strategy

After each successful load, the watermark is advanced:

Only when new eligible data exists

Based on the maximum processed timestamp

Never moved backward

This ensures:

No data is skipped

No data is reprocessed unnecessarily

Incremental state remains consistent

Handling Late-Arriving Data

Late-arriving data is a common production challenge.

##### In this design:

Late records with older ORDER_PURCHASE_TS may not be picked up automatically

This tradeoff is acknowledged and documented

Typical production mitigations include:

Periodic backfills

Sliding window reprocessing

Switching to ingestion-time watermarks

These enhancements are intentionally left as future improvements to keep the core design clear.

### Failure Modes & Impact

Potential failure scenarios include:

Scenario	Impact
Upstream ingestion delay	Freshness SLA fails
Late-arriving orders	Business metrics may lag
Partial load failure	MERGE allows safe rerun
Duplicate source records	Prevented by MERGE logic

These failure modes are detected through:

Data quality tests

Freshness SLA checks

Watermark inspection

## Summary

This incremental loading design prioritizes:

Correctness over convenience

Explicit tradeoffs over hidden assumptions

Observability and restartability

Production realism

It mirrors patterns commonly used in real-world Snowflake analytics platforms while remaining lightweight and transparent for demonstration purposes.


---


---

### Next optional upgrades (only if you want)
- Add a small **diagram** for watermark flow  
- Add an `INGESTED_AT` example as a future enhancement  
- Link this doc from README (already recommended)
