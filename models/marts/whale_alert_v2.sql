{{ config(materialized='table') }}


-- Keep the alert aggregation focused on BTC amounts for consumers that do not need fiat conversion.
WITH WHALES AS (
SELECT
output_address,
SUM(output_value) AS total_sent,
COUNT(*) AS tx_count
FROM {{ ref('stg_btc_transactions')}}

-- Apply the same whale threshold as v1 so the two mart versions remain comparable.
WHERE output_value > 10
GROUP BY output_address
ORDER BY total_sent DESC

)

SELECT 
  w.output_address,
  w.total_sent,
  w.tx_count
FROM WHALES w
ORDER BY total_sent desc