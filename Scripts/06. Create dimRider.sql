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

CREATE EXTERNAL TABLE dbo.dimRider
WITH (
    LOCATION     = 'dim_rider.txt',
    DATA_SOURCE = [divvy_staudacitydivvy_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
    rd.rider_id    AS [rider_key],
    rd.first_name  AS [first_name],
    rd.last_name   AS [last_name],
    rd.address     AS [address],
    CAST(SUBSTRING(rd.birthday, 0, 11) AS DATE)           AS [birthday],
    CAST(SUBSTRING(rd.account_start_date, 0, 11) AS DATE) AS [account_date_start_key],
    CAST(SUBSTRING(rd.account_end_date, 0, 11) AS DATE)   AS [account_date_end_key],
    rd.is_member   AS [is_member]
FROM dbo.staging_rider rd

SELECT TOP(100) * FROM dbo.dimRider;