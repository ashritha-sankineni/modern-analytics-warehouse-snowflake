-- Typed staging tables with safe casting

CREATE OR REPLACE TABLE RETAIL_ANALYTICS.STAGING.STG_ORDERS AS
SELECT
  TRIM(order_id) AS order_id,
  TRIM(customer_id) AS customer_id,
  TRIM(order_status) AS order_status,
  TRY_TO_TIMESTAMP_NTZ(order_purchase_timestamp) AS order_purchase_ts,
  TRY_TO_TIMESTAMP_NTZ(order_approved_at) AS order_approved_ts,
  TRY_TO_TIMESTAMP_NTZ(order_delivered_carrier_date) AS order_delivered_carrier_ts,
  TRY_TO_TIMESTAMP_NTZ(order_delivered_customer_date) AS order_delivered_customer_ts,
  TRY_TO_TIMESTAMP_NTZ(order_estimated_delivery_date) AS order_estimated_delivery_ts,
  CURRENT_TIMESTAMP() AS ingested_at
FROM RETAIL_ANALYTICS.RAW.RAW_ORDERS;

CREATE OR REPLACE TABLE RETAIL_ANALYTICS.STAGING.STG_ORDER_ITEMS AS
SELECT
  TRIM(order_id) AS order_id,
  TRY_TO_NUMBER(order_item_id) AS order_item_id,
  TRIM(product_id) AS product_id,
  TRIM(seller_id) AS seller_id,
  TRY_TO_TIMESTAMP_NTZ(shipping_limit_date) AS shipping_limit_ts,
  TRY_TO_NUMBER(price, 10, 2) AS price,
  TRY_TO_NUMBER(freight_value, 10, 2) AS freight_value,
  CURRENT_TIMESTAMP() AS ingested_at
FROM RETAIL_ANALYTICS.RAW.RAW_ORDER_ITEMS;
