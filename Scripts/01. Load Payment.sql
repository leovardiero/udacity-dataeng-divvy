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

CREATE EXTERNAL TABLE dbo.staging_payment (
	[payment_id] int,
	[date]       varchar(4000),
	[amount]     float,
	[rider_id]   int
	)
	WITH (
	LOCATION = 'payment.txt',
	DATA_SOURCE = [divvy_staudacitydivvy_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO