/*=====================================================================================
QUERY: Table Row Counts for Main Gold Layer Tables
PURPOSE:
    - Provides quick database-level exploration by counting rows in key tables.
    - Useful for validating data loads, ensuring completeness, and verifying 
      that the expected number of records exist in each table.
=====================================================================================*/

-- Row count for the training dataset joined with store information
SELECT 
    'train_with_stores' AS table_name, 
    COUNT(*) AS row_count
FROM gold.train_with_stores;

-- Row count for the training dataset joined with both store and feature information
SELECT 
    'train_with_stores_and_features' AS table_name, 
    COUNT(*) AS row_count
FROM gold.train_with_stores_and_features;


