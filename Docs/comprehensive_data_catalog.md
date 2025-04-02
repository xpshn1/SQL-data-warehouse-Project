
Below is **a sample Markdown data catalog** that documents the key tables across your **Bronze**, **Silver**, and **Gold** layers. It is based on the SQL DDL/statements you provided. Feel free to modify the descriptions and add more business or domain context where necessary.

> **Tip**: You can save this as `DATA_CATALOG.md` (or whatever name you prefer) in your Git repository.

---

# Data Catalog

This document describes the data model for the **DataWarehouse** database, including **Dimension** and **Fact** tables in the `gold` schema and their supporting tables in the `bronze` and `silver` schemas. It covers:

1. **Business Meaning** of tables  
2. **Column Definitions** (names, data types, constraints, and a brief description)  
3. **Relationships** among tables  
4. **High-Level ETL Flow** (how data progresses from Bronze to Silver to Gold)

---

## 1. High-Level Schemas and Flow

**Database:** `DataWarehouse`  
**Schemas:**  
- **bronze**: Raw landing area for data from CSV files (CRM and ERP).  
- **silver**: Cleansed and conformed data, with basic transformations applied.  
- **gold**: Final presentation layer, containing Dimension and Fact “tables” (implemented as views).

**ETL Flow**:  
1. **Source → Bronze**  
   - Data is bulk-inserted from CSV into Bronze tables via the stored procedure `bronze.load_bronze`.  
2. **Bronze → Silver**  
   - Data is cleansed, deduplicated, and standardized, then loaded into Silver tables via `silver.load_silver`.  
3. **Silver → Gold**  
   - The “Gold” schema has views (`dim_customers`, `dim_products`, `fact_sales`) that pull from Silver tables. These views create surrogate keys (e.g., `customer_key`, `product_key`) and combine data as needed.

---

## 2. Bronze Schema

The **bronze** schema stores raw data exactly (or nearly) as received from source systems.

### 2.1 Table: `bronze.crm_cust_info`
| **Column**          | **Data Type**   | **Description**                                                  |
|---------------------|-----------------|------------------------------------------------------------------|
| `cst_id`            | `INT`           | Customer ID (raw from CRM system).                               |
| `cst_key`           | `NVARCHAR(50)`  | Unique customer key (string) from CRM.                           |
| `cst_firstname`     | `NVARCHAR(50)`  | Customer’s first name, raw.                                      |
| `cst_lastname`      | `NVARCHAR(50)`  | Customer’s last name, raw.                                       |
| `cst_marital_status`| `NVARCHAR(50)`  | Marital status field, could be codes like `S` or `M`.            |
| `cst_gndr`          | `NVARCHAR(50)`  | Gender code or description (e.g., `F`, `M`).                     |
| `cst_create_date`   | `DATE`          | The date the customer was created in CRM.                        |

**Purpose**: Holds raw customer data from the CRM system.

---

### 2.2 Table: `bronze.crm_prd_info`
| **Column**     | **Data Type**   | **Description**                                                     |
|----------------|-----------------|---------------------------------------------------------------------|
| `prd_id`       | `INT`           | Product ID from CRM.                                                |
| `prd_key`      | `NVARCHAR(50)`  | Product key (string) from CRM (e.g., “CAT01-PRD05”).                |
| `prd_nm`       | `NVARCHAR(50)`  | Name of the product.                                                |
| `prd_cost`     | `INT`           | Base cost of the product.                                           |
| `prd_line`     | `NVARCHAR(50)`  | Product line code (e.g., `M`, `R`, `T`).                             |
| `prd_start_dt` | `DATETIME`      | Start date/time of the product’s availability.                      |
| `prd_end_dt`   | `DATETIME`      | End date/time of the product’s availability.                        |

**Purpose**: Holds raw product details from the CRM system.

---

