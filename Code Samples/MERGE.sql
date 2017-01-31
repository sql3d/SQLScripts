


;MERGE INTO dbo.TableA AS destinationTable
USING
	(
	SELECT DISTINCT
		ColA
        ,ColB
        ,ColC
	FROM dbo.TableC AS C
	WHERE filter
	) AS SourceTable (ColA, ColB, ColC)
	ON destinationTable.ColA = SourceTable.ColA
WHEN MATCHED THEN
    UPDATE SET destinationTable.ColB = SourceTable.ColB
WHEN NOT MATCHED THEN
	INSERT
    	(
    		ColA
            ,ColB
    	)
	VALUES (SourceTable.ColA, 
		SourceTable.ColB)

OUTPUT INSERTED.ColA, Inserted.ColB, SourceTable.ColC		  
	INTO #tempOutput
    	(
    		ColA
            ,ColB
            ,ColC
    	);