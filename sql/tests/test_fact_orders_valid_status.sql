CREATE OR REPLACE VIEW RETAIL_ANALYTICS.TESTS.TEST_FACT_ORDERS_VALID_STATUS AS
SELECT *
FROM RETAIL_ANALYTICS.ANALYTICS.FACT_ORDERS
WHERE ORDER_STATUS IS NOT NULL
  AND LOWER(ORDER_STATUS) NOT IN (
    'delivered',
    'shipped',
    'canceled',
    'invoiced',
    'processing',
    'created',
    'approved',
    'unavailable'
  );
