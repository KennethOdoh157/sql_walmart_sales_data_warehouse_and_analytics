/*===============================================================================
REPORT: Walmart Weekly Sales & Analytics (Gold Layer)
PURPOSE:
    This query creates a reporting view (`gold.report_weekly_sales_and_analytics`) that 
    aggregates, enriches, and classifies weekly sales data by store. It provides 
    a foundation for dashboards and advanced retail analytics.

DATA SOURCE:
    - gold.train_with_stores_and_features

TIME GRAIN:
    - Weekly (uses `date` as week indicator)

BUSINESS HIGHLIGHTS / METRICS:
    - Aggregates: SUM(weekly_sales), SUM(returns), AVG(weekly_sales), COUNT(DISTINCT department)
    - Top / bottom N stores & departments
    - Percentile-based performance tiers (VIP, Regular, Low)
    - Contribution % per store & store_type
    - Growth vs prior week
    - Recency: weeks since last non-zero sale
    - Holiday impact analysis
    - Segmentation: store_type, store_size_category, performance tier

ASSUMPTIONS / LIMITATIONS:
    - Store size categories: Small <50k, Medium 50k-100k, Large >100k
    - Performance tiers: VIP >= 80th percentile of avg weekly sales, Low <=20th percentile
    - Weekly "WoW" growth computed via 1-week lag
    - Approx. monthly spend/sales = avg_weekly_sales * 4.3
===============================================================================*/

IF OBJECT_ID('gold.report_weekly_sales_and_analytics', 'V') IS NOT NULL
    DROP VIEW gold.report_weekly_sales_and_analytics;
GO

CREATE VIEW gold.report_weekly_sales_and_analytics AS

/* ------------------------------------------------------------------------
   1. Base data selection
   ------------------------------------------------------------------------ */
WITH base_data AS (
    SELECT
         store_id,
         department,
         CAST([date] AS date) AS week_date,
         weekly_sales,
         returns,
         train_is_holiday,
         store_type,
         store_size,
         temperature,
         fuel_price,
         mark_down1,
         mark_down2,
         mark_down3,
         mark_down4,
         mark_down5,
         consumer_price_index,
         unemployment
         features_is_holiday
    FROM gold.train_with_stores_and_features
),

/* ------------------------------------------------------------------------
   2. Store-Week Aggregation
   - Summarize weekly metrics by store.
   ------------------------------------------------------------------------ */
store_week_agg AS (
    SELECT
         store_id,
         store_type,
         store_size,
         week_date,
         SUM(weekly_sales) AS sum_weekly_sales,
         SUM(returns) AS sum_returns,
         AVG(weekly_sales) AS avg_weekly_sales,
         COUNT(DISTINCT department) AS distinct_departments,
         CASE WHEN SUM(CAST(train_is_holiday AS TINYINT)) > 0 THEN 1 ELSE 0 END AS any_train_holiday,
         CASE WHEN SUM(CAST(features_is_holiday AS TINYINT)) > 0 THEN 1 ELSE 0 END AS any_features_holiday
    FROM base_data
    GROUP BY store_id, store_type, store_size, week_date
),

/* ------------------------------------------------------------------------
   3. Store-Type Week Aggregation
   ------------------------------------------------------------------------ */
store_type_week_agg AS (
    SELECT
         store_type,
         week_date,
         SUM(sum_weekly_sales) AS store_type_week_sales
    FROM store_week_agg
    GROUP BY store_type, week_date
),

/* ------------------------------------------------------------------------
   4. Total Week Aggregation
   ------------------------------------------------------------------------ */
total_week_agg AS (
    SELECT
         week_date,
         SUM(sum_weekly_sales) AS total_week_sales
    FROM store_week_agg
    GROUP BY week_date
),

/* ------------------------------------------------------------------------
   5. Long-Run Store Stats
   - Average weekly sales and weeks active for each store.
   ------------------------------------------------------------------------ */
store_longrun AS (
    SELECT
         store_id,
         AVG(sum_weekly_sales * 1.0) AS avg_weekly_sales_store_all,
         COUNT(*) AS weeks_active
    FROM store_week_agg
    GROUP BY store_id
),

/* ------------------------------------------------------------------------
   6. Percentiles
   - Define thresholds for performance tiers (VIP, Regular, Low).
   ------------------------------------------------------------------------ */
store_percentiles AS (
    SELECT DISTINCT
          PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY avg_weekly_sales_store_all) OVER () AS p80,
          PERCENTILE_CONT(0.2) WITHIN GROUP (ORDER BY avg_weekly_sales_store_all) OVER () AS p20
    FROM store_longrun
),

