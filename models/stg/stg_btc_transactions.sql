{{config(materialized='ephemeral')}}

-- Exclude coinbase outputs because they represent mining rewards rather than wallet transfers.
SELECT 
* 
FROM {{ ref('stg_btc_outputs') }} 
WHERE is_coinbase = false