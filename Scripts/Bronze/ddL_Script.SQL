/*
=============================================================
Stored Procedure : Bronze.Load_bronze
=============================================================
Purpose:
    This stored procedure performs the full load of the
    Bronze layer in the Data Warehouse. It handles:
    - DDL : Drops and recreates all Bronze tables
    - ETL : Bulk inserts raw CSV data into Bronze tables

Data Sources:
    Source 1 - CRM:
        - cust_info.csv      → Bronze.Crm_Cust_into
        - prd_info.csv       → Bronze.Crm_prd_into
        - sales_details.csv  → Bronze.Crm_Sales_into

    Source 2 - ERP:
        - LOC_A101.csv       → Bronze.Erp_loc_a101
        - CUST_AZ12.csv      → Bronze.Erp_cus_az12
        - PX_CAT_G1V2.csv    → Bronze.Erp_px_cat

Notes:
    - Tables are dropped and recreated on every run
    - No transformations applied; raw data only
    - Loading duration is printed for each table
    - Errors are caught and printed via TRY/CATCH

Run:
    EXEC Bronze.Load_bronze;
=============================================================
*/



-- Creating DDL data defination Language 
-- source 1 ; crm
CREATE OR ALTER PROCEDURE Bronze.Load_bronze  AS
BEGIN
BEGIN TRY
		DECLARE  @Start_Time DATETIME ,@End_Time DATETIME 
				IF OBJECT_ID('Bronze.Crm_Cust_into','U')  IS NOT NULL
				  DROP TABLE  Bronze.Crm_Cust_into;
				CREATE TABLE Bronze.Crm_Cust_into
				(
				Cust_ID  INT,
				Cust_Key NVARCHAR(50),
				Cust_FirstName NVARCHAR(50),
				Cust_LastName NVARCHAR(50),
				Cust_Martial_Status NVARCHAR(50),
				Cust_gndr NVARCHAR(50),
				Cust_Date DATE
				)

				IF OBJECT_ID('Bronze.Crm_prd_into','U')  IS NOT NULL
				  DROP TABLE  Bronze.Crm_prd_into;

				CREATE TABLE Bronze.Crm_prd_into
				(
				prd_ID  INT,
				prd_Key NVARCHAR(50),
				prd_Nm NVARCHAR(50),
				prd_Line NVARCHAR(50),
				prd_cost NVARCHAR(50),
				prd_StartDate NVARCHAR(50),
				prd_EndDate NVARCHAR(50),
				)


				IF OBJECT_ID('Bronze.Crm_Sales_into','U')  IS NOT NULL
				  DROP TABLE  Bronze.Crm_Sales_into;
				CREATE TABLE Bronze.Crm_Sales_into
				(
				Sales_Key NVARCHAR(50),
				Sales_Num NVARCHAR(50),
				Sales_Price INT,
				Sales_Quantity  NVARCHAR(50),
				Sales_Sales  INT,
				Sales_DueDate  INT,
				Sales_OrderDate  INT,
				Sales_ShipDate  NVARCHAR(50),
				)

				--Source 2;ERP
				IF OBJECT_ID('Bronze.Erp_loc_a101','U')  IS NOT NULL
				  DROP TABLE  Bronze.Erp_loc_a101;
				CREATE TABLE Bronze.Erp_loc_a101
				(
				cid NVARCHAR(50),
				centry  NVARCHAR(50)
				)


				IF OBJECT_ID('Bronze.Erp_cus_az12','U')  IS NOT NULL
				  DROP TABLE  Bronze.Erp_cus_az12;
				CREATE TABLE Bronze.Erp_cus_az12
				(
				cid NVARCHAR(50),
				cbdate NVARCHAR(50),

				gen NVARCHAR(50)
				)

				IF OBJECT_ID('Bronze.Erp_px_cat','U')  IS NOT NULL
				  DROP TABLE  Bronze.Erp_px_cat;
				CREATE TABLE Bronze.Erp_px_cat
				(
				id NVARCHAR(50),
				cat NVARCHAR(50),
				subcat NVARCHAR(50),
				 maintainence NVARCHAR(50),
				)

				-- BULK INSERT 
				--1
				SET @Start_Time = GETDATE()
				TRUNCATE TABLE Bronze.Crm_Cust_into

				BULK INSERT Bronze.Crm_Cust_into
				FROM 'E:\SQL2022\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
				WITH(
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK
				)
				SET @End_Time = GETDATE()
				PRINT '>>loading duration '+CAST(DATEDIFF(SECOND,@Start_Time,@End_Time) AS NVARCHAR)+'seconds';


				--2
				SET @Start_Time = GETDATE();
				TRUNCATE TABLE Bronze.Crm_prd_into

				BULK INSERT Bronze.Crm_prd_into
				FROM 'E:\SQL2022\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
				WITH(
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK
				)
				SET @End_Time =GETDATE();
				PRINT'>>Loading time '+CAST(DATEDIFF(SECOND,@Start_Time,@End_Time) AS NVARCHAR)+'SEC'







				--3
				TRUNCATE TABLE Bronze.Crm_Sales_into

				BULK INSERT Bronze.Crm_Sales_into
				FROM 'E:\SQL2022\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
				WITH(
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK
				)




				--4
				TRUNCATE TABLE Bronze.Erp_loc_a101
				BULK INSERT Bronze.Erp_loc_a101
				FROM 'E:\SQL2022\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
				WITH(
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK
				)




				--5
				TRUNCATE TABLE Bronze.Erp_cus_az12

				BULK INSERT Bronze.Erp_cus_az12
				FROM 'E:\SQL2022\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv '
				WITH(
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK
				)





				--6
				TRUNCATE TABLE Bronze.Erp_px_cat

				BULK INSERT Bronze.Erp_px_cat
				FROM 'E:\SQL2022\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
				WITH(
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK
				)
		END TRY
		BEGIN CATCH
		   PRINT 'An Error HAs Occured'
		   PRINT 'Error _MEassage'+CAST(ERROR_MESSAGE() AS NVARCHAR)
		    PRINT 'Error _State'+CAST(ERROR_STATE() AS NVARCHAR)
			 
		END CATCH
END