### 2.3 Table: `bronze.crm_sales_details`
| **Column**     | **Data Type**   | **Description**                                                  |
|----------------|-----------------|------------------------------------------------------------------|
| `sls_ord_num`  | `NVARCHAR(50)`  | Sales order number.                                              |
| `sls_prd_key`  | `NVARCHAR(50)`  | Product key, referencing `prd_key` in product table.             |
| `sls_cust_id`  | `INT`           | Customer ID referencing the CRM customer table.                  |
| `sls_order_dt` | `INT`           | Raw numeric date field (format: `YYYYMMDD`) for order date.      |
| `sls_ship_dt`  | `INT`           | Raw numeric date field for ship date.                            |
| `sls_due_dt`   | `INT`           | Raw numeric date field for due date.                             |
| `sls_sales`    | `INT`           | Total sales dollar amount (raw).                                 |
| `sls_quantity` | `INT`           | Quantity of the product sold.                                    |
| `sls_price`    | `INT`           | Price of the product (raw).                                      |

**Purpose**: Raw sales transaction details (CRM side).

---

### 2.4 Table: `bronze.erp_loc_a101`
| **Column** | **Data Type**    | **Description**                           |
|------------|------------------|-------------------------------------------|
| `cid`      | `NVARCHAR(50)`   | Customer identifier in ERP.              |
| `cntry`    | `NVARCHAR(50)`   | Country code or name from ERP.           |

**Purpose**: Location / country data for customers from the ERP system.

---

### 2.5 Table: `bronze.erp_cust_az12`
| **Column** | **Data Type**    | **Description**                                   |
|------------|------------------|---------------------------------------------------|
| `cid`      | `NVARCHAR(50)`   | Customer identifier in ERP. (Sometimes prefixed.) |
| `bdate`    | `DATE`           | Birthdate from ERP (raw).                         |
| `gen`      | `NVARCHAR(50)`   | Gender code or text from ERP.                     |

**Purpose**: Supplemental customer data from ERP (e.g., birthdate, gender).

---

### 2.6 Table: `bronze.erp_px_cat_g1v2`
| **Column**     | **Data Type**    | **Description**                      |
|----------------|------------------|--------------------------------------|
| `id`           | `NVARCHAR(50)`   | Category / product key from ERP.     |
| `cat`          | `NVARCHAR(50)`   | Product category (ERP).             |
| `subcat`       | `NVARCHAR(50)`   | Product subcategory (ERP).          |
| `maintenance`  | `NVARCHAR(50)`   | Maintenance type (ERP).             |

**Purpose**: Category and subcategory definitions from the ERP.

---

## 3. Silver Schema

The **silver** schema contains the “cleansed” and partially conformed data. Basic transformations, data type conversions, deduplication, and standardizations happen here.

**Key Transformations**:  
- Trimming spaces, converting codes (e.g., `S` → `Single`), deriving end dates, etc.  
- Reconciling CRM/ERP fields (e.g., removing prefix `NAS` from customer IDs).  
- Converting integer date fields (YYYYMMDD) into SQL `DATE`.

Below are the main Silver tables that mirror Bronze structure but store cleaned values.

### 3.1 Table: `silver.crm_cust_info`
| **Column**           | **Data Type**     | **Description**                                                                                 |
|----------------------|-------------------|-------------------------------------------------------------------------------------------------|
| `cst_id`             | `INT`            | Customer ID.                                                                                    |
| `cst_key`            | `NVARCHAR(50)`    | CRM customer key.                                                                               |
| `cst_firstname`      | `NVARCHAR(50)`    | Trimmed first name.                                                                             |
| `cst_lastname`       | `NVARCHAR(50)`    | Trimmed last name.                                                                              |
| `cst_marital_status` | `NVARCHAR(50)`    | Converted from codes `M`, `S` to full text or set to `n/a`.                                      |
| `cst_gndr`           | `NVARCHAR(50)`    | Converted from `F`, `M` to full text or set to `n/a`.                                           |
| `cst_create_date`    | `DATE`           | Original CRM create date.                                                                       |
| `dwh_create_date`    | `DATETIME2`       | Metadata: date/time when the record was loaded into Silver. Default is `GETDATE()`.             |

---

