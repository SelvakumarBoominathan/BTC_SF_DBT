
-- Incremental merge keeps the raw source history current without rebuilding every block.
{{config(
  materialized = 'incremental',
  incremental_strategy = 'merge',
  unique_key = 'HASH_KEY'
)}}

SELECT
* 
FROM {{ source('btc_source', 'btc_table')}}

{% if is_incremental() %}

-- The timestamp watermark limits incremental loads to blocks newer than the staged data.
WHERE BLOCK_TIMESTAMP >= (SELECT MAX(BLOCK_TIMESTAMP) FROM {{ this }} )

{% endif %}