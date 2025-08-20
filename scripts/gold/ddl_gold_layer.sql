/*
================================================================================
Purpose:
Create gold layer views that enrich the training data with store and feature
information. These views combine silver.train with silver.stores and 
silver.features to prepare data for modeling and analytics.
================================================================================
*/

-- Drop and recreate view: gold.train_with_stores
IF OBJECT_ID('gold.train_with_stores', 'V') IS NOT NULL
    DROP VIEW gold.train_with_stores;
GO

CREATE VIEW gold.train_with_stores AS
SELECT
    t.store_id,
    t.department,
    t.date,
    t.weekly_sales,
    t.returns,
    t.is_holiday AS train_is_holiday,           -- Preserve train table holiday flag
    t.holiday_status AS train_holiday_status,   -- Preserve train table holiday status
    s.store_type,                               -- Add store type from silver.stores
    s.store_size                                -- Add store size from silver.stores
FROM silver.train t
LEFT JOIN silver.stores s
    ON t.store_id = s.store_id;
GO

-- Drop and recreate view: gold.train_with_stores_and_features
IF OBJECT_ID('gold.train_with_stores_and_features', 'V') IS NOT NULL
    DROP VIEW gold.train_with_stores_and_features;
GO

CREATE VIEW gold.train_with_stores_and_features AS
SELECT
    t.store_id,
    t.department,
    t.date,
    t.weekly_sales,
    t.returns,
    t.is_holiday AS train_is_holiday,
    t.holiday_status AS train_holiday_status,
    s.store_type,
    s.store_size,
    f.temperature,                             -- Enriched with daily temperature
    f.fuel_price,                               -- Enriched with fuel price
    f.mark_down1,                               -- Enriched with promotional markdowns
    f.mark_down2,
    f.mark_down3,
    f.mark_down4,
    f.mark_down5,
    f.consumer_price_index,                     -- CPI indicator
    f.unemployment,                             -- Unemployment rate
    f.is_holiday AS features_is_holiday,       -- Features table holiday flag
    f.holiday_status AS features_holiday_status -- Features table holiday status
FROM silver.train t
LEFT JOIN silver.stores s
    ON t.store_id = s.store_id
LEFT JOIN silver.features f
    ON t.store_id = f.store_id
   AND t.date = f.date;                         -- Join on store and date
GO

