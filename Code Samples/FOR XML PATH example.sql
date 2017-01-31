
select last_name,
	STUFF(
		(select ',' + last_name
			from ei.dbo.employee_master
			where term = 0
			order by last_name
				FOR XML PATH('')
		),1,1,'') as displayname
from ei.dbo.employee_master
where last_name = 'denney'
group by last_name


--SELECT actionid, assignmentDate, reassigned,
--  (SELECT DisplayName + ', ' 
--	 FROM @temp t2
--	 WHERE t2.ActionID = t1.ActionId
--		and t2.assignmentDate = t1.assignmentDate
--		and t2.reassigned = t2.reassigned
--	 ORDER BY DisplayName
--	   FOR XML PATH('') ) AS DisplayName
--FROM @temp t1
--GROUP BY actionid, assignmentDate, reassigned