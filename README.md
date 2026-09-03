# BTC Whale Alert Analytics

This project is a dbt-powered analytics pipeline for Bitcoin transaction monitoring. It ingests raw BTC transaction data from a source table, stages and transforms the data, and builds merchant-style warehouse models that identify large outbound transfers (whale alerts) based on transaction output value thresholds.

## Overview

The project focuses on:

- Ingesting raw BTC transaction data from a source table
- Flattening and normalizing transaction outputs
- Filtering coinbase transactions
- Aggregating large output transfers by destination address
- Calculating USD-equivalent value using a close-price seed
- Exposing the final model through a dbt exposure for BI consumption

## Project Structure

- `models/stg/` — staging models for raw BTC data, output flattening, and transaction preparation
- `models/marts/` — final whale alert mart models
- `seeds/` — static reference data such as BTC/USD close prices
- `macros/` — reusable dbt macros, including USD conversion logic
- `tests/` — custom schema validation logic
- `snapshots/` and `state/` — dbt state and snapshot artifacts

## Core Models

- `stg_btc` — incremental raw BTC source model
- `stg_btc_outputs` — flattens transaction outputs and keeps valid output addresses
- `stg_btc_transactions` — removes coinbase transactions
- `whale_alert_v1` — identifies large wallet outputs and converts values to USD
- `whale_alert_v2` — versioned model variant without the USD conversion field

## Source Configuration

The project expects a source named `btc_source` with a table named `btc_table` in the configured Snowflake database/schema. The source definition is managed in [models/sources.yml](models/sources.yml).

## Prerequisites

Before running this project, ensure you have:

- dbt Core installed
- A valid dbt profile configured for the `BTC` project name
- Access to the Snowflake database and schema used by the source tables
- The `dbt_utils` package available through `packages.yml`

## Setup

1. Confirm your dbt profile is configured for the `BTC` profile name.
2. Install package dependencies:

   ```bash
   dbt deps
   ```

3. Validate the connection:

   ```bash
   dbt debug
   ```

4. Run the project models:

   ```bash
   dbt run
   ```

5. Run the tests:

   ```bash
   dbt test
   ```

6. Run only the whale alert models if needed:

   ```bash
   dbt run --select whale_alert
   ```

## Validation Status

Repository health check completed successfully:

- `dbt parse` succeeded
- `dbt test` succeeded
- 4 tests passed
- 0 failed, 0 warnings, 0 errors

## Notes

- The project uses incremental logic for staging models and a merge strategy for the base BTC staging model.
- Address validation is enforced in the schema for the whale alert output address field.
- The USD conversion macro reads from the seed dataset in `seeds/btc_usd_max.csv` and applies it to output values.

## License and Ownership

This project is intended for analytics and wallet-monitoring use cases and is configured for a personal analytical workflow. Update connection details and warehouse names to match your production environment before deployment.
