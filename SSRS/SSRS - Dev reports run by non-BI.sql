
declare @timestart datetime
set @timestart = GETDATE() - 7


select    
	b.[path] [Report Path], 
	b.name [Report Name], 
	u.UserName,
	b.CreationDate as [RDL Created],
	b.ModifiedDate as [RDL Last Modified], 
	MAX(a.TimeStart) [Report Last Ran],
	count(*) [Execution Count (Last 7 Days)],
	COUNT(distinct a.username) [Nbr of Users],
	case
		when prod.Name IS null then 0
		else 1		
	end as [Exists on Prod]
from ReportServer.dbo.ExecutionLog a 
	inner join ReportServer.dbo.[catalog] as b on a.ReportID = b.ItemID 
	inner join ReportServer.dbo.[Users] U on b.ModifiedByID = u.UserID
	left join csan0db070.ReportServer.dbo.[catalog] as prod on b.Name = prod.Name
where 1=1
	and timeStart > @timestart --'Dec 1 2011' 
	and b.ModifiedDate < (GETDATE() - 14)
	and b.CreationDate < (GETDATE() - 30)
	and timedataretrieval > 0
	and a.UserName <> 'CORP\_csan1sql'
	and a.UserName COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN 
		(
			SELECT 'CORP\' + sAMAccountName AccountName
			FROM OPENQUERY(ADSI,
				'SELECT sAMAccountName
					FROM ''LDAP://ou=CCI,DC=CORP,DC=COX,DC=COM''
					WHERE MemberOf=''CN=CSAN0RS_ITBIGroup,OU=Groups,OU=San Diego,OU=CCI,DC=CORP,DC=COX,DC=com''
				')
		)
GROUP BY b.path, b.name, b.modifiedDate, b.CreationDate , u.UserName, prod.Name
HAVING count(*) > 7
ORDER BY b.Path

