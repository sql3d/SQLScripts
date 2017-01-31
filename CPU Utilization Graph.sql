DECLARE
    @gc VARCHAR(MAX)
   ,@gi VARCHAR(MAX);

WITH    BR_Data
          AS (
              SELECT
                dm_os_ring_buffers.timestamp
               ,CONVERT(XML, dm_os_ring_buffers.record) AS record
              FROM
                sys.dm_os_ring_buffers
              WHERE
                dm_os_ring_buffers.ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                AND record LIKE '%<SystemHealth>%'
             ),
        Extracted_XML
          AS (
              SELECT
                BR_Data.timestamp
               ,BR_Data.record.value('(./Record/@id)[1]', 'int') AS record_id
               ,BR_Data.record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'bigint') AS SystemIdle
               ,BR_Data.record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'bigint') AS SQLCPU
              FROM
                BR_Data
             ),
        CPU_Data
          AS (
              SELECT
                Extracted_XML.record_id
               ,ROW_NUMBER() OVER (ORDER BY Extracted_XML.record_id) AS rn
               ,DATEADD(ms, -1 * ((
                                   SELECT
                                    dm_os_sys_info.ms_ticks
                                   FROM
                                    sys.dm_os_sys_info
                                  ) - Extracted_XML.timestamp), GETDATE()) AS EventTime
               ,Extracted_XML.SQLCPU
               ,Extracted_XML.SystemIdle
               ,100 - Extracted_XML.SystemIdle - Extracted_XML.SQLCPU AS OtherCPU
              FROM
                Extracted_XML
             )
             --SELECT * FROM CPU_Data
    SELECT
        @gc = CAST((
                    SELECT
                        CAST(d1.rn AS VARCHAR) + ' ' + CAST(d1.SQLCPU AS VARCHAR) + ','
                    FROM
                        CPU_Data AS d1
                    ORDER BY
                        d1.rn
                   FOR
                    XML PATH('')
                   ) AS VARCHAR(MAX))
       ,@gi = CAST((
                    SELECT
                        CAST(d1.rn AS VARCHAR) + ' ' + CAST(d1.OtherCPU AS VARCHAR) + ','
                    FROM
                        CPU_Data AS d1
                    ORDER BY
                        d1.rn
                   FOR
                    XML PATH('')
                   ) AS VARCHAR(MAX))
OPTION
        (RECOMPILE);

SELECT
    CAST('LINESTRING(' + LEFT(@gc, LEN(@gc) - 1) + ')' AS GEOMETRY)
   ,'SQL CPU %' AS Measure
UNION ALL
SELECT
    CAST('LINESTRING(1 100,2 100)' AS GEOMETRY)
   ,''
UNION ALL
SELECT
    CAST('LINESTRING(' + LEFT(@gi, LEN(@gi) - 1) + ')' AS GEOMETRY)
   ,'Other CPU %'; 