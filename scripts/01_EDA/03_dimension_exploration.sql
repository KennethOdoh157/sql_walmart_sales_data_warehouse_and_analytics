
/*=====================================================================================
QUERY: Dimension Exploration of Stores and Departments
PURPOSE:
    - Explore the structure of the dataset by analyzing distinct stores and departments.
    - Identify how many unique stores exist per store type.
    - Identify how many stores carry each department.
    - Supports dimensional understanding of the dataset for reporting and analysis.
=====================================================================================*/

-- Count unique stores grouped by store type
SELECT 
    store_type, 
    COUNT(DISTINCT store_id) AS num_stores
FROM gold.train_with_stores
GROUP BY store_type;

-- Count how many unique stores carry each department
SELECT 
    department, 
    COUNT(DISTINCT store_id) AS stores_per_dept
FROM gold.train_with_stores
GROUP BY department;


