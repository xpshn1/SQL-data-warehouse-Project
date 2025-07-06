# Comprehensive Sales Data Warehouse & Analytics Project

## 1. Project Overview

This project implements a robust data warehousing solution for sales analytics, consolidating data from disparate CRM and ERP systems. It follows the Medallion Architecture (Bronze, Silver, Gold layers) to systematically process raw data into a query-optimized Star Schema, enabling efficient business intelligence and reporting. The entire pipeline, from data ingestion to the final analytical layer, is built using SQL Server.

**Key Objectives (Data Engineering):**

*   **Data Ingestion:** Develop a repeatable process to ingest raw data from CSV files originating from CRM and ERP systems.
*   **Data Transformation & Cleansing:** Implement comprehensive data quality checks, cleanse, standardize, and transform raw data into a usable and consistent format.
*   **Data Modeling:** Design and build a dimensional model (Star Schema) in the Gold layer, optimized for analytical queries.
*   **ETL Automation:** Utilize SQL Server stored procedures to automate the ETL process across the different layers.
*   **Documentation & Maintainability:** Ensure clear documentation of the data flow, schema, and transformations.

## 2. Data Engineering Methodology

### 2.1. Medallion Architecture

The project leverages the Medallion Architecture to manage data through three distinct layers:

*   **Bronze Layer (Raw Ingestion):**
    *   **Purpose:** Serves as the initial landing zone for raw source data. Data is ingested "as-is" from source systems with minimal to no transformation, preserving the original data fidelity.
    *   **Characteristics:** Tables mirror the structure of the source CSV files. Data is typically immutable here.
    *   **Key Scripts:**
        *   `scripts/bronze/ddl_bronze.sql`: Defines the schema for Bronze tables.
        *   `scripts/bronze/Proc_load_bronze.sql`: Stored procedure to truncate and bulk load data from CSVs.

*   **Silver Layer (Cleansed & Conformed):**
    *   **Purpose:** Data from the Bronze layer is cleaned, standardized, conformed, and enriched. This layer provides a more reliable and queryable version of the data.
    *   **Characteristics:** Addresses data quality issues, applies business rules, resolves data type inconsistencies, and may involve joining datasets from different sources. Tables often include auditing columns (e.g., `dwh_create_date`).
    *   **Key Scripts:**
        *   `scripts/Silver/ddl_silver.sql`: Defines the schema for Silver tables.
        *   `scripts/Silver/PROC_LOAD_silver`: Stored procedure to transform data from Bronze and load it into Silver tables.

*   **Gold Layer (Business-Ready & Optimized):**
    *   **Purpose:** The final presentation layer, providing business-centric data models optimized for analytics and reporting. Data is typically aggregated and denormalized into a Star Schema.
    *   **Characteristics:** Consists of dimension and fact views. Ensures data is easily consumable by BI tools and end-users.
    *   **Key Scripts:**
        *   `scripts/gold/ddl_gold`: Defines the views for dimensions and facts.

### 2.2. ETL Process

The data pipeline follows an Extract, Transform, Load (ETL) pattern:

1.  **Extract (Source to Bronze):**
    *   Raw data is extracted from CSV files (`datasets/source_crm/` and `datasets/source_erp/`).
    *   The `bronze.load_bronze` stored procedure uses `BULK INSERT` to load data into the respective Bronze tables. Bronze tables are truncated before each load to ensure a full refresh.

2.  **Transform & Load (Bronze to Silver):**
    *   The `silver.load_silver` stored procedure extracts data from Bronze tables.
    *   It applies various transformations:
        *   **Cleansing:** Trimming spaces, handling NULLs (e.g., `ISNULL`, `COALESCE`).
        *   **Standardization:** Converting codes to descriptive values (e.g., marital status 'M' to 'Married', gender 'F' to 'Female') using `CASE` statements.
        *   **Data Type Conversion:** `CAST` and `CONVERT` functions for dates, numbers.
        *   **Deduplication:** Using `ROW_NUMBER() OVER (PARTITION BY ...)` to select unique or latest records.
        *   **Business Rule Implementation:** Deriving new fields (e.g., `prd_end_dt` using `LEAD()`), recalculating sales figures if inconsistent.
    *   Transformed data is then loaded into Silver tables. Silver tables are truncated before each load.

