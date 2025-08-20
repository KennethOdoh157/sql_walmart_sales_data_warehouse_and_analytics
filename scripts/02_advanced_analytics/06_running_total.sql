/*===================================================================================
QUERY 14: Running Total of Weekly Sales by Store
------------------------------------------------------------------------------------
Business Purpose:
This query calculates the cumulative (running) total of weekly sales for each store 
over time. It helps track sales growth patterns and performance trends at the store 
level, showing how sales accumulate week by week.

Technical Notes:
- The SUM() window function is used with PARTITION BY to calculate totals per store.
- ORDER BY date ensures the running total is built chronologically.
- "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW" explicitly defines the frame, 
  starting from the first record up to the current row.

Use Cases:
- Monitoring long-term store performance.
- Identifying seasonal sales accumulation.
- Comparing stores based on cumulative revenue.
===================================================================================*/

SELECT
    store_id,                -- Unique identifier for each store
    date,                    -- Transaction week
    weekly_sales,            -- Weekly sales amount
    SUM(weekly_sales) OVER (
        PARTITION BY store_id
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_store -- Cumulative sales from start to current week per store
FROM gold.train_with_stores_and_features
ORDER BY store_id, date;


