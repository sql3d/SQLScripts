

--PART 1
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'DBGrowthRate' AND TYPE = 'U')
  DROP TABLE dbo.DBGrowthRate

CREATE TABLE dbo.DBGrowthRate (DBGrowthID INT IDENTITY(1,1), DBName VARCHAR(100), DBID INT,
	NumPages INT, OrigSize DECIMAL(10,2), CurSize DECIMAL(10,2), GrowthAmt VARCHAR(100), 
	MetricDate DATETIME)

SELECT sd.name AS DBName, mf.name AS FileName, mf.database_id, FILE_ID, SIZE
INTO #TempDBSize
FROM sys.databases sd
	JOIN sys.master_files mf ON sd.database_ID = mf.database_ID
ORDER BY mf.database_id, sd.name

INSERT INTO dbo.DBGrowthRate (DBName, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
(SELECT tds.DBName, tds.database_ID, SUM(tds.Size) AS NumPages, 
		CONVERT(DECIMAL(10,2),(((SUM(CONVERT(DECIMAL(10,2),tds.Size)) * 8000)/1024)/1024)) AS OrigSize,
		CONVERT(DECIMAL(10,2),(((SUM(CONVERT(DECIMAL(10,2),tds.Size)) * 8000)/1024)/1024)) AS CurSize,
		'0.00 MB' AS GrowthAmt, GETDATE() AS MetricDate
	FROM #TempDBSize tds
	WHERE tds.database_ID NOT IN 
		(SELECT DISTINCT DBID 
			FROM DBGrowthRate 
			WHERE DBName = tds.database_ID)
	GROUP BY tds.database_ID, tds.DBName)

DROP TABLE #TempDBSize

SELECT *
FROM DBGrowthRate
--Above creates initial table and checks initial data

--PART 2
--Below is the code run weekly to check the growth.
GO


/**************************************************************************************************
**
**  author: Daniel Denney (based on Richard Ding's previous work)
**  date:   4/15/2010
**  usage:  run once a week to gather statistics on database file growth
**			updates the dbo.DBGrowthRate table
**   
**************************************************************************************************/
CREATE PROC dbo.usp_Database_Growth_Rate

AS
	SET NOCOUNT ON 

	CREATE TABLE #TempDBSize2 (DBName VARCHAR(100), [FileName] VARCHAR(250), database_id INT, [FILE_ID] INT, SIZE INT)

	INSERT INTO #TempDBSize2
	SELECT sd.name AS DBName, mf.name AS FileName, mf.database_id, FILE_ID, SIZE
	--into #TempDBSize2
		FROM sys.databases sd
			JOIN sys.master_files mf ON sd.database_ID = mf.database_ID
		ORDER BY mf.database_id, sd.name

	IF EXISTS (SELECT DISTINCT DBName 
					FROM #TempDBSize2 
					WHERE DBName IN 
						(SELECT DISTINCT DBName FROM DBGrowthRate))
				AND CONVERT(VARCHAR(10),GETDATE(),101) > 
						(SELECT DISTINCT CONVERT(VARCHAR(10),MAX(MetricDate),101) AS MetricDate 
							FROM DBGrowthRate)
							
		BEGIN
			INSERT INTO dbo.DBGrowthRate (DBName, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
			(SELECT tds.DBName, tds.database_ID, SUM(tds.Size) AS NumPages, 
					dgr.CurSize AS OrigSize,
					CONVERT(DECIMAL(10,2),(((SUM(CONVERT(DECIMAL(10,2),tds.Size)) * 8000)/1024)/1024)) AS CurSize,
					CONVERT(VARCHAR(100),(CONVERT(DECIMAL(10,2),(((SUM(CONVERT(DECIMAL(10,2),tds.Size)) * 8000)/1024)/1024)) 
						- dgr.CurSize)) + ' MB' AS GrowthAmt, GETDATE() AS MetricDate
				FROM #TempDBSize2 tds
					JOIN DBGrowthRate dgr ON tds.database_ID = dgr.DBID
				WHERE DBGrowthID = 
					(SELECT DISTINCT MAX(DBGrowthID) 
						FROM DBGrowthRate
						WHERE DBID = dgr.DBID)
				GROUP BY tds.database_ID, tds.DBName, dgr.CurSize)
		END
	ELSE
	   IF NOT EXISTS (SELECT DISTINCT DBName 
						FROM #TempDBSize2 
						WHERE DBName IN (SELECT DISTINCT DBName FROM DBGrowthRate))
			BEGIN
				INSERT INTO dbo.DBGrowthRate (DBName, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
				(SELECT tds.DBName, tds.database_ID, SUM(tds.Size) AS NumPages, 
						CONVERT(DECIMAL(10,2),(((SUM(CONVERT(DECIMAL(10,2),tds.Size)) * 8000)/1024)/1024)) AS OrigSize,
						CONVERT(DECIMAL(10,2),(((SUM(CONVERT(DECIMAL(10,2),tds.Size)) * 8000)/1024)/1024)) AS CurSize,
						'0.00 MB' AS GrowthAmt, GETDATE() AS MetricDate
					FROM #TempDBSize2 tds
					WHERE tds.database_ID NOT IN 
						(SELECT DISTINCT DBID 
							FROM DBGrowthRate 
							WHERE DBName = tds.database_ID)
					GROUP BY tds.database_ID, tds.DBName)
			END

	DROP TABLE #TempDBSize2
GO