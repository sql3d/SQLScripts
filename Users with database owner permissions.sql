

create table #tmp (databaseName varchar(100), loginName varchar(100));


EXECUTE sp_msforeachdb '
	Insert into #tmp (databaseName, loginName)
		select  ''[?]'' as DatabaseName,
             case 
				when left(u.name, 4) <> ''CORP'' then ''CORP\'' + u.name
				else u.name
             end as loginName
            --,case when (r.principal_id is null) then ''public'' else r.name end
            --,l.default_database_name
            --,u.default_schema_name
            --,u.principal_id
    from [?].sys.database_principals u
        left join ([?].sys.database_role_members m join [?].sys.database_principals r on m.role_principal_id = r.principal_id) 
            on m.member_principal_id = u.principal_id
        left join [?].sys.server_principals l on u.sid = l.sid
        where u.type in (''U'', ''G'')
			and r.name = ''db_owner''
			and u.name <> ''dbo''
			and u.name not like ''%[_]%''
			and u.name not like ''NT AUTHORITY%''
			and u.name not like ''BUILTIN%''
			'  
			
			  
select *
from #tmp;

drop table #tmp;

