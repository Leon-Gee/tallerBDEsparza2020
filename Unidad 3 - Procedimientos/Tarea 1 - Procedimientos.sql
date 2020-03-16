USE Northwind


WITH EmployeesBosses(
		EmployeeID,
		LastName,
		ReportsTo,
		BossLastName,
		Depth)
AS(
	SELECT EmployeeID,
		   LastName,
		   ReportsTo,
		   LastName,
		   0
	FROM Employees
	WHERE ReportsTo IS NULL

	UNION All

	SELECT E.EmployeeID,
		   E.LastName,
		   E.ReportsTo,
		   EB.LastName ,
		   EB.Depth + 1
	FROM Employees E INNER JOIN EmployeesBosses EB ON E.ReportsTo = EB.EmployeeID
)
SELECT LastName, BossLastName, Depth FROM EmployeesBosses
ORDER BY Depth