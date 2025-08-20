# Walmart Data Warehouse & Analytics Project

## Table of Contents
- [Project Overview](#project-overview)
- [Dataset Information](#dataset-information)
- [Data Warehouse Architecture](#data-warehouse-architecture)
- [SQL Queries & Analytics Tasks](#sql-queries--analytics-tasks)
- [Key Insights / Business Value](#key-insights--business-value)
- [How to Reproduce / Run the Project](#how-to-reproduce--run-the-project)
- [Conclusion / Next Steps](#conclusion--next-steps)

---

## Project Overview
This project demonstrates a comprehensive SQL Server-based data warehouse and analytics workflow for Walmart store sales. It showcases the end-to-end pipeline, from raw data ingestion to clean, standardized silver tables and enriched gold-layer analytics views.

The goal is twofold:

**Technical Excellence:** Highlight the design and implementation of a robust data warehouse, including schema design, medallion architecture, ETL workflows, and advanced SQL techniques such as CTEs, window functions, and aggregations.

**Business Value:** Provide actionable insights into sales trends, store performance, department-level contributions, and the impact of promotions, holidays, and economic indicators on consumer behavior.

This repository is intended as a **portfolio-ready showcase** for employers and developers.

---

## Dataset Information
**Source:** CSV files containing historical Walmart store sales, store information, and external contextual data (weather, fuel prices, CPI, etc.)

**Tables:**
- **Stores:** Store-level metadata including type and size.
- **Features:** Contextual data for each store-date combination.
- **Train:** Historical weekly sales and returns.
- **Test:** Future week combinations for predictions.
- **Sample Submission:** Template for sales forecasts.

**Time Period:** Historical coverage spanning multiple years, enabling trend and seasonality analysis.

---

## Data Warehouse Architecture
The project follows the **Bronze → Silver → Gold (BSG) Medallion Architecture**:

### 🔹 Sources
- CSV files ingested directly into SQL Server.

### 🔹 Bronze Layer (Raw Data)
- **Object Type:** Tables  
- **Load Method:** SSMS import of flat files  
- **Transformations:** None  
- **Purpose:** Store raw, unprocessed data exactly as received  

### 🔹 Silver Layer (Cleaned, Standardized Data)
- **Object Type:** Tables  
- **Load Method:** Batch processing with truncate & insert  
- **Transformations:** Data cleaning, normalization, derived columns, enrichment  
- **Purpose:** Standardized, reliable version of raw data  

### 🔹 Gold Layer (Business-Related Data)
- **Object Type:** Views and aggregated tables  
- **Load Method:** Populated from Silver tables  
- **Transformations:** Integrations, aggregations, business logic  
- **Purpose:** Analytics-ready, business-friendly data  

### 🔹 Consumption Layer
- **Used by:**
  - BI dashboards
  - Ad-hoc SQL queries
  - Machine learning models

**Visual Placeholder:** Add ER diagrams, flowcharts, or pipeline screenshots here.

---

## SQL Queries & Analytics Tasks
All queries are executed on the **gold layer** (enriched and business-ready data).

### Data Validation & Exploration
- **Table Row Counts:** Validate data load completeness.  
- **Null Value Checks:** Ensure critical fields like `store_id`, `department`, `weekly_sales`, and `returns` have no missing values.  
- **Dimension Exploration:** Explore stores by type and department coverage.  
- **Date Coverage:** Confirm historical range for analysis.  

### Sales Performance Analytics
- **Measures Exploration:** Analyze min, max, average weekly sales and returns.  
- **Top/Bottom Stores & Departments:** Identify top 10 stores, bottom 5 stores, and top 5 departments by sales.  
- **Weekly Sales Trend by Store Type:** Examine seasonality and performance over time.  
- **Holiday Impact Analysis:** Compare sales between holiday and non-holiday weeks.  
- **Promotion Analysis:** Evaluate markdown impact on weekly sales.  
- **Store Segmentation:** Classify stores into High, Medium, Low performers.  

### External Factors Impact
- **Fuel Price Analysis:** Compare sales across low, medium, and high fuel price categories.  
- **CPI Analysis:** Compare sales across different inflation ranges.  

### Advanced Analytics
- **Running Total Sales:** Track cumulative sales per store over time.  
- **Week-over-Week Analysis:** Identify growth or decline trends per store.  
- **Store & Department Contribution:** Calculate each store and department’s share of total company sales.  
- **Holiday vs Non-Holiday Performance:** Compare store-type performance for holiday and non-holiday weeks.  

**Visual Placeholder:** Include tables, charts, or dashboards showing trends and segmentation.

---

## Key Insights / Business Value
- **Sales Patterns:** Seasonality observed across store types; holidays often boost sales.  
- **Promotional Impact:** Markdown promotions can drive short-term sales spikes.  
- **Store Segmentation:** High-performing stores contribute disproportionately to overall revenue, guiding targeted marketing and inventory planning.  
- **Department Contributions:** Top departments generate most consistent revenue, helping prioritize stocking and promotions.  
- **External Factors:** Fuel prices and CPI levels correlate with consumer spending patterns, providing context for strategic planning.

---

## How to Reproduce / Run the Project
1. Setup SQL Server and create a database for Walmart analytics.  
2. Ingest CSV files into bronze layer tables using SSMS or an ETL tool.  
3. Execute silver layer scripts to clean, standardize, and enrich data.  
4. Populate gold layer views using the provided transformation scripts.  
5. Run analytics queries to reproduce tables, trends, and insights as documented.  
6. Visualize outputs in your preferred BI tool or Excel.  

> **Note:** All scripts include logging, error handling, and batch timing for reproducibility and monitoring.

---

## Conclusion / Next Steps
- Extend analytics to predictive modeling for future sales forecasting.  
- Integrate additional external features such as local events or competitor activity.  
- Build interactive dashboards for real-time monitoring of store performance.  
- Maintain modular ETL pipelines for ongoing data updates and scalability.
