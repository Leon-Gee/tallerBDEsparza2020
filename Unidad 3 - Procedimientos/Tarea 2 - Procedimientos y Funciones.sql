USE Northwind

GO

/*
	1.- Agregar a la tabla CUSTOMERS el campo Importe de Venta.
		Realizar un SP que llene dicho campo.
*/
ALTER TABLE Customers ADD ImporteVenta NUMERIC(12,2)

GO

CREATE PROC Sp_AddImporte
AS
BEGIN
	DECLARE @CusID VARCHAR(5)
	SELECT @CusID = MIN(CustomerID) FROM Customers

	WHILE @CusID IS NOT NULL
	BEGIN
		UPDATE Customers 
		SET ImporteVenta = (
			SELECT SUM(OD.UnitPrice * OD.Quantity) AS ImporteVenta
			FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
			WHERE O.CustomerID = @CusID
			GROUP BY O.CustomerID
		)
		WHERE CustomerID = @CusID
		
		SELECT @CusID = MIN(CustomerID) FROM Customers
		WHERE CustomerID > @CusID
	END
END

GO

EXEC Sp_AddImporte
GO
SELECT * FROM Customers

GO

/*
	2.- Procedimiento almacenado que reciba el nombre de una tabla y que regrese mediante impresión,
		el select formado con los nombres de todas las columnas de la tabla proporcionada.
*/
CREATE PROC Sp_SelectTabla
@nombreTabla VARCHAR(50)
AS
BEGIN
	DECLARE @columnas VARCHAR(200) = ''
	SELECT @columnas += COLUMN_NAME + ', ' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @nombreTabla
	SELECT @columnas = LEFT(@columnas, LEN(@columnas) - 1) -- Quitar último caracter
	PRINT 'SELECT ' + @columnas + ' FROM ' + @nombreTabla
END

GO

EXEC Sp_SelectTabla 'Customers'

GO

/*
	3.- Procedimiento almacenado que reciba la clave de un cliente, regrese en un parámetro de salida
		los nombres de los empleados que lo han atendido.
*/
CREATE PROC Sp_EmpleadosAtendieron
@CusID VARCHAR(5),
@employeesNames VARCHAR(300) output
AS
BEGIN
	DECLARE @table TABLE (empName VARCHAR(30))
	SET @employeesNames = ''

	INSERT INTO @table (empName)
		SELECT DISTINCT E.FirstName
		FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
		WHERE CustomerID = @CusID

	SELECT @employeesNames += empName + ', ' FROM @table
	SELECT @employeesNames = LEFT(@employeesNames, LEN(@employeesNames) - 1)
END

GO
DECLARE @employees VARCHAR(300) 
EXEC Sp_EmpleadosAtendieron 'VINET', @employees OUTPUT
SELECT @employees

GO

/*
	4.- Procedimiento almacenado que reciba la clave de jefe y regrese una tabla con el nombre del
		jefe enviado y en otra columna, el nombre de los empleados a su cargo.
*/
CREATE PROC Sp_EmpleadoCargos
@empID INT
AS
BEGIN
	DECLARE @emps VARCHAR(200) = ''
	SELECT @emps += LastName + ', '  FROM Employees WHERE ReportsTo = @empID
	SELECT @emps = LEFT(@emps, LEN(@emps) - 1)

	SELECT LastName, @emps AS EmpCargo
	FROM Employees WHERE EmployeeID = @empID
END

GO

EXEC Sp_EmpleadoCargos 2

GO

/*
	5.- Procedimiento almacenado que reciba la clave de una categoría y permita eliminar dicha
		categoría a pesar de que tiene hijos.
*/


/*
	6.- Procedimiento almacenado que reciba como parámetro la clave del empleado y regrese como
		parámetro de salida el total de de ordenes realizadas.
*/
CREATE PROC Sp_OrdenesRealizadas
@Emp INT,
@totalOrdenes INT OUTPUT
AS
BEGIN
	SELECT @totalOrdenes = COUNT(OrderID) FROM Orders WHERE EmployeeID = @Emp
END

GO

DECLARE @totalOrdenes INT
EXEC Sp_OrdenesRealizadas 6, @totalOrdenes OUTPUT
SELECT @totalOrdenes

GO

