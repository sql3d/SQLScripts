WITH EmployeeHierarchy (employee_num,FullName,Supervisor) AS
(
   -- Base case
   SELECT Employee_num,
		FullName,
		Supervisor
      
   FROM tAllEmployee
   WHERE Supervisor = 'Hancock,Rex'

   UNION ALL
	-- Recursive step
   SELECT	e.employee_Num,
		e.FullName,
		eh.FullName as Supervisor
	FROM tAllEmployee e
      INNER JOIN EmployeeHierarchy eh ON
         e.Supervisor = eh.FullName
)



-- Recursive Down
;WITH cteTable (colLevel, colID, colParentID, col1, col2)  -- Creates the "temporary" table to store the recursive data
AS
	(
		-- Anchor Statement
		SELECT 0 as ColLevel  -- artificial number to tell at what level you are.  0 begin top level
			, t1.colID
			, t1.ColParentID
			, t1.col1
			, t1.col2
		FROM tableName t1
		WHERE t1.colID = <someValue>
		
		UNION ALL
		
		-- Recursion Statement
		SELECT 
			cteTable.colLevel + 1 -- increases the further down you go.
			, t2.colID
			, t2.ColParentID
			, t2.col1
			, t2.col2
		FROM tableName t2
			INNER JOIN cteTable ON t2.colParentID = cteTable.colID
	)
SELECT colLevel, colID, colParentID, col1, col2
FROM cteTable;



-- Recursive Down
;WITH cteEmployees (EmployeeLevel, EmployeeID, ReportsTo, LastName, FirstName)
AS
	(
		SELECT 0 AS EmployeeLevel
			, EmployeeID
			, ReportsTo
			, LastName
			,FirstName
		FROM dbo.Employees e1
		WHERE e1.EmployeeID = ?
		
		UNION ALL
		
		SELECT cte.EmployeeLevel + 1
			, EmployeeID
			, ReportsTo
			, LastName
			, FirstName
		FROM dbo.Employees e2
			INNER JOIN cteEmployees cte ON e2.ReportsTo = cte.EmployeeID		
	)
SELECT EmployeeLevel	
	, EmployeeID
	, ReportsTo
	, LastName
	, FirstName
FROM cteEmployees;