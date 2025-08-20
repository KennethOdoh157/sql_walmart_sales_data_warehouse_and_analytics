/*=====================================================================================
QUERY: Date Coverage of Training Data
PURPOSE:
    - Identify the overall time span of the dataset.
    - Useful for validating completeness of historical data and understanding 
      the range of available records.
=====================================================================================*/

-- Get the earliest and latest dates in the dataset
SELECT 
    MIN(date) AS start_date,   -- Earliest available record
    MAX(date) AS end_date      -- Latest available record
FROM gold.train_with_stores;



