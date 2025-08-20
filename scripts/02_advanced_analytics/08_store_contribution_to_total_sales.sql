/*================================================================================
QUERY: Store Contribution to Total Sales

PURPOSE:
This query calculates how much each store contributes to the company's total sales.
It expresses store-level sales both in absolute terms and as a percentage of the
overall sales across all stores.

USE CASE:
Enables business leaders to identify top-performing stores, compare store-level
contributions, and prioritize resources for high- or low-performing stores.
================================================================================*/

-- Step 1: Calculate overall sales across all stores
WITH total_sales AS (
    SELECT SUM(weekly_sales) AS overall_sales
    FROM gold.train_with_stores_and_features
)

-- Step 2: Aggregate store sales and compute contribution percentage
SELECT
    store_id,
    SUM(weekly_sales) AS store_sales,  -- Total sales per store
    ROUND(SUM(weekly_sales) * 100.0 / ts.overall_sales, 2) AS sales_percentage -- % contribution
FROM gold.train_with_stores_and_features t
CROSS JOIN total_sales ts   -- Attach overall sales to each row
GROUP BY store_id, ts.overall_sales
ORDER BY sales_percentage DESC;  -- Rank stores by contribution