3.  **Transform & Present (Silver to Gold):**
    *   The Gold layer is implemented as SQL views (`gold.dim_customers`, `gold.dim_products`, `gold.fact_sales`).
    *   These views perform final transformations, joins between Silver tables, and generate surrogate keys (e.g., `ROW_NUMBER() OVER (ORDER BY ...)` for `customer_key`, `product_key`).
    *   This approach provides a virtual Gold layer, meaning data is transformed and presented on-demand when the views are queried.

## 3. Data Sources

*   **CRM System (CSV Files):**
    *   `cust_info.csv`: Customer demographic and account information.
    *   `prd_info.csv`: Product details, cost, and lifecycle dates.
    *   `sales_details.csv`: Transactional sales data including order numbers, product and customer identifiers, dates, and sales amounts.
*   **ERP System (CSV Files):**
    *   `CUST_AZ12.csv`: Supplementary customer data (e.g., birthdate, gender).
    *   `LOC_A101.csv`: Customer location information (country).
    *   `PX_CAT_G1V2.csv`: Product category and subcategory details.

## 4. Database and Schema Structure

*   **Database:** `DataWarehouse` (SQL Server)
*   **Schemas:**
    *   `bronze`: Contains raw data tables.
    *   `silver`: Contains cleansed and transformed tables.
    *   `gold`: Contains dimension and fact views for analytics.
*   **Detailed Data Catalog:** For a comprehensive list of tables, columns, data types, and descriptions, please refer to `Docs/comprehensive_data_catalog.md`.
*   **Naming Conventions:** The project adheres to specific naming conventions for database objects. Details can be found in `Docs/naming_conventions.md`. Key conventions include:
    *   `snake_case` for all objects.
    *   Table prefixes: `crm_`, `erp_` for source-specific tables.
    *   Gold layer prefixes: `dim_` for dimensions, `fact_` for facts.
    *   Key suffixes: `_key` for surrogate keys.
    *   Technical columns prefix: `dwh_` (e.g., `dwh_create_date`).

## 5. Key SQL Functions and Operations

The project utilizes a variety of T-SQL functionalities:

*   **DDL:** `CREATE DATABASE`, `CREATE SCHEMA`, `CREATE TABLE`, `DROP TABLE`, `ALTER DATABASE`.
*   **DML:** `INSERT INTO ... SELECT`, `TRUNCATE TABLE`.
*   **Data Ingestion:** `BULK INSERT`.
*   **Stored Procedures:** `CREATE OR ALTER PROCEDURE` for encapsulating ETL logic.
*   **Views:** `CREATE VIEW` for the Gold layer.
*   **Joins:** `LEFT JOIN` extensively used for combining data.
*   **Transformations:**
    *   String: `TRIM`, `SUBSTRING`, `REPLACE`, `LEN`, `UPPER`.
    *   Date/Time: `GETDATE()`, `CAST`, `CONVERT`, `DATEDIFF`, `LEAD()`.
    *   Conditional: `CASE WHEN ... THEN ... ELSE ... END`.
    *   NULL Handling: `ISNULL`, `COALESCE`, `NULLIF`.
*   **Window Functions:** `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` for deduplication and surrogate key generation, `LEAD() OVER (...)` for calculating end dates.
*   **Error Handling:** Basic `BEGIN TRY...END CATCH` blocks in stored procedures.

## 6. Data Quality and Testing

Data integrity and quality are maintained through:

