/*================================================================================
QUERY: Average Sales by Fuel Price Category

PURPOSE:
This query analyzes how average weekly sales vary under different fuel price conditions.
It classifies fuel prices into three categories (Low, Medium, High) and computes the
corresponding average sales for each category.

USE CASE:
Helps business stakeholders understand the relationship between fuel prices and
consumer spending, supporting pricing strategies and demand forecasting.
================================================================================*/

SELECT 
    -- Categorize fuel prices into Low, Medium, and High brackets
    CASE 
        WHEN fuel_price < 3 THEN 'Low Fuel'
        WHEN fuel_price BETWEEN 3 AND 4 THEN 'Medium Fuel'
        ELSE 'High Fuel'
    END AS fuel_category,

    AVG(weekly_sales) AS avg_sales  -- Average weekly sales for the fuel category
FROM gold.train_with_stores_and_features

-- Group results by fuel category
GROUP BY CASE 
             WHEN fuel_price < 3 THEN 'Low Fuel'
             WHEN fuel_price BETWEEN 3 AND 4 THEN 'Medium Fuel'
             ELSE 'High Fuel'
         END

-- Sort categories in logical order
ORDER BY fuel_category;

