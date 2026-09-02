{% macro convert_to_usd(column_name) %}

  {{ column_name}} * (
    SELECT 
    CLOSE_PRICE_USD
    FROM {{ ref('btc_usd_max')}}
    WHERE to_TIMESTAMP(replace(event_date, 'UTC','')) = current_timestamp()
  )

{% endmacro %}