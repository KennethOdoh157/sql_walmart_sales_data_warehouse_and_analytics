/*=====================================================================================
QUERY: Correlation-Like Analysis - Sales vs. Fuel Price
PURPOSE:
    - Explore how fuel prices may be associated with weekly sales performance.
    - Categorize fuel price ranges into Low, Medium, and High groups.
    - Provide a simplified correlation-style view between external economic factors 
      and store sales.
=====================================================================================*/

SELECT 
    CASE 
        WHEN fuel_price < 3 THEN 'Low Fuel'          -- Fuel price below $3
        WHEN fuel_price BETWEEN 3 AND 4 THEN 'Medium Fuel'  -- Fuel price between $3 and $4
        ELSE 'High Fuel'                             -- Fuel price above $4
    END AS fuel_category,
    AVG(weekly_sales) AS avg_sales                   -- Average weekly sales per fuel category
FROM gold.train_with_stores_and_features
GROUP BY 
    CASE 
        WHEN fuel_price < 3 THEN 'Low Fuel'
        WHEN fuel_price BETWEEN 3 AND 4 THEN 'Medium Fuel'
        ELSE 'High Fuel'
    END;


