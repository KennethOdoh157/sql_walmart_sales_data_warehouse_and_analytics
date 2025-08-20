/*=====================================================================================
QUERY: Measures Exploration - Sales and Returns Summary
PURPOSE:
    - Generate key summary statistics for sales and returns.
    - Provide insights into sales distribution, scale, and return behavior.
    - Acts as an initial data profiling step for business analysis and validation.
=====================================================================================*/

SELECT 
    MIN(weekly_sales) AS min_sales,     -- Lowest weekly sales observed
    MAX(weekly_sales) AS max_sales,     -- Highest weekly sales observed
    AVG(weekly_sales) AS avg_sales,     -- Average weekly sales across all records
    SUM(weekly_sales) AS total_sales,   -- Total sales across the dataset
    AVG(returns) AS avg_returns         -- Average returns across all records
FROM gold.train_with_stores_and_features;



