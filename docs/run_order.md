# Run Order (Bootstrap → Raw → Staging → Analytics → Incremental → Tests → SLA)

## One-time setup
1. `sql/ops/watermarks.sql`
2. (optional) create schemas used by tests

## Initial build
1. `sql/raw/load_raw.sql`
2. `sql/staging/staging_tables.sql`
3. `sql/analytics/dimensions.sql`
4. `sql/analytics/facts.sql`
5. `sql/analytics/views.sql`

## Daily job
1. `sql/analytics/fact_orders_incremental.sql`
2. `sql/tests/test_runner.sql`
3. `sql/ops/freshness_checks.sql`
