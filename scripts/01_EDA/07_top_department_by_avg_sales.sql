/*=====================================================================================
QUERY: Top 5 Departments by Average Weekly Sales
PURPOSE:
    - Identify which departments generate the highest average weekly sales.
    - Provide insights into product/service categories with the strongest performance.
    - Support business decisions on resource allocation, promotions, and inventory planning.
=====================================================================================*/

SELECT TOP 5 
    department, 
    AVG(weekly_sales) AS avg_sales   -- Average sales per department
FROM gold.train_with_stores_and_features
GROUP BY department
ORDER BY avg_sales DESC;             -- Rank departments by average weekly sales



