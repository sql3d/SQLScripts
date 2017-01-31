SELECT CASE
		   WHEN webs.fullurl = '' THEN 'Portal Site'
		   ELSE webs.fullurl
	   END             AS [Site Relative Url]
	   ,webs.Title     AS [Site Title]
	   ,CASE tp_servertemplate
			WHEN 104 THEN 'Announcement'
			WHEN 105 THEN 'Contacts'
			WHEN 108 THEN 'Discussion Boards'
			WHEN 101 THEN 'Document Library'
			WHEN 106 THEN 'Events'
			WHEN 100 THEN 'Generic List'
			WHEN 1100 THEN 'Issue List'
			WHEN 103 THEN 'Links List'
			WHEN 109 THEN 'Image Library'
			WHEN 115 THEN 'InfoPath Form Library'
			WHEN 102 THEN 'Survey'
			WHEN 107 THEN 'Task List'
			ELSE 'Other'
		END            AS Type
	   ,tp_title       'Title'
	   ,tp_description AS Description
	   ,tp_itemcount   AS [Total Item]
FROM   lists
	   INNER JOIN webs ON lists.tp_webid = webs.Id
WHERE  tp_servertemplate IN (104, 105, 108, 101,
							 106, 100, 1100, 103,
							 109, 115, 102, 107, 120)
ORDER  BY tp_itemcount DESC 
