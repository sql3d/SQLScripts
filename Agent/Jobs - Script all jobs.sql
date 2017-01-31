USE msdb
go

SELECT  sj.name
	  ,sj.enabled
	  ,sc.name AS Category_Name
	  ,sj.description	  
	  ,sl.NAME
	  --,db_owner(sj.owner_sid)
	  ,sj.notify_level_eventlog
	  ,sj.notify_level_email
	  ,sj.notify_level_netsend
	  ,sj.notify_level_page
	  ,sj.notify_email_operator_id
	  ,so.name AS Notify_Email_Operator
	  ,sj.notify_netsend_operator_id
	  ,sj.notify_page_operator_id
	  ,sj.delete_level
	  ,sj.date_created
	  ,sj.date_modified
	  ,sj.version_number
	  ,sc.category_id
	  ,sc.category_class
	  ,sc.category_type
	  
FROM dbo.sysjobs AS sj
    INNER JOIN dbo.syscategories AS sc ON sj.category_id = sc.category_id
    INNER JOIN master.dbo.syslogins sl ON sl.sid = sj.owner_sid
    LEFT JOIN dbo.sysoperators AS so ON sj.notify_email_operator_id = so.id
ORDER BY sj.ENABLED DESC--, sj.name ASC