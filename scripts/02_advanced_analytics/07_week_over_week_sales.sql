  /*=================================================================================
QUERY 15: Week-over-Week Sales Analysis (Per Store)
-----------------------------------------------------------------------------------
Purpose:
- Analyze store performance by comparing each week’s sales against:
  1. The previous week’s sales (week-over-week trend).
  2. The running average sales (above/below average performance).
  
Key Outputs:
- pw_sales       → Previous week’s sales per store.
- diff_pw        → Difference vs. previous week.
- weekly_trend   → Increase, Decrease, or No Change vs. previous week.
- avg_weekly_sales → Running average sales per store.
- diff_avg       → Difference vs. running average.
- avg_performance → Above Avg, Below Avg, or Avg classification.

Dataset: gold.train_with_stores_and_features
=================================================================================*/

SELECT
    store_id,
    date,
    weekly_sales,

    -- Previous week's sales
    LAG(weekly_sales, 1) OVER (
        PARTITION BY store_id 
        ORDER BY date
    ) AS pw_sales,

    -- Difference compared to previous week
    weekly_sales - LAG(weekly_sales, 1) OVER (
        PARTITION BY store_id 
        ORDER BY date
    ) AS diff_pw,

    -- Week-over-week sales trend classification
    CASE 
        WHEN weekly_sales - LAG(weekly_sales, 1) OVER (PARTITION BY store_id ORDER BY date) > 0 THEN 'Increase'
        WHEN weekly_sales - LAG(weekly_sales, 1) OVER (PARTITION BY store_id ORDER BY date) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS weekly_trend,

    -- Running average sales per store
    AVG(weekly_sales) OVER (
        PARTITION BY store_id 
        ORDER BY date
    ) AS avg_weekly_sales,

    -- Difference vs. running average
    weekly_sales - AVG(weekly_sales) OVER (
        PARTITION BY store_id 
        ORDER BY date 
    ) AS diff_avg,

    -- Classification vs. running average
    CASE 
        WHEN weekly_sales - AVG(weekly_sales) OVER (PARTITION BY store_id ORDER BY date) > 0 THEN 'Above Avg'
        WHEN weekly_sales - AVG(weekly_sales) OVER (PARTITION BY store_id ORDER BY date) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_performance

FROM gold.train_with_stores_and_features
ORDER BY store_id, date;


