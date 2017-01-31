WITH procedure_tvp_width as
(
    SELECT 
        p.object_id,
        sum(calc.effective_max_length) as [procedure tvp max length]
    from sys.procedures p
    join sys.parameters par
      on p.object_id = par.object_id
    join sys.table_types tt
      on par.user_type_id = tt.user_type_id
    join sys.columns ttc 
      on tt.type_table_object_id = ttc.object_id
    join sys.types t
      on t.user_type_id = ttc.user_type_id
    cross apply 
      (
        select case ttc.max_length
          when -1 then 8000
          else ttc.max_length
        end
      ) as calc(effective_max_length)
    group by p.object_id, p.name
)
select 
    OBJECT_SCHEMA_NAME(ptw.object_id),
    OBJECT_NAME(ptw.object_id),
    Pages.[pages allocated per execution],
    ISNULL(ps.execution_count, 0) as [executions],
    Pages.[pages allocated per execution] * ISNULL(ps.execution_count, 0) as [total pages allocated]    
from procedure_tvp_width ptw
left join sys.dm_exec_procedure_stats ps
  on ps.object_id = ptw.object_id
  and ps.database_id = db_id()
cross apply 
  (
    SELECT 
      CASE 
        WHEN [procedure tvp max length] > 7750 THEN 48
        WHEN [procedure tvp max length] > 6450 THEN 40
        WHEN [procedure tvp max length] > 1930 THEN 32
        ELSE 2
      END
  ) as Pages([pages allocated per execution])
order by ps.execution_count desc