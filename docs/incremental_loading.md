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
