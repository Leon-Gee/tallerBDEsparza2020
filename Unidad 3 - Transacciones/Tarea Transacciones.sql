USE Northwind

GO

-- Ejercicio 1
CREATE PROC sp_ordenes 
@clave INT
AS
SELECT * FROM Orders WHERE OrderID = @clave
GO
CREATE VIEW vw_region
AS
SELECT RegionID, RegionDescription FROM Region
GO
CREATE VIEW vw_empleados
AS
SELECT EmployeeID, FirstName, LastName FROM Employees
GO


-- Ejercicio 2
ALTER TABLE region ADD tipo CHAR(1)
GO
SELECT RegionDescription, tipo FROM Region
GO
CREATE VIEW vw_regionTipo
AS
SELECT RegionDescription, tipo FROM Region
GO

-- Ejercicio 3

BEGIN TRAN
UPDATE Employees SET FirstName = 'Jose' WHERE EmployeeID = 1
--Poner la instrucción dentro de una transacción

ROLLBACK TRAN

GO

-- Ejercicio 4


BEGIN TRAN

	UPDATE Products SET UnitPrice = 12.23 WHERE ProductID = 1
	UPDATE Employees SET FirstName = 'Ana' WHERE EmployeeID = 2
	INSERT INTO Region VALUES (5, 'Sur')

SAVE TRAN P1

	INSERT INTO Categories VALUES('Lacteos', NULL, NULL)
	UPDATE Customers SET Address = 'Av. Obregón 43' WHERE CustomerID = 'PARIS'

SAVE TRAN P2

	UPDATE Region SET RegionDescription = 'Centro' WHERE RegionID = 4

ROLLBACK TRAN P2

	UPDATE Suppliers set Address = 'Av. Zapata 45' WHERE SupplierID = 2

ROLLBACK TRAN P1

	INSERT INTO Shippers VALUES ('Estafeta', NULL)

COMMIT WORK 

--Consulta de registros involucrados
	SELECT ProductID, UnitPrice FROM Products  WHERE ProductID = 1
	SELECT EmployeeID, FirstName FROM Employees WHERE EmployeeID = 2
	SELECT * FROM Region WHERE RegionDescription = 'Sur'

	SELECT * FROM Categories WHERE CategoryName = 'Lacteos'
	SELECT CustomerID, Address FROM Customers WHERE CustomerID = 'PARIS'

	SELECT RegionID, RegionDescription FROM Region WHERE RegionID = 4

	SELECT SupplierID, Address FROM Suppliers WHERE SupplierID = 2
	
	SELECT * FROM Shippers WHERE CompanyName = 'Estafeta'

-- Ejercicio 5

	SELECT @@TRANCOUNT
BEGIN TRAN T1
	SELECT @@TRANCOUNT 
BEGIN TRAN T2
	SELECT @@TRANCOUNT 
SAVE TRAN PUNTO1
	SELECT @@TRANCOUNT 
BEGIN TRAN T3
	SELECT @@TRANCOUNT 
SAVE TRAN PUNTO2
	SELECT @@TRANCOUNT 
BEGIN TRAN T4
	SELECT @@TRANCOUNT 
ROLLBACK TRAN PUNTO2
	SELECT @@TRANCOUNT 
ROLLBACK TRAN PUNTO1
	SELECT @@TRANCOUNT 
COMMIT TRAN
	SELECT @@TRANCOUNT 

