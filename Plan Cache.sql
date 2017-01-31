/*
QUERY to see what is in the PLAN CACHE

*/

SELECT            pvt.bucketid, CONVERT(nvarchar(19), pvt.cacheobjtype) as cacheobjtype, pvt.objtype, 
                                    CONVERT(int, pvt.objectid)as object_id, CONVERT(smallint, pvt.dbid) as dbid, 
                                    CONVERT(smallint, pvt.dbid_execute) as execute_dbid, 
                                    CONVERT(smallint, pvt.user_id) as user_id, 
                                    pvt.refcounts, pvt.usecounts, pvt.size_in_bytes / 8192 as size_in_bytes, 
                                    CONVERT(int, pvt.set_options) as setopts, CONVERT(smallint, pvt.language_id) as langid, 
                                    CONVERT(smallint, pvt.date_format) as date_format, CONVERT(int, pvt.status) as status, 
                                    CONVERT(bigint, 0), CONVERT(bigint, 0), CONVERT(bigint, 0), 
                                    CONVERT(bigint, 0), CONVERT(bigint, 0), 
                                    CONVERT(int, LEN(CONVERT(nvarchar(max), fgs.text)) * 2), CONVERT(nvarchar(3900), fgs.text)

            FROM (SELECT ecp.*, epa.attribute, epa.value 
                        FROM sys.dm_exec_cached_plans ecp 
                OUTER APPLY sys.dm_exec_plan_attributes(ecp.plan_handle) epa) as ecpa 
                   PIVOT (MAX(ecpa.value) for ecpa.attribute IN ([set_options],[objectid],[dbid],
                          [dbid_execute],[user_id],[language_id],[date_format],[status])) as pvt 
                       OUTER APPLY sys.dm_exec_sql_text(pvt.plan_handle) fgs 
         WHERE cacheobjtype like 'Compiled%' 
         AND text NOT LIKE '%filetable%' 
         AND text NOT LIKE '%fulltext%' 
         AND pvt.dbid > 4;