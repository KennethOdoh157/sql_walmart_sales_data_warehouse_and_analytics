/*================================================================================
QUERY: Average Sales by CPI (Consumer Price Index) Category

PURPOSE:
This query evaluates how average weekly sales vary across different Consumer Price
Index (CPI) ranges. CPI is a measure of inflation, and this analysis helps identify
whether consumer spending patterns change with inflation levels.

USE CASE:
Provides insight into the relationship between inflation (CPI) and retail sales,
supporting economic forecasting and pricing strategy decisions.
================================================================================*/

SELECT 
    -- Categorize CPI values into Low, Medium, and High brackets
    CASE 
        WHEN consumer_price_index < 220 THEN 'Low CPI'
        WHEN consumer_price_index BETWEEN 220 AND 240 THEN 'Medium CPI'
        ELSE 'High CPI'
    END AS cpi_category,

    AVG(weekly_sales) AS avg_sales   -- Average weekly sales for each CPI category
FROM gold.train_with_stores_and_features

-- Group results by CPI category
GROUP BY CASE 
             WHEN consumer_price_index < 220 THEN 'Low CPI'
             WHEN consumer_price_index BETWEEN 220 AND 240 THEN 'Medium CPI'
             ELSE 'High CPI'
         END

-- Order by category for readability
ORDER BY cpi_category;