/*
	7.- Procedimiento almacenado que reciba como parámetro la clave del producto, el año y
		regrese como valor por retorno el total de ordenes realizadas este año.
*/
CREATE PROC Sp_OrdenesPorAñoProducto
@producto INT,
@año INT
AS
BEGIN
	DECLARE @totalOrdenes INT

	SELECT @totalOrdenes = COUNT(O.OrderID)
	FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	WHERE OD.ProductID = @producto AND 
		  YEAR(O.OrderDate) = @año

	RETURN @totalOrdenes
END

GO

DECLARE @totalOrdenes INT
EXEC @totalOrdenes = Sp_OrdenesPorAñoProducto 51, 1996
SELECT @totalOrdenes

GO

/*
	8.- Procedimiento almacenado que reciba todos los campos de la tabla de provedores
		y que realice la actualización o inserción de los datos.
*/
CREATE PROC Sp_RegistraProvedor
@SupplierID INT,
@CompanyName VARCHAR(40),
@ContactName VARCHAR(30),
@ContactTitle VARCHAR(30),
@Address VARCHAR(60),
@City VARCHAR(15),
@Region VARCHAR(15),
@PostalCode VARCHAR(10),
@Country VARCHAR(15),
@Phone VARCHAR(24),
@Fax VARCHAR(24),
@HomePage NTEXT
AS
BEGIN
	IF EXISTS (SELECT SupplierID FROM Suppliers WHERE SupplierID = @SupplierID)
		UPDATE Suppliers SET 
			CompanyName = @CompanyName,
			ContactName = @ContactName,
			ContactTitle = @ContactTitle,
			Address = @Address,
			City = @City,
			Region = @Region,
			PostalCode = @PostalCode,
			Country = @Country,
			Phone = @Phone,
			Fax = @Fax,
			HomePage = @HomePage
		WHERE SupplierID = @SupplierID
	ELSE
		INSERT INTO Suppliers VALUES(
			@SupplierID,
			@CompanyName,
			@ContactName,
			@ContactTitle,
			@Address,
			@City,
			@Region,
			@PostalCode,
			@Country,
			@Phone,
			@Fax,
			@HomePage
		)
END

GO

