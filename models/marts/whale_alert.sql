{{ config(materialized='table') }}

SELECT
output_address,
SUM(output_value) AS total_sent,
COUNT(*) AS txn_count
FROM {{ ref('stg_btc_transactions')}}

WHERE output_value > 10
GROUP BY output_address
ORDER BY total_sent DESC