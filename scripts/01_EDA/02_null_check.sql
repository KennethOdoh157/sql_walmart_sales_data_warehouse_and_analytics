
/*=====================================================================================
QUERY: Null Value Check for Key Columns
PURPOSE:
    - Validates data quality by checking for NULL values in important columns.
    - Ensures completeness of the dataset before using it for reporting or analytics.
    - Useful as part of a data quality audit on the gold layer.
=====================================================================================*/

SELECT 
    COUNT(*) AS total_rows,             -- Total number of records in the table
    COUNT(store_id) AS store_id_count,  -- Number of non-NULL store IDs
    COUNT(department) AS department_count,  -- Number of non-NULL department values
    COUNT(weekly_sales) AS weekly_sales_count,  -- Number of non-NULL sales entries
    COUNT(returns) AS returns_count     -- Number of non-NULL return entries
FROM gold.train_with_stores_and_features;
