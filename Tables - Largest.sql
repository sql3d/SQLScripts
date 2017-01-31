select name=object_schema_name(object_id) + '.' + object_name(object_id)
, rows=sum(case when index_id < 2 then row_count else 0 end)
, reserved_kb=8*sum(reserved_page_count)
, data_kb=8*sum( case 
     when index_id<2 then in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count 
     else lob_used_page_count + row_overflow_used_page_count 
    end )
, index_kb=8*(sum(used_page_count) 
    - sum( case 
           when index_id<2 then in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count 
        else lob_used_page_count + row_overflow_used_page_count 
        end )
     )    
, unused_kb=8*sum(reserved_page_count-used_page_count)
from sys.dm_db_partition_stats
where object_id > 1024
group by object_id
order by 
--rows desc
data_kb desc
-- reserved_kb desc
-- data_kb desc
-- index_kb desc
-- unsed_kb desc