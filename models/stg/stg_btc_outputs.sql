
-- Flatten each transaction's nested outputs so downstream models can aggregate one output per row.
{{config(materialized='incremental', incremental_strategy='append')}}

WITH flattened_outputs as (

SELECT 
tx.hash_key,
tx.block_number,
tx.block_timestamp,
tx.is_coinbase,
f.value:address::STRING AS output_address,
f.value:value::FLOAT AS output_value

FROM {{ref('stg_btc')}} tx,

-- A lateral flatten retains the transaction context while expanding every output object.
LATERAL FLATTEN(input => outputs) f

-- Outputs without destination addresses cannot support wallet-level alerts.
WHERE f.value:address IS NOT NULL

{% if is_incremental() %}

-- Reprocess the boundary timestamp so outputs arriving in the same block window are included.
AND tx.block_timestamp >= (SELECT MAX(block_timestamp) FROM {{ this}} )

{% endif %}
)

SELECT 
hash_key,
block_number,
block_timestamp,
is_coinbase,
output_address,
output_value
FROM flattened_outputs