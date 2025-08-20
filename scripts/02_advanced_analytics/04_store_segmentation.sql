/*=====================================================================================
QUERY: Store Segmentation by Total Sales
PURPOSE:
    - Classify stores into performance segments based on total sales.
    - Enable business users to identify high-, medium-, and low-performing stores.
    - Support decision-making for resource allocation, promotions, and operational focus.
=====================================================================================*/

-- Step 1: Aggregate total sales per store
WITH store_sales AS (
    SELECT 
        store_id, 
        SUM(weekly_sales) AS total_sales   -- Total sales per store
    FROM gold.train_with_stores_and_features
    GROUP BY store_id
)

-- Step 2: Apply segmentation logic based on sales thresholds
SELECT 
    store_id,
    total_sales,
    CASE
        WHEN total_sales >= 100000 THEN 'High'     -- Stores with very strong sales
        WHEN total_sales >= 50000  THEN 'Medium'   -- Stores with moderate sales
        ELSE 'Low'                                 -- Stores with lower sales performance
    END AS performance_segment
FROM store_sales;