### 3.2 Table: `silver.crm_prd_info`
| **Column**         | **Data Type**     | **Description**                                                                                                      |
|--------------------|-------------------|----------------------------------------------------------------------------------------------------------------------|
| `prd_id`           | `INT`            | Product ID from CRM.                                                                                                 |
| `cat_id`           | `NVARCHAR(50)`    | Inferred category ID, extracted from `prd_key` (first 5 chars, etc.).                                               |
| `prd_key`          | `NVARCHAR(50)`    | Cleaned product key.                                                                                                 |
| `prd_nm`           | `NVARCHAR(50)`    | Product name.                                                                                                        |
| `prd_cost`         | `INT`            | Defaulted to 0 if null.                                                                                              |
| `prd_line`         | `NVARCHAR(50)`    | Converted from single-letter codes (`M`, `R`, etc.) to meaningful text (`Mountain`, `Road`, etc.) or `n/a`.          |
| `prd_start_dt`     | `DATE`           | Start date, cast from Bronze `DATETIME`.                                                                             |
| `prd_end_dt`       | `DATE`           | Derived as “day before next version’s start date” (or `NULL` if no subsequent version).                               |
| `dwh_create_date`  | `DATETIME2`       | Metadata: date/time record was loaded.                                                                               |

---

### 3.3 Table: `silver.crm_sales_details`
| **Column**       | **Data Type**   | **Description**                                                                                               |
|------------------|-----------------|---------------------------------------------------------------------------------------------------------------|
| `sls_ord_num`    | `NVARCHAR(50)`  | Order number.                                                                                                 |
| `sls_prd_key`    | `NVARCHAR(50)`  | Product key referencing Silver’s product table.                                                               |
| `sls_cust_id`    | `INT`           | CRM customer ID.                                                                                              |
| `sls_order_dt`   | `DATE`          | Converted from numeric `YYYYMMDD`. `NULL` if invalid.                                                         |
| `sls_ship_dt`    | `DATE`          | Converted from numeric `YYYYMMDD`. `NULL` if invalid.                                                         |
| `sls_due_dt`     | `DATE`          | Converted from numeric `YYYYMMDD`. `NULL` if invalid.                                                         |
| `sls_sales`      | `INT`           | If null or not matching `quantity * price`, it’s recalculated.                                                |
| `sls_quantity`   | `INT`           | Quantity of product sold.                                                                                     |
| `sls_price`      | `INT`           | Unit price. If invalid, fallback is `sls_sales / sls_quantity`.                                              |
| `dwh_create_date`| `DATETIME2`     | Metadata: date/time record was loaded.                                                                        |

---

### 3.4 Table: `silver.erp_loc_a101`
| **Column**         | **Data Type**   | **Description**                                                     |
|--------------------|-----------------|---------------------------------------------------------------------|
| `cid`              | `NVARCHAR(50)`  | Customer ID from ERP (dashes removed).                              |
| `cntry`            | `NVARCHAR(50)`  | Standardized country name (`DE` → `Germany`, `US` → `United States`).|
| `dwh_create_date`  | `DATETIME2`     | Load timestamp.                                                     |

---

### 3.5 Table: `silver.erp_cust_az12`
| **Column**        | **Data Type**    | **Description**                                                                                           |
|-------------------|------------------|-----------------------------------------------------------------------------------------------------------|
| `cid`             | `NVARCHAR(50)`   | Customer ID from ERP; prefixes like `NAS` stripped out.                                                   |
| `bdate`           | `DATE`           | Customer birthdate; set to `NULL` if date is in the future.                                               |
| `gen`             | `NVARCHAR(50)`   | Standardized gender (`F/M`/`Female/Male` → `Female`/`Male`, else `n/a`).                                  |
| `dwh_create_date` | `DATETIME2`      | Load timestamp.                                                                                           |

---

