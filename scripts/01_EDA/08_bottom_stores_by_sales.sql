/*=====================================================================================
QUERY: Bottom 5 Stores by Total Sales
PURPOSE:
    - Identify the lowest-performing stores based on total sales.
    - Highlight underperforming locations that may require business review.
    - Useful for performance benchmarking and strategic planning.
=====================================================================================*/

SELECT TOP 5 
    store_id, 
    SUM(weekly_sales) AS total_sales   -- Aggregate sales per store
FROM gold.train_with_stores_and_features
GROUP BY store_id
ORDER BY total_sales ASC;             -- Rank stores by total sales, lowest first



