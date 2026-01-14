# Modern Analytics Warehouse Design with Snowflake

This project demonstrates a **production-style analytics warehouse** built on **Snowflake**, using real-world retail data (Olist).

It showcases how modern data platforms are designed, tested, and operated — beyond just loading data.

---

## What This Project Demonstrates

- RAW → STAGING → ANALYTICS layered architecture
- Typed staging with safe casting
- Dimensional modeling (facts + dimensions)
- Incremental loading using watermark patterns
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
