USE ReportServer
GO

DECLARE @ReportPath NVARCHAR(425) = ''; -- empty string is Root folder.

;WITH cteCatalog (ItemId, ParentId, ReportPath, ReportType, ItemLevel, HierarchyPath) AS
(
    SELECT c.ItemID
        ,c.ParentID
        ,c.[Path] AS ReportPath
        ,c.[Type] AS ReportType
        ,0 AS ItemLevel
        ,hierarchyid::GetRoot() AS HierarchyPath
    FROM dbo.[Catalog] AS c
    WHERE c.[Path] = @ReportPath
    UNION ALL
    SELECT c.ItemID
        ,c.ParentID
        ,c.[Path] AS ReportPath
        ,c.[Type] AS ReportType
        ,cte.ItemLevel + 1 AS ItemLevel
        ,CAST(cte.HierarchyPath.ToString() + CAST(ROW_NUMBER() OVER (PARTITION BY c.ParentID ORDER BY c.ParentID) AS VARCHAR(20)) + '/' AS HIERARCHYID)        
    FROM dbo.[Catalog] AS c
        INNER JOIN cteCatalog AS cte ON c.ParentID = cte.ItemId
) 
SELECT cte.ReportPath AS ReportFolder      
      ,(SELECT COUNT(*)
        FROM cteCatalog c
        WHERE c.HierarchyPath.IsDescendantOf(cte.HierarchyPath) = 1
            AND c.ReportType = 2  -- Report RDLs
      ) AS CountOfReports
FROM cteCatalog AS cte
WHERE cte.ReportType = 1  -- Report Folders
ORDER BY cte.HierarchyPath
;