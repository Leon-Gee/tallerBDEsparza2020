USE Northwind

GO

CREATE PROC Sp_NivelJefes
@emp INT,
@nivel INT OUTPUT,
@jefes VARCHAR(300) OUTPUT 
AS
BEGIN
	DECLARE @reportsTo INT

	SET @nivel = 0

	IF @jefes IS NULL
		SELECT @jefes = ''

	SELECT @reportsTo = ReportsTo FROM Employees 
	WHERE EmployeeID = @emp
	
	WHILE @reportsTo IS NOT NULL
	BEGIN
		SELECT @nivel = @nivel + 1

		SELECT @jefes = @jefes +', '+ FirstName +' '+ LastName FROM Employees 
		WHERE EmployeeID = @reportsTo

		SELECT @reportsTo = ReportsTo FROM Employees
		WHERE EmployeeID = @reportsTo
	END
END

GO

CREATE PROC Sp_EmpleadosNivelJefes
AS
BEGIN
	DECLARE @empID INT, @nivel INT, @jefes VARCHAR(300), @nombreEmp VARCHAR(50)

	CREATE TABLE #tabla (nombreEmp VARCHAR(50), nivel INT, jefes VARCHAR(300))
	SELECT @empID = MIN(EmployeeID) FROM Employees

	WHILE @empID IS NOT NULL
	BEGIN
		EXEC Sp_NivelJefes @empID, @nivel OUTPUT, @jefes OUTPUT

		SELECT @nombreEmp = FirstName +' '+ LastName FROM Employees
		WHERE EmployeeID = @empID
		INSERT INTO #tabla VALUES (@nombreEmp, @nivel, @jefes)

		SELECT @nivel = 0, @jefes =''

		SELECT @empID = MIN(EmployeeID) FROM Employees 
		WHERE EmployeeID > @empID
	END
	SELECT * FROM #tabla 
	ORDER BY nivel
END

GO

EXEC Sp_EmpleadosNivelJefes