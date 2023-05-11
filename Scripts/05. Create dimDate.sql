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

CREATE EXTERNAL TABLE dbo.dimDate
WITH (
    LOCATION     = 'dim_date.txt',
    DATA_SOURCE = [divvy_staudacitydivvy_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
	DISTINCT(CAST(SUBSTRING(tmp.dt, 0, 11) AS DATE))            AS [date_key], 
	DATEPART(YEAR, CAST(SUBSTRING(tmp.dt, 0, 11) AS DATE))      AS [year],
	DATEPART(MONTH, CAST(SUBSTRING(tmp.dt, 0, 11) AS DATE))     AS [month],
	DATEPART(DAY, CAST(SUBSTRING(tmp.dt, 0, 11) AS DATE))       AS [day],
	DATEPART(WEEKDAY, CAST(SUBSTRING(tmp.dt, 0, 11) AS DATE))   AS [day_of_week],
	DATEPART(QUARTER, CAST(SUBSTRING(tmp.dt, 0, 11) AS DATE))   AS [quarter]
FROM [dbo].[staging_trip] tr
JOIN [dbo].[staging_rider] rd ON tr.rider_id = rd.rider_id
JOIN [dbo].[staging_payment] py ON rd.rider_id = py.rider_id
CROSS APPLY (VALUES 
	(tr.start_at), (tr.ended_at),
	(rd.birthday), (rd.account_start_date), (rd.account_end_date),
	(py.date)
) tmp(dt)
WHERE tmp.dt IS NOT NULL
ORDER BY date_key
GO

SELECT TOP 100 * FROM dbo.dimDate;
