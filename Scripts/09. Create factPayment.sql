IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = '|',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'divvy_staudacitydivvy_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [divvy_staudacitydivvy_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://divvy@staudacitydivvy.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.factPayment
WITH (
    LOCATION     = 'fact_payment.txt',
    DATA_SOURCE = [divvy_staudacitydivvy_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
    p.payment_id AS [payment_key],
    p.rider_id   AS [rider_key],
    CAST(SUBSTRING(p.date, 0, 11) AS DATE) AS [date],
    p.amount     AS [amount]
FROM dbo.staging_payment p

SELECT TOP(100) * FROM dbo.factPayment;