-- sql/ops/freshness_checks.sql
-- Freshness/SLA check for FACT_ORDERS (business-time freshness)

WITH latest AS (
  SELECT MAX(ORDER_PURCHASE_TS) AS max_ts
  FROM RETAIL_ANALYTICS.ANALYTICS.FACT_ORDERS
),
calc AS (
  SELECT
    max_ts,
    DATEDIFF('hour', max_ts, CURRENT_TIMESTAMP()) AS hours_late
  FROM latest
)
SELECT
  max_ts,
  hours_late,
  24 AS sla_hours,
  CASE WHEN hours_late <= 24 THEN 'PASS' ELSE 'FAIL' END AS status,
  CURRENT_TIMESTAMP() AS run_ts
FROM calc;
