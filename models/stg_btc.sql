
{{config(
  materialized = 'incremental',
  incremental_strategy = 'merge',
  unique_key = 'HASH_KEY'
)}}

SELECT
* 
FROM {{ source('btc_source', 'btc_table')}}

{% if is_incremental() %}

WHERE BLOCK_TIMESTAMP >= (SELECT MAX(BLOCK_TIMESTAMP) FROM {{ this }} )

{% endif %}