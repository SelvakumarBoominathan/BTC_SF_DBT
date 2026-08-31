
-- 

SELECT 
tx.hash_key,
tx.block_number,
tx.block_timestamp,
tx.is_coinbase,
f.value:address::STRING AS output_address,
f.value:value::FLOAT AS output_value

FROM {{ref('stg_btc')}} tx,

LATERAL FLATTEN(input => outputs) f

WHERE f.value:address IS NOT NULL