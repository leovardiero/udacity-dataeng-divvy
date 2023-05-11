CREATE TABLE dim_date (
  [date_key]    DATE,
  [year]        INT,
  [month]       INT,
  [day]         INT,
  [day_of_week] INT,
  [quarter]     INT
)

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = '1945-01-01'
SET @EndDate   = '2030-12-31'

WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO [dim_date]
             SELECT
                   @StartDate,
                   DATEPART(YEAR, @StartDate),
                   DATEPART(MONTH, @StartDate),
                   DATEPART(DAY, @StartDate),
                   DATEPART(WEEKDAY, @StartDate),
                   DATEPART(QUARTER, @StartDate),
             SET @StartDate = DATEADD(dd, 1, @StartDate)
      END