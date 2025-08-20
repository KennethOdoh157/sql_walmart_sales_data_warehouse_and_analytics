/*=====================================================================================
QUERY: Promotion & Feature Impact - Markdown Effect on Sales
PURPOSE:
    - Assess the impact of markdown promotions on weekly sales.
    - Compare sales performance between weeks with markdowns applied vs. weeks without.
    - Provide insights into promotion effectiveness for business strategy.
=====================================================================================*/

SELECT 
    CASE 
        WHEN mark_down1 > 0 THEN 'Markdown'      -- Weeks with active markdown promotions
        ELSE 'No Markdown'                       -- Weeks without markdowns
    END AS markdown_flag,
    AVG(weekly_sales) AS avg_sales               -- Average sales for each category
FROM gold.train_with_stores_and_features
GROUP BY 
    CASE 
        WHEN mark_down1 > 0 THEN 'Markdown' 
        ELSE 'No Markdown' 
    END;


