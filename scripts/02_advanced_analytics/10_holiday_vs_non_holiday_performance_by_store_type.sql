/*================================================================================
QUERY: Holiday vs. Non-Holiday Performance by Store Type

PURPOSE:
This query compares sales performance between holiday and non-holiday periods
for each store type. It evaluates both average sales per week and total sales.

USE CASE:
Helps identify whether holidays drive higher sales across different store types,
supporting strategic planning for promotions, staffing, and inventory allocation.
================================================================================*/

SELECT 
    store_type,
    train_is_holiday,                       -- Holiday flag (1 = Holiday, 0 = Non-Holiday)
    AVG(weekly_sales) AS avg_sales,         -- Average sales per week for the group
    SUM(weekly_sales) AS total_sales        -- Total sales across the group
FROM gold.train_with_stores_and_features
GROUP BY store_type, train_is_holiday
ORDER BY store_type, train_is_holiday DESC; -- Show holiday periods before non-holidays


