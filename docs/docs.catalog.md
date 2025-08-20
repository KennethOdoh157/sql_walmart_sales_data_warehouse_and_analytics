# 📚 **Data Dictionary for Gold Layer Views**

## 📊 **Gold Layer Overview**
The **Gold Layer** in this project contains **business-ready data**, designed for analytics, reporting, and decision-making.  
It consolidates sales, store metadata, and external features into enriched views that support advanced insights such as **holiday analysis, store segmentation, and external factor impact**.

---

## 🏪 **View: `gold.train_with_stores`**

This view combines **sales data** from `silver.train` with **store metadata** from `silver.stores`.  
It provides enriched sales records that include store attributes.

| **Column Name**        | **Data Type** | **Description**                                                                 |
|------------------------|---------------|---------------------------------------------------------------------------------|
| `store_id`             | INT           | Unique identifier for each Walmart store.                                       |
| `department`           | INT           | Department number within the store.                                             |
| `date`                 | DATE          | The sales record date in 'YYYY-MM-DD' format.                                   |
| `weekly_sales`         | FLOAT         | Weekly sales amount for the store-department combination.                       |
| `returns`              | FLOAT         | Weekly returned sales amount (negative values indicate returns).                |
| `train_is_holiday`     | BIT           | Holiday flag from the training dataset (1 = holiday week, 0 = non-holiday).     |
| `train_holiday_status` | NVARCHAR(50)  | Detailed holiday status (e.g., "Super Bowl", "Christmas").                      |
| `store_type`           | NVARCHAR(10)  | Store type classification (e.g., A, B, C).                                      |
| `store_size`           | INT           | Store size in square feet, representing capacity and scale.                     |

---

## 🏪🌦 **View: `gold.train_with_stores_and_features`**

This view extends `gold.train_with_stores` by joining with `silver.features`.  
It enriches sales and store metadata with **external economic indicators, weather, and promotions**.

| **Column Name**             | **Data Type** | **Description**                                                                 |
|-----------------------------|---------------|---------------------------------------------------------------------------------|
| `store_id`                  | INT           | Unique identifier for each Walmart store.                                       |
| `department`                | INT           | Department number within the store.                                             |
| `date`                      | DATE          | The sales record date in 'YYYY-MM-DD' format.                                   |
| `weekly_sales`              | FLOAT         | Weekly sales amount for the store-department combination.                       |
| `returns`                   | FLOAT         | Weekly returned sales amount (negative values indicate returns).                |
| `train_is_holiday`          | BIT           | Holiday flag from training dataset.                                             |
| `train_holiday_status`      | NVARCHAR(50)  | Detailed holiday status from training dataset.                                  |
| `store_type`                | NVARCHAR(10)  | Store type classification (e.g., A, B, C).                                      |
| `store_size`                | INT           | Store size in square feet.                                                      |
| `temperature`               | FLOAT         | Average temperature recorded for the store’s location.                          |
| `fuel_price`                | FLOAT         | Average fuel price during the given week.                                       |
| `mark_down1`                | FLOAT         | Promotional markdown applied (Category 1).                                      |
| `mark_down2`                | FLOAT         | Promotional markdown applied (Category 2).                                      |
| `mark_down3`                | FLOAT         | Promotional markdown applied (Category 3).                                      |
| `mark_down4`                | FLOAT         | Promotional markdown applied (Category 4).                                      |
| `mark_down5`                | FLOAT         | Promotional markdown applied (Category 5).                                      |
| `consumer_price_index`      | FLOAT         | CPI value, indicating inflation for that period.                                |
| `unemployment`              | FLOAT         | Unemployment rate relevant to the store’s region.                               |
| `features_is_holiday`       | BIT           | Holiday flag from features dataset.                                             |
| `features_holiday_status`   | NVARCHAR(50)  | Holiday status description from features dataset.                               |

---
