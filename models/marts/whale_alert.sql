{{ config(materialized='table') }}


WITH WHALES AS (
SELECT
output_address,
SUM(output_value) AS total_sent,
COUNT(*) AS tx_count
FROM {{ ref('stg_btc_transactions')}}

WHERE output_value > 10
GROUP BY output_address
ORDER BY total_sent DESC

),
LATEST_PRICE AS (
  SELECT 
  CLOSE_PRICE_USD
  FROM {{ ref('btc_usd_max')}}
  WHERE to_TIMESTAMP(replace(event_date, 'UTC','')) = current_timestamp()
)

SELECT 
  w.output_address,
  w.total_sent,
  w.tx_count,
  (p.CLOSE_PRICE_USD * w.total_sent) AS price
FROM WHALES w
CROSS JOIN LATEST_PRICE p
ORDER BY total_sent desc