
--  Find Untrusted Check Constraints
select 
	'ALTER TABLE [' + s.name + '].[' + o.Name + '] WITH CHECK CHECK CONSTRAINT [' + i.name + '];'
from sys.check_constraints i 
	INNER JOIN sys.objects o ON i.parent_object_id = o.object_id 
	INNER JOIN sys.schemas s ON o.schema_id = s.schema_id 
WHERE i.is_not_trusted = 1 
	AND i.is_not_for_replication = 0
order by s.name, o.name, i.name;

-- Find untrusted Foreign Keys
SELECT 
	'ALTER TABLE [' + s.name + '].[' + o.Name + '] WITH CHECK CHECK CONSTRAINT ' + i.name + ';'
from sys.foreign_keys i 
	INNER JOIN sys.objects o ON i.parent_object_id = o.object_id 
	INNER JOIN sys.schemas s ON o.schema_id = s.schema_id 
WHERE i.is_not_trusted = 1 
	AND i.is_not_for_replication = 0
order by s.name, o.name, i.name;
	
	


-- Find tables without PK
Select AllTables.Name
From   
	(
		Select Name, id 
		From   sysobjects 
		Where  xtype = 'U'
	) As AllTables
	Left Join 
	(
		Select parent_obj
		From   sysobjects 
		Where  xtype = 'PK'
	) As PrimaryKeys On AllTables.id = PrimaryKeys.parent_obj
Where  PrimaryKeys.Parent_Obj Is NULL
Order By AllTables.Name;




select *
from sys.objects