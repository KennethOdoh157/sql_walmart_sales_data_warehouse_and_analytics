/*=====================================================================================
QUERY: Holiday Impact Analysis on Weekly Sales
PURPOSE:
    - Compare sales performance between holiday and non-holiday periods.
    - Measure the effect of holidays on consumer spending behavior.
    - Provide insights into whether holidays drive higher or lower sales volumes.
=====================================================================================*/

SELECT 
    train_is_holiday,                      -- Holiday flag (1 = holiday, 0 = non-holiday)
    AVG(weekly_sales) AS avg_sales,        -- Average weekly sales for each category
    SUM(weekly_sales) AS total_sales       -- Total weekly sales for each category
FROM gold.train_with_stores
GROUP BY train_is_holiday;                 -- Separate results by holiday vs non-holiday

