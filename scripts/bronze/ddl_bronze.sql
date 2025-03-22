/*
==================================================================================
DDL script: Create bronze Tables
==================================================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables
  if they already exist.
  run this script to re-define the DDL structure of bronze tables
===================================================================================
*/







-- DDL scripts for all the tables
IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
create table bronze.crm_cust_info (
cst_id INT,
cst_key Nvarchar(50),
cst_firstname NVARCHAR (50),
cst_lastname NVARCHAR (50),
cst_marital_status NVARCHAR (50),
cst_gndr NVARCHAR (50),
cst_create_date DATE
);


IF OBJECT_ID ('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(255),
    prd_cost DECIMAL(10,2),
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);


IF OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales DECIMAL(10,2),
    sls_quantity INT,
    sls_price DECIMAL(10,2)
);


IF OBJECT_ID ('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    CID NVARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR(10)
);


IF OBJECT_ID ('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);


IF OBJECT_ID ('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(100),
    MAINTENANCE NVARCHAR(10)
);
