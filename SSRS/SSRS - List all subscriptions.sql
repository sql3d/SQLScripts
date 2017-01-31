USE REPORTSERVER

GO

DECLARE @Subscriptions TABLE
	(
		 Report_OID   UNIQUEIDENTIFIER
		 ,ToList      VARCHAR(8000)
		 ,CCList      VARCHAR(8000)
		 ,BCCList     VARCHAR(8000)
		 ,SubjectLine VARCHAR(8000)
	)
	
DECLARE @ExtensionSettings XML

DECLARE @Report_OID UNIQUEIDENTIFIER

DECLARE @idoc INT

DECLARE SubscriptionList CURSOR FOR
	SELECT Report_OID
		   ,ExtensionSettings
	FROM   subscriptions;
	
OPEN SubscriptionList

FETCH NEXT FROM SubscriptionList INTO @Report_OID, @ExtensionSettings

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC Sp_xml_preparedocument @idoc OUTPUT
									,@ExtensionSettings

		INSERT INTO @Subscriptions
			SELECT @Report_OID
				   ,[TO]
				   ,[CC]
				   ,[BCC]
				   ,[Subject]
			FROM   (SELECT *
					FROM   OPENXML (@idoc, '/ParameterValues/ParameterValue')
							  WITH (Name   NVARCHAR(100) 'Name'
									,Value NVARCHAR(100) 'Value')) AS SourceTable
				   PIVOT ( Max(value)
						 FOR [Name] IN ([TO]
										,[BCC]
										,[CC]
										,[Subject]) ) AS pivottable

		EXEC Sp_xml_removedocument @idoc

		FETCH NEXT FROM SubscriptionList INTO @Report_OID, @ExtensionSettings
	END

CLOSE SubscriptionList

DEALLOCATE SubscriptionList

SELECT c.path
	   ,c.name
	   ,s.Tolist
	   ,s.cclist
	   ,s.bcclist
	   ,s.subjectline
FROM   Catalog c
	   INNER JOIN @Subscriptions s ON c.ItemID = s.Report_OID
ORDER  BY [path],Name 
