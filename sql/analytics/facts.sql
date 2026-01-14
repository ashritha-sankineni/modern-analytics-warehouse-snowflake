CREATE OR REPLACE TABLE RETAIL_ANALYTICS.ANALYTICS.FACT_ORDERS AS
SELECT
  order_id,
  customer_id,
  CAST(order_purchase_ts AS DATE) AS purchase_date_key,
  order_status,
  order_purchase_ts,
  order_delivered_customer_ts,
  DATEDIFF('day', order_purchase_ts, order_delivered_customer_ts) AS days_to_deliver,
  CURRENT_TIMESTAMP() AS loaded_at
FROM RETAIL_ANALYTICS.STAGING.STG_ORDERS;

CREATE OR REPLACE TABLE RETAIL_ANALYTICS.ANALYTICS.FACT_ORDER_ITEMS AS
SELECT
  order_id,
  order_item_id,
  product_id,
  seller_id,
  price,
  freight_value,
  COALESCE(price,0) + COALESCE(freight_value,0) AS item_total_value,
  CURRENT_TIMESTAMP() AS loaded_at
FROM RETAIL_ANALYTICS.STAGING.STG_ORDER_ITEMS;
