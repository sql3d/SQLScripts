USE ApplicationIdentity

CREATE TABLE #SIZE
(
Name	NVARCHAR(200)
,rows	bigint
,reserved	NVARCHAR(30)
,data		nvarchar(30)
,index_size	nvarchar(30)
,unused		nvarchar(30)
)

INSERT INTO #SIZE
EXEC SP_SPACEUSED 'stage.trSite'

SELECT 104857600/(LEFT(data,LEN(data) -3) * 1024 / [rows]) AS DEFAULTMAXBUFFERROWS
FROM #SIZE

DROP TABLE #SIZE



-- 261490 - ActiveDirectoryIdentity
-- 384093 - tbContractor
-- 365357 - tbEmployee
--506558 - tbEmployeeMaster
-- 540503 - tbIdentity
-- 524288 - tbNetwork
-- 936228 - tbPhone
-- 1379705 - tbVendor_Cox_mgr
--1416994 - tbVendor_master
--881156 - tmIdentity_EmpMaster
--1294538 - trDepartment
-- 800439 - trLocation
-- 782519 - trSite
