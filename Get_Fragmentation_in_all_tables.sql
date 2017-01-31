-- Find fragmentation levels for all tables in a database

-- Define database
use total_rewards
go


-- Create temp table
CREATE TABLE #fraglist (
ObjectName CHAR (255),
ObjectId INT,
IndexName CHAR (255),
IndexId INT,
Lvl INT,
CountPages INT,
CountRows INT,
MinRecSize INT,
MaxRecSize INT,
AvgRecSize INT,
ForRecCount INT,
Extents INT,
ExtentSwitches INT,
AvgFreeBytes INT,
AvgPageDensity INT,
ScanDensity DECIMAL,
BestCount INT,
ActualCount INT,
LogicalFrag DECIMAL,
ExtentFrag DECIMAL)

-- Insert fragmentation level information
exec sp_MSforeachtable 'insert into #fraglist exec(''DBCC showcontig (''''?'''') with tableresults '') '

-- Get all the info back
SELECT * FROM #fraglist

-- Look at AvgFreeBytes, ScanDensity, LogicalFrag and ExtenFrag columns to get frag levels