### 3.6 Table: `silver.erp_px_cat_g1v2`
| **Column**        | **Data Type**    | **Description**                    |
|-------------------|------------------|------------------------------------|
| `id`              | `NVARCHAR(50)`   | Category/product ID from ERP.      |
| `cat`             | `NVARCHAR(50)`   | High-level category name.          |
| `subcat`          | `NVARCHAR(50)`   | Subcategory name.                  |
| `maintenance`     | `NVARCHAR(50)`   | Maintenance info/type.             |
| `dwh_create_date` | `DATETIME2`      | Load timestamp.                    |

---

## 4. Gold Schema (Dimensions & Fact Tables)

In the **gold** schema, data is presented as **views** that combine Silver tables and create surrogate keys. This is the final “dim/fact” structure of the warehouse.

### 4.1 View: `gold.dim_customers`
A dimension containing consolidated customer information from CRM (master) plus ERP (supplemental birthdate, country, etc.).

| **Column**       | **Data Type** | **Description**                                                                                    |
|------------------|---------------|----------------------------------------------------------------------------------------------------|
| `customer_key`   | `BIGINT` (via `ROW_NUMBER`) | Surrogate key for the dimension (automatically generated).                          |
| `customer_id`    | `INT`         | Original CRM Customer ID (`cst_id`).                                                                |
| `customer_number`| `NVARCHAR(50)`| CRM Customer Key (`cst_key`).                                                                       |
| `first_name`     | `NVARCHAR(50)`| Customer’s first name.                                                                              |
| `last_name`      | `NVARCHAR(50)`| Customer’s last name.                                                                               |
| `country`        | `NVARCHAR(50)`| Country derived from `silver.erp_loc_a101`.                                                         |
| `marital_status` | `NVARCHAR(50)`| `Single`, `Married`, or `n/a` from the CRM data.                                                    |
| `gender`         | `NVARCHAR(50)`| Combined from CRM `cst_gndr` if not `n/a`, else from ERP `gen`.                                     |
| `birthdate`      | `DATE`        | Customer birthdate from ERP (if valid).                                                             |
| `create_date`    | `DATE`        | The date the customer record was created in CRM.                                                   |

**Relationships**:  
- Linked to `gold.fact_sales` on `customer_key`.  

---

### 4.2 View: `gold.dim_products`
A dimension containing product information from Silver’s CRM tables plus category data from ERP.

| **Column**       | **Data Type**    | **Description**                                                                                                  |
|------------------|------------------|------------------------------------------------------------------------------------------------------------------|
| `product_key`    | `BIGINT` (via `ROW_NUMBER`) | Surrogate key for the dimension.                                                                           |
| `product_id`     | `INT`            | Original product ID from CRM.                                                                                   |
| `product_number` | `NVARCHAR(50)`   | CRM product key.                                                                                                |
| `product_name`   | `NVARCHAR(50)`   | Product name.                                                                                                   |
| `category_id`    | `NVARCHAR(50)`   | Category ID extracted from the CRM product key.                                                                 |
| `category`       | `NVARCHAR(50)`   | Category name from `silver.erp_px_cat_g1v2`.                                                                    |
| `sub_category`   | `NVARCHAR(50)`   | Subcategory name from `silver.erp_px_cat_g1v2`.                                                                 |
| `maintenance`    | `NVARCHAR(50)`   | Maintenance type from `silver.erp_px_cat_g1v2`.                                                                 |
| `cost`           | `INT`            | Product cost.                                                                                                   |
| `product_line`   | `NVARCHAR(50)`   | Converted product line text (`Mountain`, `Road`, etc.).                                                         |
| `start_date`     | `DATE`           | The date the product version became valid (i.e., from `prd_start_dt`, ignoring historical ended versions).      |

**Relationships**:  
- Linked to `gold.fact_sales` on `product_key`.

---

### 4.3 View: `gold.fact_sales`
The central fact table capturing sales transactions.

