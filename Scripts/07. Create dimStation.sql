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

CREATE EXTERNAL TABLE dbo.dimStation
WITH (
    LOCATION     = 'dim_station.txt',
    DATA_SOURCE = [divvy_staudacitydivvy_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
    st.station_id AS [station_key],
    st.name       AS [name],
    st.latitude   AS [latitude],
    st.longitude  AS [longitude]
FROM dbo.staging_station st

SELECT TOP(100) * FROM dbo.dimStation;