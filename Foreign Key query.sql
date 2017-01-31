select f.name
     , i.name
     , object_name(i.object_id) as tablename
     , i.is_unique,i.is_primary_key
     , i.type_desc
     , f.key_index_id 
 from sys.foreign_keys f 
   join sys.indexes i 
     on i.object_id = f.referenced_object_id 
     and i.index_id = f.key_index_id
     
     
/*

select object_id
     , name
     , index_id
     , type
     , type_desc
     , is_unuique
     , data_space_id
     , ignore_dup_key
     , is_primary_key
     , is_unique_constraint
 from sys.indexes
 where object_id = object_id('tablename') 
 or object_id = object_id('fktable')
 
*/