/*
	9.- Función escalar que reciba una fecha y regrese el importe total de ventas
		de ese día
*/
CREATE FUNCTION Fn_TotalVentasDia (@fecha DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @total INT
	SELECT @total = COUNT(OrderID) FROM Orders WHERE OrderDate = @fecha
	RETURN @total
END

GO

SELECT dbo.Fn_TotalVentasDia('19960719')

GO

/*
	10.- Función escalar que reciba la clave de la orden y regrese el importe total
		 de venta.
*/
CREATE FUNCTION Fn_ImporteOrden (@orden INT)
RETURNS NUMERIC(12,2)
AS
BEGIN
	DECLARE @total NUMERIC(12,2)

	SELECT @total = SUM(OD.UnitPrice * OD.Quantity)
	FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	WHERE O.OrderID = @orden

	RETURN @total
END

GO

SELECT dbo.Fn_ImporteOrden(10248)

GO
 
/*
	11.- Función con tabla en linea que reciba la clave de la orden y regrese todos
		 sus articulos con precio, cantidad y total.
*/
CREATE FUNCTION Fn_DetalleOrden (@orden INT)
RETURNS TABLE
RETURN(
	SELECT ProductID, 
		   UnitPrice,
		   Quantity,
		   (UnitPrice * Quantity) AS Total
	FROM [Order Details] 
	WHERE OrderID = @orden
)

GO

SELECT * FROM dbo.Fn_DetalleOrden(10248)

GO

/*
	12.- Función de tabla en linea que reciba la clave del empleado y regrese la
		 clave, fecha e importe de venta de todas sus ordenes.
*/
CREATE FUNCTION Fn_EmpleadoOrdenes (@Emp INT)
RETURNS TABLE
RETURN(
	SELECT O.OrderID,
		   O.OrderDate,
		   SUM(OD.UnitPrice * OD.Quantity) AS Total
	FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	WHERE EmployeeID = @Emp
	GROUP BY O.OrderID, O.OrderDate
)
GO

SELECT * FROM dbo.Fn_EmpleadoOrdenes(5)

GO

/*
	13.- Función de una tabla de multisentencia (No lleva parámetros de entrada) que 
		 regrese una tabla con el nombre del territorio y los nombres de los empleados
		 que lo atienden.
*/
CREATE FUNCTION Fn_EmpleadosTerritorios()
RETURNS @table TABLE(
			Territorio VARCHAR(50),
			Empleados VARCHAR(300)
		)
AS
BEGIN
	DECLARE @territoryID VARCHAR(50), @employees VARCHAR(300), @territoryName VARCHAR(50)
	SELECT @territoryID = MIN(TerritoryID) FROM Territories

	WHILE @territoryID IS NOT NULL
	BEGIN
		SET @employees = ''

		SELECT DISTINCT @territoryName = TerritoryDescription,
						@employees += E.FirstName + ', '					
		FROM EmployeeTerritories ET JOIN Employees E ON ET.EmployeeID = E.EmployeeID
									JOIN Territories T ON ET.TerritoryID = T.TerritoryID
		WHERE ET.TerritoryID = @territoryID

		INSERT INTO @table VALUES (@territoryName, @employees)

		SELECT @territoryID = MIN(TerritoryID) FROM Territories
		WHERE TerritoryID > @territoryID
	END
	RETURN
END

GO

SELECT * FROM dbo.Fn_EmpleadosTerritorios()

GO

/*
	14.- Función de tabla de multisentencia que reciba la clave del empleado y
		 regrese una tabla con el nombre del empleado, nombre del jefe superior
		 y cuantos niveles esta sobre el empleado
*/
--Función auxiliar para simplificar el problema
CREATE FUNCTION Fn_Profundidad()
returns @table table (EmployeeID INT, Depth INT)
AS
BEGIN
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

	INSERT INTO @table
		SELECT EmployeeID, Depth FROM EmployeesBosses
		ORDER BY Depth
	RETURN
END

GO

CREATE FUNCTION Fn_InfoEmpJefe(@emp INT)
RETURNS @table TABLE (Empleado VARCHAR(20), Jefe VARCHAR(20), nivelPorDebajo INT)
AS
BEGIN
	DECLARE @empleado VARCHAR(20), @jefe VARCHAR(20),
			@nivelEmp INT, @nivelJefe INT, @jefeID INT

	SELECT @empleado = E.FirstName,
		   @jefe = J.FirstName,
		   @jefeID = J.EmployeeID
	FROM Employees E JOIN Employees J ON E.ReportsTo = J.EmployeeID
	WHERE E.EmployeeID = @emp

	SELECT @nivelEmp = Depth FROM dbo.Fn_Profundidad()
	WHERE EmployeeID = @emp
	SELECT @nivelJefe = Depth FROM dbo.Fn_Profundidad()
	WHERE EmployeeID = @jefeID

	INSERT INTO @table VALUES(@empleado, @jefe, (@nivelEmp - @nivelJefe))

	RETURN
END

GO

SELECT * FROM dbo.Fn_InfoEmpJefe(6)

GO

/*
	15.- Función de tabla multisentencia (No lleva parámetros de entrada) que
		 regrese una tabla con el nombre del empleado, años bisiestos que ha
		 vividos y listado de años bisiesto que ha vivido.
*/
--Función auxiliar para simplificar el problema
CREATE FUNCTION Fn_AñosBisiestos (@año INT)
RETURNS @tableAños TABLE (año INT)
AS
BEGIN
	WHILE @año < YEAR(GETDATE())
	BEGIN
		IF ((@año % 4 = 0 AND @año % 100 <> 0) OR @año % 400 = 0)
			INSERT INTO @tableAños VALUES (@año)
		SET @año += 1
	END
	RETURN
END

GO

CREATE FUNCTION Fn_EmpAñosBisiestos()
RETURNS @table TABLE(
			Empleado VARCHAR(20),
			numAños INT,
			listaAños VARCHAR(300)
		)
AS
BEGIN
	DECLARE @emp INT
	DECLARE @empName VARCHAR(20), @años VARCHAR(300),
			@numAños INT, @birthDay INT
	SELECT @emp = MIN(EmployeeID) FROM Employees
	
	WHILE @emp IS NOT NULL
	BEGIN
		SET @años = ''

		SELECT @empName = FirstName, @birthDay = YEAR(BirthDate)
		FROM Employees WHERE EmployeeID = @emp

		SELECT @numAños = COUNT(año),
			   @años += CONVERT(VARCHAR, AÑO) + ', '
		FROM dbo.Fn_AñosBisiestos(@birthDay)
		GROUP BY año

		SELECT @años = LEFT(@años, LEN(@años) - 1)

		INSERT INTO @table VALUES(@empName, @numAños, @años)

		SELECT @emp = MIN(EmployeeID) FROM Employees
		WHERE EmployeeID > @emp 
	END
	RETURN
END

GO

SELECT * FROM dbo.Fn_EmpAñosBisiestos()