| **Column**      | **Data Type**   | **Description**                                                                      |
|-----------------|-----------------|--------------------------------------------------------------------------------------|
| `order_number`  | `NVARCHAR(50)`  | Identifier for the sales order.                                                      |
| `product_key`   | `BIGINT`        | Surrogate key referencing `gold.dim_products.product_key`.                           |
| `customer_key`  | `BIGINT`        | Surrogate key referencing `gold.dim_customers.customer_key`.                         |
| `order_date`    | `DATE`          | Order date from CRM.                                                                 |
| `ship_date`     | `DATE`          | Shipment date from CRM.                                                              |
| `due_date`      | `DATE`          | Due date (deadline) from CRM.                                                        |
| `sales_amount`  | `INT`           | Total dollar amount of the line item sale.                                           |
| `quantity`      | `INT`           | Number of units sold.                                                                |
| `price`         | `INT`           | Unit price for the product.                                                          |

**Keys & Relationships**:  
- **product_key** → References `dim_products`  
- **customer_key** → References `dim_customers`

---

## 5. Stored Procedures & ETL Overview

### 5.1 `bronze.load_bronze`
- **Location**: `bronze` schema  
- **Purpose**: Bulk insert data from CSV files into `bronze` tables.  
- **Key Steps**:  
  1. Truncates each `bronze.*` table.  
  2. Executes `BULK INSERT` from CSV to each table.  
  3. Captures load duration times for logging.

### 5.2 `silver.load_silver`
- **Location**: `silver` schema  
- **Purpose**: Transforms and loads data from `bronze` to `silver`.  
- **Key Transformations**:  
  - **Customer**: Deduplicate (`ROW_NUMBER` by `cst_id`), unify gender codes, unify marital status, remove invalid data.  
  - **Product**: Map product lines, derive category ID from partial product key, handle null cost, date transformations.  
  - **Sales**: Convert integer dates (YYYYMMDD) to actual `DATE`, fix invalid `price` or `sales` if needed.  
  - **ERP**: Standardize `cid`, remove dashes/prefixes, standardize country, birthdate, and gender fields.  

### 5.3 Gold Layer
- The **Gold** layer comprises **views** that join and shape the dimension and fact data from the Silver tables.  
- **No separate stored procedure**—the data is always “live” from the Silver tables whenever you select from the Gold views.

---

## 6. Table Relationships (Gold Layer)

Below is a simple overview of how **gold** tables relate:

```
          +-------------------+             +-------------------+
          | gold.dim_customers|             | gold.dim_products |
          | (customer_key PK) |             | (product_key PK)  |
          +---------+---------+             +---------+---------+
                    |                                 |
                    |                                 |
                    v                                 v
                      +---------------------------------+
                      |         gold.fact_sales         |
                      |  (product_key, customer_key)    |
                      +---------------------------------+
```

- **`gold.fact_sales`** → references **`gold.dim_customers`** and **`gold.dim_products`**.  

---

## 7. Naming Conventions

- **Bronze** tables mirror raw source naming: `crm_*`, `erp_*`.  
- **Silver** tables keep similar names but with standardized columns and new `dwh_create_date`.  
- **Gold** schema is made of dimension views named `dim_*` and fact views named `fact_*`.  
- Surrogate keys are named `*_key` (e.g., `customer_key`, `product_key`).

---

## 8. Update Frequency & Data Sources

- **Data Sources**:  
  - CRM data from CSV files: `cust_info.csv`, `prd_info.csv`, `sales_details.csv`.  
  - ERP data from CSV files: `CUST_AZ12.csv`, `LOC_A101.csv`, `PX_CAT_G1V2.csv`.  
- **Load Frequency**:  
  - Bronze loads typically happen daily via the `bronze.load_bronze` procedure.  
  - Silver loads run after Bronze completes, via `silver.load_silver`.  
  - Gold is view-based; no physical load, so it’s always up-to-date with Silver.

---

## 9. Future Enhancements

- **Date Dimension**: Common in data warehousing to have a `dim_date` or `dim_time` to handle date-related attributes (e.g., calendar year, quarter, day of week).  
- **Additional Constraints**: Enforce primary/foreign keys, unique indexes, or not null constraints in Silver/Gold if desired.  
- **Slowly Changing Dimensions**: Currently, the design seems to skip SCD logic. If historical dimension changes matter, consider SCD Type 2 expansions.

---

**End of Data Catalog**  
