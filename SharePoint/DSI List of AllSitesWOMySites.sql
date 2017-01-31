select Webs.FullUrl As [Site Url], 
Title AS [WSS Site Title]
from webs
where fullurl NOT LIKE 'MySite%' 
AND fullUrl NOT LIKE 'personal%'
