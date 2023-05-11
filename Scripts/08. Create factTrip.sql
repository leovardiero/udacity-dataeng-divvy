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

CREATE EXTERNAL TABLE dbo.factTrip
WITH (
    LOCATION     = 'fact_trip.txt',
    DATA_SOURCE = [divvy_staudacitydivvy_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
    tr.trip_id          AS [trip_key],
    tr.rider_id         AS [rider_key],
    tr.start_station_id AS [start_station_key],
    tr.end_station_id   AS [end_station_key],
    CAST(SUBSTRING(tr.start_at, 0, 11) AS DATE)  AS [start_date_key],
    CAST(SUBSTRING(tr.start_at, 12, 20) AS TIME) AS [start_time],
    CAST(SUBSTRING(tr.ended_at, 0, 11) AS DATE)  AS [end_date_key],
    CAST(SUBSTRING(tr.ended_at, 12, 20) AS TIME) AS [end_time],
    CAST(DATEADD(SECOND, 
                 DATEDIFF(SECOND, tr.start_at, tr.ended_at), 
                 0) AS TIME) AS [rid_duration],

    tr.rideable_type   AS [rideable_type]
FROM dbo.staging_trip tr

SELECT TOP(100) * FROM dbo.factTrip;