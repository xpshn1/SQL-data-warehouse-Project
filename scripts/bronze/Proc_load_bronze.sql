/*
===============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================

Script Purpose:
This stored procedure loads data into the ‘bronze’ schema from external CSV files.
It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the ‘BULK INSERT’ command to load data from CSV files to bronze tables.

Parameters:
None.
This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;

===============================================================
*/

-- inserting data from CSV

--EXEC bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=================================';
		PRINT 'Loading bronze layer'
		PRINT '=================================';

		PRINT '---------------------------------';
		PRINT 'Loading CRM tables';
		PRINT '---------------------------------';

	
		--truncate
		SET @start_time =GETDATE();
		PRINT '>> Truncating table bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		--load
		PRINT '>> loading data into table bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		from 'C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS Nvarchar) + 'seconds';
		PRINT '>> -------------';

		--truncate
		SET @start_time =GETDATE();
		PRINT '>> Truncating table bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		--load
		PRINT '>> loading data into table bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		from 'C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS Nvarchar) + 'seconds';
		PRINT '>> -------------';

		--truncate
		SET @start_time =GETDATE();
		PRINT '>> Truncating table bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		--load
		PRINT '>> loading data into table bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		from 'C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS Nvarchar) + 'seconds';
		PRINT '>> -------------';

		PRINT '---------------------------------';
		PRINT 'Loading ERP tables';
		PRINT '---------------------------------';

		--truncate
		SET @start_time =GETDATE();
		PRINT '>> Truncating table [bronze].[erp_cust_az12]';
		TRUNCATE TABLE [bronze].[erp_cust_az12];

		--load
		PRINT '>> loading data into table [bronze].[erp_cust_az12]';
		BULK INSERT [bronze].[erp_cust_az12]
		from 'C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS Nvarchar) + 'seconds';
		PRINT '>> -------------';

		--truncate
		SET @start_time =GETDATE();
		PRINT '>> Truncating table [bronze].[erp_loc_a101]'; 

		TRUNCATE TABLE [bronze].[erp_loc_a101];

		--load
		PRINT '>> loading data into table [bronze].[erp_loc_a101]';
		BULK INSERT [bronze].[erp_loc_a101]
		from 'C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS Nvarchar) + 'seconds';
		PRINT '>> -------------';

		--truncate
		SET @start_time =GETDATE();
		PRINT '>> Truncating table [bronze].[erp_px_cat_g1v2]';
		TRUNCATE TABLE [bronze].[erp_px_cat_g1v2];

		--load
		PRINT '>> loading data into table [bronze].[erp_px_cat_g1v2]';
		BULK INSERT [bronze].[erp_px_cat_g1v2]
		from 'C:\Users\lenovo\OneDrive\Desktop\SQL project files\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS Nvarchar) + 'seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '===================================='
		PRINT 'Loading bronze layer is completed';
		PRINT ' TOTAL LOAD DURATION: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '===================================='
		END TRY
		BEGIN CATCH
			PRINT '================================'
			PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Message' + CAST (ERROR_MESSAGE() AS NVARCHAR);
			PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
			PRINT '================================'
		END CATCH
END
