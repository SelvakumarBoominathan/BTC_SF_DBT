{% macro convert_to_usd(column_name) %}

  -- Use the seeded close price to convert an aggregate BTC amount into its USD equivalent.
  {{ column_name}} * (
    SELECT 
    CLOSE_PRICE_USD
    FROM {{ ref('btc_usd_max')}}
    WHERE to_TIMESTAMP(replace(event_date, 'UTC','')) = current_timestamp()
  )

{% endmacro %}