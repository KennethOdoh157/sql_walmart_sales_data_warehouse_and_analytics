/*
================================================================================
Purpose:
Stored procedure `silver.load_silver` populates all silver layer tables 
from the corresponding bronze layer tables. It performs data cleaning, type 
casting, and feature derivation to ensure the silver tables are analytics-ready.
================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        -------------------------------------------------------------
        -- Load silver.stores Table
        -------------------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.stores;  -- Clear existing data
        INSERT INTO silver.stores(store_id, store_type, store_size)
        SELECT
            TRY_CAST(Store AS INT) AS store_id,
            TRY_CAST(Type AS CHAR(1)) AS store_type,
            Size AS store_size
        FROM bronze.stores
        WHERE TRY_CAST(Store AS INT) IS NOT NULL
            AND TRY_CAST(Type AS CHAR(1)) IN ('A', 'B', 'C');
        SET @end_time = GETDATE();
        PRINT 'silver.stores load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------
        -- Load silver.features Table
        -------------------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.features;
        WITH cleaned_features AS (
            SELECT 
                TRY_CAST(Store AS INT) AS store_id,
                Date AS date,
                ROUND(Temperature,1) AS temperature,
                ROUND(Fuel_Price,3) AS fuel_price,
                -- Clean markdowns: convert invalid/negative/NA values to 0
                CASE WHEN MarkDown1 IS NULL OR LTRIM(RTRIM(MarkDown1)) IN ('NA','N/A','') OR TRY_CAST(MarkDown1 AS FLOAT)<=0
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(MarkDown1)) AS FLOAT),2) END AS mark_down1,
                CASE WHEN MarkDown2 IS NULL OR LTRIM(RTRIM(MarkDown2)) IN ('NA','N/A','') OR TRY_CAST(MarkDown2 AS FLOAT)<=0
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(MarkDown2)) AS FLOAT),2) END AS mark_down2,
                CASE WHEN MarkDown3 IS NULL OR LTRIM(RTRIM(MarkDown3)) IN ('NA','N/A','') OR TRY_CAST(MarkDown3 AS FLOAT)<=0
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(MarkDown3)) AS FLOAT),2) END AS mark_down3,
                CASE WHEN MarkDown4 IS NULL OR LTRIM(RTRIM(MarkDown4)) IN ('NA','N/A','') OR TRY_CAST(MarkDown4 AS FLOAT)<=0
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(MarkDown4)) AS FLOAT),2) END AS mark_down4,
                CASE WHEN MarkDown5 IS NULL OR LTRIM(RTRIM(MarkDown5)) IN ('NA','N/A','') OR TRY_CAST(MarkDown5 AS FLOAT)<=0
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(MarkDown5)) AS FLOAT),2) END AS mark_down5,
                -- Clean economic indicators
                CASE WHEN CPI IS NULL OR LTRIM(RTRIM(CPI)) IN ('NA','N/A','') OR TRY_CAST(CPI AS FLOAT)<1
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(CPI)) AS FLOAT),3) END AS consumer_price_index,
                CASE WHEN Unemployment IS NULL OR LTRIM(RTRIM(Unemployment)) IN ('NA','N/A','') OR TRY_CAST(Unemployment AS FLOAT)<1
                     THEN 0 ELSE ROUND(TRY_CAST(LTRIM(RTRIM(Unemployment)) AS FLOAT),2) END AS unemployment,
                IsHoliday AS is_holiday,
                CASE WHEN IsHoliday = 1 THEN 'holiday_week' ELSE 'non_holiday_week' END AS holiday_status
            FROM bronze.features
        )
        INSERT INTO silver.features(store_id,date,temperature,fuel_price,mark_down1,mark_down2,mark_down3,mark_down4,mark_down5,consumer_price_index,unemployment,is_holiday,holiday_status)
        SELECT f.* 
        FROM cleaned_features f
        INNER JOIN silver.stores s ON f.store_id = s.store_id;
        SET @end_time = GETDATE();
        PRINT 'silver.features load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------
        -- Load silver.train Table
        -------------------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.train;
        WITH cleaned_train AS (
            SELECT
                TRY_CAST(Store AS INT) AS store_id,
                TRY_CAST(Dept AS INT) AS department,
                Date AS date,
                ROUND(Weekly_Sales,2) AS weekly_sales,
                CASE WHEN Weekly_Sales<0 THEN ABS(Weekly_Sales) ELSE 0 END AS returns,
                IsHoliday AS is_holiday,
                CASE WHEN IsHoliday=1 THEN 'holiday_week' ELSE 'non_holiday_week' END AS holiday_status
            FROM bronze.train
        )
        INSERT INTO silver.train(store_id,department,date,weekly_sales,returns,is_holiday,holiday_status)
        SELECT t.*
        FROM cleaned_train t
        INNER JOIN silver.stores s ON t.store_id = s.store_id;
        SET @end_time = GETDATE();
        PRINT 'silver.train load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------
        -- Load silver.test Table
        -------------------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.test;
        WITH cleaned_test AS (
            SELECT
                TRY_CAST(Store AS INT) AS store_id,
                TRY_CAST(Dept AS INT) AS department,
                Date AS date,
                IsHoliday AS is_holiday,
                CASE WHEN IsHoliday=1 THEN 'holiday_week' ELSE 'non_holiday_week' END AS holiday_status
            FROM bronze.test
        )
        INSERT INTO silver.test(store_id,department,date,is_holiday,holiday_status)
        SELECT t.*
        FROM cleaned_test t
        INNER JOIN silver.stores s ON t.store_id = s.store_id;
        SET @end_time = GETDATE();
        PRINT 'silver.test load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------
        -- Load silver.sample_submission Table
        -------------------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.sample_submission;
        WITH cleaned_submission AS (
            SELECT
                TRY_CAST(LEFT(id, CHARINDEX('_', id)-1) AS INT) AS store_id,
                TRY_CAST(SUBSTRING(id, CHARINDEX('_', id)+1, CHARINDEX('_', id, CHARINDEX('_', id)+1)-CHARINDEX('_', id)-1) AS INT) AS department,
                TRY_CAST(SUBSTRING(id, CHARINDEX('_', id, CHARINDEX('_', id)+1)+1, LEN(id)) AS DATE) AS date,
                CAST(Weekly_Sales AS FLOAT) AS weekly_sales
            FROM bronze.sample_submission
        )
        INSERT INTO silver.sample_submission(store_id,department,date,weekly_sales)
        SELECT c.store_id, c.department, c.date, c.weekly_sales
        FROM cleaned_submission c
        INNER JOIN silver.stores s ON c.store_id = s.store_id;
        SET @end_time = GETDATE();
        PRINT 'silver.sample_submission load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -------------------------------------------------------------
        -- Batch completion
        -------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '============================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT 'Total Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '============================================';

    END TRY
    BEGIN CATCH
        -- Error handling: display detailed error information
        PRINT '===== ERROR =====';
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR);
        PRINT 'State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT 'Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
        PRINT '=================';
    END CATCH
END

