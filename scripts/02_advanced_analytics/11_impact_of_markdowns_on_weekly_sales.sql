/*================================================================================
QUERY: Impact of Markdowns on Weekly Sales

PURPOSE:
This query evaluates how markdowns (discount promotions) influence sales performance.
It compares weekly sales when markdowns are applied versus when they are not.

USE CASE:
Supports marketing and sales teams in measuring the effectiveness of markdown campaigns,
helping determine if discount strategies drive higher revenue.
================================================================================*/

SELECT 
    -- Flag rows as Markdown (if mark_down1 > 0) or No Markdown
    CASE 
        WHEN mark_down1 > 0 THEN 'Markdown' 
        ELSE 'No Markdown' 
    END AS markdown_flag,

    AVG(weekly_sales) AS avg_sales,   -- Average weekly sales for the group
    SUM(weekly_sales) AS total_sales  -- Total weekly sales for the group
FROM gold.train_with_stores_and_features
GROUP BY CASE 
             WHEN mark_down1 > 0 THEN 'Markdown' 
             ELSE 'No Markdown' 
         END;


