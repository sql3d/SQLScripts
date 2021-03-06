USE CALReportServer
GO

SELECT
    CASE CL.Type
        WHEN 1 THEN 'Folder'
        WHEN 2 THEN 'Report'
        WHEN 3 THEN 'Resource'
        WHEN 4 THEN 'Linked Report'
        WHEN 5 THEN 'Data Source'
    END                                 AS ObjectType,
    CP.Name                             AS ParentName,
    CL.Name                             AS Name,
    CL.Path                             AS Path,
    CU.UserName                         AS CreatedBy,
    CL.CreationDate                     AS CreationDate,
    UM.UserName                         AS ModifiedBy,
    CL.ModifiedDate                     AS ModifiedDate,
    CE.CountStart                       AS TotalExecutions,
    EL.InstanceName                     AS LastExecutedInstanceName,
    EL.UserName                         AS LastExecuter,
    EL.Format                           AS LastFormat,
    EL.TimeStart                        AS LastTimeStarted,
    EL.TimeEnd                          AS LastTimeEnded,
    EL.TimeDataRetrieval                AS LastTimeDataRetrieval,
    EL.TimeProcessing                   AS LastTimeProcessing,
    EL.TimeRendering                    AS LastTimeRendering,
    EL.Status                           AS LastResult,
    EL.ByteCount                        AS LastByteCount,
    EL.[RowCount]                       AS LastRowCount,
    SO.UserName                         AS SubscriptionOwner,
    SU.UserName                         AS SubscriptionModifiedBy,
    SS.ModifiedDate                     AS SubscriptionModifiedDate,
    SS.Description                      AS SubscriptionDescription,
    SS.LastStatus                       AS SubscriptionLastResult,
    SS.LastRunTime                      AS SubscriptionLastRunTime
FROM Catalog CL
JOIN Catalog CP
    ON CP.ItemID = CL.ParentID
JOIN Users CU
    ON CU.UserID = CL.CreatedByID
JOIN Users UM
    ON UM.UserID = CL.ModifiedByID
LEFT JOIN ( SELECT
                ReportID,
                MAX(TimeStart) LastTimeStart
            FROM ExecutionLog
            GROUP BY ReportID) LE
    ON LE.ReportID = CL.ItemID
LEFT JOIN ( SELECT
                ReportID,
                COUNT(TimeStart) CountStart
            FROM ExecutionLog
            GROUP BY ReportID) CE
    ON CE.ReportID = CL.ItemID
LEFT JOIN ExecutionLog EL
    ON EL.ReportID = LE.ReportID
    AND EL.TimeStart = LE.LastTimeStart
LEFT JOIN Subscriptions SS
    ON SS.Report_OID = CL.ItemID
LEFT JOIN Users SO
    ON SO.UserID = SS.OwnerID
LEFT JOIN Users SU
    ON SU.UserID = SS.ModifiedByID
WHERE 1 = 1
ORDER BY CP.Name, CL.Name ASC