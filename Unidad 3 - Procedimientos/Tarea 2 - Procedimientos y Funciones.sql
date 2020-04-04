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
			SELECT SUM(OD.UnitPrice) AS ImporteVenta
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
	SELECT @columnas = LEFT(@columnas, LEN(@columnas) - 2) -- Quitar último caracter
	PRINT 'SELECT ' + @columnas + ' FROM ' + @nombreTabla
END

GO

EXEC Sp_SelectTabla 'Customers'

GO

/*
	3.- Procedimiento almacenado que reciba la clave de un cliente, regrese en un parámetro de salida
		los nombres de los empleados que lo han atendido.
*/
ALTER PROC Sp_EmpleadosAtendieron
@CusID VARCHAR(5),
@employeesNames VARCHAR(300) output
AS
BEGIN
	DECLARE @table TABLE (empName VARCHAR(30))
	SET @employeesNames = ''

	INSERT INTO @table (empName)
		SELECT  DISTINCT E.FirstName
		FROM Orders O JOIN Employees E ON O.EmployeeID = E.EmployeeID
		WHERE CustomerID = @CusID

	SELECT @employeesNames += empName + ', ' FROM @table
	SELECT @employeesNames = LEFT(@employeesNames, LEN(@employeesNames) - 2)
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
	SELECT @emps = LEFT(@emps, LEN(@emps) - 2)

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

/*
	9.- 
*/