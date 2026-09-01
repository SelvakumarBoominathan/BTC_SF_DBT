{{config(materialized='ephemeral')}}

SELECT 
* 
FROM {{ ref('stg_btc_outputs') }} 
WHERE is_coinbase = false