/* ------------------------------------------------------------------------
   7. Running Totals & Growth Metrics
   - Adds running sales by store and store type, plus prior week comparison.
   ------------------------------------------------------------------------ */
store_week_enriched AS (
    SELECT
         swa.*,
         SUM(swa.sum_weekly_sales) OVER (
              PARTITION BY swa.store_id ORDER BY swa.week_date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
          ) AS running_sales_by_store,
         SUM(swa.sum_weekly_sales) OVER (
              PARTITION BY swa.store_type ORDER BY swa.week_date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
          ) AS running_sales_by_store_type,
         LAG(swa.sum_weekly_sales,1) OVER (
              PARTITION BY swa.store_id ORDER BY swa.week_date
          ) AS prev_week_sales_store
    FROM store_week_agg AS swa
),

/* ------------------------------------------------------------------------
   8. Recency Calculation
   - Tracks weeks since last non-zero sales event.
   ------------------------------------------------------------------------ */
recency_calc AS (
    SELECT
         swe.store_id,
         swe.week_date,
         MAX(CASE WHEN swe.sum_weekly_sales > 0 THEN swe.week_date END)
              OVER (PARTITION BY swe.store_id ORDER BY swe.week_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS last_non_zero_date
    FROM store_week_enriched AS swe
),

/* ------------------------------------------------------------------------
   9. Final Assembly
   - Combine aggregations, classifications, and performance metrics.
   ------------------------------------------------------------------------ */
final_calc AS (
    SELECT
         swe.store_id,
         swe.store_type,
         swe.store_size,
         swe.week_date,
         swe.sum_weekly_sales,
         swe.sum_returns,
         swe.avg_weekly_sales,
         swe.distinct_departments,
         swe.running_sales_by_store,
         swe.running_sales_by_store_type,
         CAST(swe.sum_weekly_sales AS decimal(18,4)) / NULLIF(twa.total_week_sales,0) AS store_contribution_pct,
         CAST(stwa.store_type_week_sales AS decimal(18,4)) / NULLIF(twa.total_week_sales,0) AS store_type_contribution_pct,
         swe.prev_week_sales_store,
         (CAST(swe.sum_weekly_sales AS decimal(18,4)) - CAST(swe.prev_week_sales_store AS decimal(18,4))) AS diff_vs_prior_week,
         CASE
            WHEN swe.prev_week_sales_store IS NULL THEN NULL
            WHEN swe.sum_weekly_sales > swe.prev_week_sales_store THEN 'increase'
            WHEN swe.sum_weekly_sales < swe.prev_week_sales_store THEN 'decrease'
            ELSE 'no_change'
          END AS change_vs_prior_week,
          CASE
            WHEN swe.sum_weekly_sales >= sl.avg_weekly_sales_store_all THEN 'above_average'
            ELSE 'below_average'
          END AS avg_position_flag,
          CASE
            WHEN rc.last_non_zero_date IS NULL THEN NULL
            ELSE DATEDIFF(WEEK, rc.last_non_zero_date, swe.week_date)
          END AS weeks_since_last_non_zero_sale,
          CASE
            WHEN swe.store_size < 50000 THEN 'small'
            WHEN swe.store_size BETWEEN 50000 AND 100000 THEN 'medium'
            ELSE 'large'
          END AS store_size_category,
          CASE
            WHEN sl.avg_weekly_sales_store_all >= sp.p80 THEN 'VIP'
            WHEN sl.avg_weekly_sales_store_all <= sp.p20 THEN 'Low'
            ELSE 'Regular'
          END AS performance_tier,
          swe.any_train_holiday AS has_train_holiday,
          swe.any_features_holiday AS has_features_holiday
    FROM store_week_enriched AS swe
    INNER JOIN total_week_agg       AS twa
        ON twa.week_date = swe.week_date
    INNER JOIN store_type_week_agg  AS stwa
        ON stwa.store_type = swe.store_type
       AND stwa.week_date = swe.week_date
    INNER JOIN store_longrun        AS sl
        ON sl.store_id = swe.store_id
    CROSS JOIN store_percentiles    AS sp
    LEFT JOIN recency_calc          AS rc
        ON rc.store_id = swe.store_id
       AND rc.week_date = swe.week_date
)

/* ------------------------------------------------------------------------
   10. Final SELECT
   ------------------------------------------------------------------------ */
SELECT *
FROM final_calc;
GO

-- Quick test of the view
SELECT *
FROM gold.report_weekly_sales_and_analytics
ORDER BY store_id, week_date;

