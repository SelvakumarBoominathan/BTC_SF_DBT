{{ config(materialized='table') }}


-- Aggregate qualifying outputs by destination to produce one alert row per wallet.
WITH WHALES AS (
SELECT
output_address,
SUM(output_value) AS total_sent,
COUNT(*) AS tx_count
FROM {{ ref('stg_btc_transactions')}}

-- Ten BTC is the business threshold used to identify whale-sized individual outputs.
WHERE output_value > 10
GROUP BY output_address
ORDER BY total_sent DESC

)

SELECT 
  w.output_address,
  w.total_sent,
  w.tx_count,
  -- Add a comparable fiat value while retaining the original BTC total for auditability.
  {{ convert_to_usd('w.total_sent') }} AS price,
FROM WHALES w
ORDER BY total_sent desc