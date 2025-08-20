/*
================================================================================
Purpose:
Define the core tables in the silver layer of the Walmart data pipeline. 
This script ensures tables are dropped if they exist and recreated with the 
appropriate structure to store cleaned and enriched data ready for analytics.
================================================================================
*/

-- Drop and create silver.stores table
IF OBJECT_ID('silver.stores', 'U') IS NOT NULL
    DROP TABLE silver.stores;

CREATE TABLE silver.stores(
    store_id INT,         -- Unique identifier for each store
    store_type CHAR(1),   -- Store category/type (e.g., A, B, C)
    store_size INT        -- Physical size of the store in square feet
);

-- Drop and create silver.features table
IF OBJECT_ID('silver.features', 'U') IS NOT NULL
    DROP TABLE silver.features;

CREATE TABLE silver.features(
    store_id INT,                 -- Identifier linking to silver.stores
    date DATE,                     -- Date of the recorded features
    temperature FLOAT,             -- Average temperature on that date
    fuel_price FLOAT,              -- Fuel price on that date
    mark_down1 FLOAT,              -- Promotional markdowns 1–5
    mark_down2 FLOAT,
    mark_down3 FLOAT,
    mark_down4 FLOAT,
    mark_down5 FLOAT,
    consumer_price_index FLOAT,    -- CPI for economic context
    unemployment FLOAT,            -- Unemployment rate
    is_holiday BIT,                -- Flag for holiday (1=yes, 0=no)
    holiday_status VARCHAR(50)     -- Holiday description
);

-- Drop and create silver.train table
IF OBJECT_ID('silver.train', 'U') IS NOT NULL
    DROP TABLE silver.train;

CREATE TABLE silver.train(
    store_id INT,                 -- Identifier linking to silver.stores
    department INT,               -- Department number within the store
    date DATE,                     -- Date of weekly sales
    weekly_sales FLOAT,            -- Weekly sales amount
    returns FLOAT,                 -- Returned items amount
    is_holiday BIT,                -- Flag for holiday (1=yes, 0=no)
    holiday_status VARCHAR(50)     -- Holiday description
);

-- Drop and create silver.test table
IF OBJECT_ID('silver.test', 'U') IS NOT NULL
    DROP TABLE silver.test;

CREATE TABLE silver.test(
    store_id INT,
    department INT,
    date DATE,
    is_holiday BIT,
    holiday_status VARCHAR(50)
);

-- Drop and create silver.sample_submission table
IF OBJECT_ID('silver.sample_submission', 'U') IS NOT NULL
    DROP TABLE silver.sample_submission;

CREATE TABLE silver.sample_submission(
    store_id INT,
    department INT,
    date DATE,
    weekly_sales FLOAT
);

