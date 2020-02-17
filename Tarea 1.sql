USE Northwind
SET LANGUAGE 'English'

/*
	1) mostrar el nombre completo del empleado imprimiendo el nombre
	   en un renglon y el apellido en otro
*/
SELECT FirstName + CHAR(13) + LastName FROM Employees --CHAR(13) = Salto de linea

/*
	2) mostrar los empleados que tengan una antiguedad menor a 15 años
*/
SELECT * FROM Employees 
WHERE DATEDIFF(YY, HireDate, GETDATE()) > 15

/*
	3) consulta con el nombre del empleado y la fecha de nacimiento, debe aparece de
	   la siguiente forma cada empleado:
	   'JOSE PEREZ NACIO EL DIA 2 DE FEBRERO DE 1998'
*/
SELECT FirstName+' '+LastName+'nació el día '+
	   DATENAME(DAY, BirthDate)+' de '+DATENAME(MONTH, BirthDate)+' de '+DATENAME(YEAR, BirthDate)
FROM Employees

/*
	4) consulta con la clave y fecha de la orden que se hayan realizado hace 12 años
*/
SELECT OrderID, OrderDate, DATEDIFF(YY, OrderDate, GETDATE()) FROM ORDERS
WHERE DATEDIFF(YY, OrderDate, GETDATE()) = 12 

/*
	5) Consulta con las clave de la orden y fecha de la orden. mostrar solamente las
	   ordenes que se hayan realizado los fines de semana
*/
SELECT OrderID, OrderDate, DATENAME(WEEKDAY, OrderDate) FROM ORDERS
WHERE DATENAME(WEEKDAY, OrderDate) = 'Saturday' OR
	  DATENAME(WEEKDAY, OrderDate) = 'Sunday'

/*
	6) mostrar en una sola columna la siguiente información de cada orden :
	   'la orden 1 fue realizada el dia lunes de la fecha 23 de octubre de 2008'
*/
SELECT 'La orden '+ CONVERT(VARCHAR, OrderID)+' fue relizada el día '+
	   DATENAME(WEEKDAY, OrderDate)+' de la fecha '+
	   DATENAME(DAY, OrderDate)+' de '+DATENAME(MONTH, OrderDate)+' de '+DATENAME(YEAR, OrderDate)
FROM Orders

/*
	7) consulta con los clientes cuyo nombre sea mayor a 10 caracteres.
*/
SELECT FirstName FROM Employees
WHERE LEN(FirstName) > 10

/*
	8) consulta con los productos que su nombre empieza con vocal
*/
SELECT * FROM Products
WHERE ProductName LIKE '[aeiou]%'

/*
	9) consulta con los empleados que su apellido empiece con consonante.
*/
SELECT * FROM Employees
WHERE FirstName LIKE '[^aeiou]%'

/*
	10) consulta con todas las ordenes que se hayan realizado en los meses que inicial con vocal.
*/
SELECT OrderID, DATENAME(MONTH, OrderDate) FROM Orders
WHERE DATENAME(MONTH, OrderDate) LIKE '[aeiou]%'

/*
	11) consulta con los nombre de producto que tengan solamente 3 vocales
*/
SELECT ProductName FROM Products
WHERE Len(replace(replace(replace(replace(ProductName,'a',''),'e',''),'o',''),'u','')) = (len(ProductName) - 3)

/*
	12) consulta con los fechas de las ordenes cuyo año sea multiplo de 3
*/
SELECT YEAR(OrderDate)  FROM Orders
WHERE YEAR(OrderDate)%3 = 0

/*
	13) consulta con las ordenes que se hayan realizado en sabado y domingo, y que hayan sido 
		realizadas por los empleado 1, 2 y 5.
*/
SELECT OrderID, EmployeeID, DATENAME(WEEKDAY, OrderDate) FROM ORDERS
WHERE DATENAME(WEEKDAY, OrderDate) = 'Saturday' OR
	  DATENAME(WEEKDAY, OrderDate) = 'Sunday'	AND
	  (EmployeeID = 1 OR EmployeeID = 2 OR EmployeeID = 5)

	  --***REVISAR
/*	
	14) consulta con las ordenes que no tengan compañia de envio o que se hayan realizado en 
		el mes de enero
*/
SELECT [Numero de mes de la orden] = MONTH(OrderDate),ShipName FROM Orders WHERE MONTH(OrderDate) = 1 AND ShipName IS NULL

/*
	15) consulta con las 10 ultimas ordenes de 1997
*/
SELECT TOP 10 * FROM Orders WHERE YEAR(OrderDate) = 1997 ORDER BY OrderDate DESC

/*
	16) consulta con los 10 productos mas caros del proveedor 1
*/
SELECT TOP 10 * FROM Products WHERE SupplierID = 1 ORDER BY UnitPrice DESC

/*
	17) consulta con los 4 empleados con mas antiguedad
*/
SELECT TOP 4 * FROM Employees ORDER BY HireDate ASC
 
	--***Revisar
/*
	18) consulta con empleado con una antiguedad de 10, 20 o 30 años y con una edad mayor a 30, o con los 
		empleados que vivan en un blvd y no tengan una region asignada
*/
SELECT * FROM Employees WHERE ((DATEDIFF(YY, HireDate, GETDATE()) = 10 OR
							    DATEDIFF(YY, HireDate, GETDATE()) = 20 OR
							    DATEDIFF(YY, HireDate, GETDATE()) = 30) AND
							    DATEDIFF(YY, BirthDate, GETDATE()) = 30) OR
							   (Address LIKE '%Blvd%' AND Region IS NOT NULL)

	--***Revisar
/*
	19) consulta con las ordenes el codigo postal de envio tenga solamente letras
*/
SELECT OrderID, ShipPostalCode FROM Orders WHERE ShipPostalCode NOT LIKE '%[0-9]%'

/*
	20) consulta con las ordenes que se hayan realizado en 1996 y en los meses que inicien con vocal de ese año
*/
SELECT OrderID, DATENAME(MONTH, OrderDate) FROM Orders
WHERE YEAR(OrderDate) = 1996 AND DATENAME(MONTH, OrderDate) LIKE '[aeiou]%'