/*================================================================================
QUERY: Department Proportion of Sales

PURPOSE:
This query calculates the contribution of each department to the overall company sales.
It shows both the absolute sales value per department and its percentage share of
the total sales across all stores and departments.

USE CASE:
Helps business managers and analysts identify revenue-driving departments,
prioritize resource allocation, and understand department-level impact on overall sales.
================================================================================*/

-- Step 1: Calculate total sales across all departments
WITH total_sales AS (
    SELECT SUM(weekly_sales) AS overall_sales
    FROM gold.train_with_stores_and_features
)

-- Step 2: Aggregate sales per department and compute percentage share
SELECT
    department,
    SUM(weekly_sales) AS dept_sales,  -- Total sales per department
    ROUND(SUM(weekly_sales) * 100.0 / ts.overall_sales, 2) AS dept_percentage -- % contribution
FROM gold.train_with_stores_and_features t
CROSS JOIN total_sales ts   -- Attach company-wide total sales to each row
GROUP BY department, ts.overall_sales
ORDER BY dept_percentage DESC;  -- Rank departments by contribution


