SELECT
      ST.dbid,
      st.text,
      cp.usecounts,
      cp.size_in_bytes,
      qp.query_plan,
      cp.cacheobjtype,
      cp.objtype,
      cp.plan_handle,
      qp.number
FROM sys.dm_exec_cached_plans cp
      CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
      CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
where 1=1
	and st.dbid = 40 
	--	or st.dbid is null
	--and st.text like '%usp_SearchEventsMain%'
	--and st.text like '%Event%'
order by usecounts desc;     

      --select DB_ID('emt')   = 40
	
      
      