*   **Transformations in Silver Layer:** Cleansing and standardization rules embedded in `silver.load_silver`.
*   **Dedicated SQL Test Scripts:**
    *   `tests/quality_checks_silver.sql`: Validates data in the Silver layer for issues like NULLs in key columns, duplicates, unwanted spaces, adherence to standardized values, valid date ranges, and logical consistency (e.g., sales = quantity * price).
    *   `tests/quality_checks_gold.sql`: Validates data in the Gold layer, primarily checking for the uniqueness of surrogate keys in dimension views and referential integrity between fact and dimension views.

## 7. Project Scope (Data Engineering)

*   Consolidate customer, product, and sales data from CRM and ERP CSV sources into a central SQL Server data warehouse.
*   Implement a three-layer Medallion Architecture (Bronze, Silver, Gold) for progressive data refinement.
*   Develop ETL pipelines using SQL stored procedures to automate data flow and transformations.
*   Create a Star Schema (dimensions and facts) in the Gold layer to support sales analytics and BI reporting.
*   The current implementation focuses on the most recent snapshot of data (full refresh at each layer) and does not implement Slowly Changing Dimensions (SCDs) for historical tracking.

## 8. How to Run the Project

1.  **Setup Database:**
    *   Ensure you have SQL Server installed and running.
    *   Execute the `scripts/init_database.sql` script. This will create the `DataWarehouse` database and the `bronze`, `silver`, and `gold` schemas. **Warning:** This script will drop the `DataWarehouse` database if it already exists.
2.  **Configure CSV File Paths:**
    *   The `bronze.load_bronze` stored procedure (`scripts/bronze/Proc_load_bronze.sql`) contains hardcoded paths to the source CSV files (e.g., `C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\...`).
    *   **You MUST update these paths** to reflect the location of the `datasets` directory on your local machine.
3.  **Create Bronze Layer Tables and Load Procedure:**
    *   Execute `scripts/bronze/ddl_bronze.sql` to create the tables in the Bronze schema.
    *   Execute `scripts/bronze/Proc_load_bronze.sql` to create the stored procedure for loading Bronze data.
4.  **Create Silver Layer Tables and Load Procedure:**
    *   Execute `scripts/Silver/ddl_silver.sql` to create the tables in the Silver schema.
    *   Execute `scripts/Silver/PROC_LOAD_silver` to create the stored procedure for transforming and loading Silver data.
5.  **Create Gold Layer Views:**
    *   Execute `scripts/gold/ddl_gold` to create the dimension and fact views in the Gold schema.
6.  **Run ETL Pipeline:**
    *   Execute the Bronze load procedure: `EXEC bronze.load_bronze;`
    *   Execute the Silver load procedure: `EXEC silver.load_silver;`
    *   The Gold layer views will automatically reflect the data from the Silver layer.
7.  **Run Quality Checks (Optional but Recommended):**
    *   Execute scripts in the `tests/` directory to validate data:
        *   `tests/quality_checks_silver.sql`
        *   `tests/quality_checks_gold.sql`
8.  **Explore Data:**
    *   You can now query the Gold layer views (e.g., `SELECT * FROM gold.fact_sales;`) for analysis.

## 9. Potential Future Enhancements (Data Engineering)

*   **Parameterization:** Parameterize file paths in `bronze.load_bronze` instead of hardcoding.
*   **Incremental Loads:** Implement incremental loading strategies for Silver and Gold layers instead of full truncates, especially for large datasets.
*   **Slowly Changing Dimensions (SCDs):** Implement SCD Type 2 or other types for dimensions like `dim_customers` and `dim_products` to track historical changes.
*   **Enhanced Error Logging & Alerting:** Develop a more robust error logging framework and alerting mechanism for ETL failures.
*   **Configuration Management:** Store configurations (file paths, connection strings) externally.
*   **Data Lineage Tracking:** Implement tools or processes for better data lineage tracking.
*   **Orchestration:** Use a workflow orchestration tool (e.g., Apache Airflow, SQL Server Agent Jobs for scheduling) to manage ETL job dependencies and scheduling.
*   **Infrastructure as Code (IaC):** If deploying to cloud or other environments, manage infrastructure using IaC principles.
