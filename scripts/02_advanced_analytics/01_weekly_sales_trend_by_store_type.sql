/*=====================================================================================
QUERY: Weekly Sales Trend by Store Type
PURPOSE:
    - Analyze weekly sales patterns across different store types.
    - Provide visibility into seasonality, demand fluctuations, and performance trends.
    - Support time-series reporting and advanced analytics for decision-making.
=====================================================================================*/

SELECT 
    store_type, 
    DATEPART(week, date) AS week_num,       -- Extract week number from the date
    SUM(weekly_sales) AS weekly_sales       -- Total weekly sales per store type
FROM gold.train_with_stores_and_features
GROUP BY 
    store_type, 
    DATEPART(week, date)                    -- Group by store type and week number
ORDER BY 
    store_type, 
    week_num;                               -- Chronological ordering within each store type


