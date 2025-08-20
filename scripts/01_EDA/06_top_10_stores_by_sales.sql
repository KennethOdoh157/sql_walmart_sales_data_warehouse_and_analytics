/*=====================================================================================
QUERY: Top 10 Stores by Total Sales
PURPOSE:
    - Identify the highest-performing stores based on total sales.
    - Provide insights into which store locations contribute the most revenue.
    - Useful for ranking stores and highlighting top performers for business strategy.
=====================================================================================*/

SELECT TOP 10 
    store_id, 
    SUM(weekly_sales) AS total_sales   -- Aggregate sales per store
FROM gold.train_with_stores_and_features
GROUP BY store_id
ORDER BY total_sales DESC;            -- Rank stores by total sales, highest first


