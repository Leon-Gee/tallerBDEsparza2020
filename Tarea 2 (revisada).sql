

USE NORTHWIND;
GO
SET LANGUAGE 'English'

/*
	1) consulta con el folio y fecha de la orden cuyo año sea multiplo de 3 y el mes termine con vocal
*/
SELECT [Folio] = ORDERID, [Ano multiplo] = CONVERT(char(4), DATEPART(YY,ORDERDATE)), 
	   [Mes] = CONVERT(char(35), DATENAME(MM,ORDERDATE)) FROM Orders 
WHERE CONVERT(char(35), DATENAME(MM,ORDERDATE)) LIKE '%[aeiou]' AND
	  CONVERT(char(4), DATEPART(YY,ORDERDATE)) % 3 = 0;

/*
	2) consulta con el folio de la orden, fecha y nombre del empleado que se hayan realizado los dias lunes, miércoles y viernes
*/
SELECT [Folio] = O.ORDERID, [Ano] = CONVERT(CHAR(35), DATENAME(DW,O.ORDERDATE)),[Nombre Empleado] = E.FIRSTNAME + ' ' + E.LASTNAME 
FROM Orders O INNER JOIN Employees E ON E.EmployeeID = O.EmployeeID  
WHERE CONVERT(char(35), DATENAME(DW,O.ORDERDATE)) LIKE 'Monday' OR
	  CONVERT(CHAR(35), DATENAME(DW,O.ORDERDATE)) LIKE 'wednesday' OR 
	  CONVERT(CHAR(35), DATENAME(DW,O.ORDERDATE)) LIKE 'Thursday'

/*
	3) consulta con las primeras 10 ordenes de 1997
*/
SELECT TOP 10 [FOLIO] = ORDERID FROM ORDERS WHERE CONVERT(CHAR(35), YEAR(ORDERDATE)) = 1997

/*
	4) consulta con el nombre empleados y nombre de su jefe que vivan en un blvd y no tengan una region asignada
*/
SELECT [Nombre Completo] = E.FIRSTNAME + ' ' + E.LASTNAME,[Nombre Jefe] = F.FIRSTNAME + ' ' + F.LASTNAME, E.ReportsTo  
FROM Employees E INNER JOIN Employees F ON F.EmployeeID = E.ReportsTo 
WHERE E.Address LIKE '%Blvd%' AND E.Region IS NULL AND
	  F.Address LIKE '%Blvd%' AND F.Region IS NULL;

/*
	5) consulta con el nombre del producto, nombre del proveedor y nombre de la categoria.
       mostrar solo los proveedores que no tengan fax y que si tengan homepage
*/
SELECT [Nombre del producto] = P.PRODUCTNAME, [Nombre del proovedor] = S.CONTACTNAME,
	   [Nombre de la categoria] = C.CATEGORYNAME 
FROM PRODUCTS P INNER JOIN SUPPLIERS S ON S.SUPPLIERID = P.SUPPLIERID 
				INNER JOIN CATEGORIES C ON C.CATEGORYID = P.CATEGORYID
WHERE S.FAX IS NULL AND S.HomePage IS NOT NULL;

/*
	6) consulta con el nombre del empleado y nombre del territorio que atiende
*/
SELECT [Nombre de empleado] = E.FIRSTNAME + ' ' + E.LASTNAME, [Nombre del territorio del empleado] = Y.TerritoryDescription
FROM EmployeeTerritories T INNER JOIN Employees E ON E.EmployeeID = T.EMPLOYEEID 
						   INNER JOIN Territories Y ON Y.TerritoryID = T.TerritoryID;

SELECT [Nombre de empleado] = E.FIRSTNAME + ' ' + E.LASTNAME, [Nombre del territorio del empleado] = Y.TerritoryDescription
FROM EmployeeTerritories T INNER JOIN Employees E ON E.EmployeeID = T.EMPLOYEEID 
						   INNER JOIN Territories Y ON Y.TerritoryID = T.TerritoryID;

/*
	7) consulta con el folio de la orden, meses transcurridos de la orden, nombre del empleado que hizo la orden
	   mostrar solo las ordenes de los empleados que vivan en el pais “usa” y que el codigo postal contenga un 2
*/ 
SELECT O.ORDERID, [Meses transcurridos desde la orden] = DATEDIFF(MM, O.OrderDate, GETDATE()), [Nombre del empleado]=E.FirstName + ' ' + E.LastName
FROM ORDERS O INNER JOIN Employees E ON E.EmployeeID = O.EmployeeID
WHERE E.Country LIKE 'USA' AND E.PostalCode LIKE '%2%';

/*
	8) consulta con el folio de la orden, nombre del producto e importe de venta.
	   mostrar solo las ordenes de los productos cuya categeria contenga dos vocales seguidas
*/
SELECT  [Folio] =  O.ORDERID, [Nombre del producto] =  P.ProductName, [Importe] = D.Quantity * D.Quantity 
FROM ORDERS O INNER JOIN [Order Details] D ON D.OrderID = O.OrderID
			  INNER JOIN PRODUCTS P ON P.ProductID = D.ProductID;

/*
	9) consulta con el nombre del empleado, nombre del territorio que atiende.
	   mostras solo los empleados que el territorio este en una region que empiece con vocal y termine con consonante
*/
SELECT [Nombre de empleado] = E.FIRSTNAME + ' ' + E.LASTNAME, [Nombre del territorio] = T.TerritoryDescription,
	    R.RegionDescription
FROM Employees E INNER JOIN EmployeeTerritories Y ON Y.EmployeeID = E.EmployeeID
				 INNER JOIN Territories T ON T.TerritoryID = Y.TerritoryID
				 INNER JOIN Region R ON R.RegionID = T.RegionID
WHERE R.RegionDescription LIKE '[AEIOU]%' AND R.RegionDescription LIKE '%[^aeiou]';

/*
	9) consulta con el folio de la orden, fecha de la orden, nombre del empleado, edad que tenia el empleado cuando hizo la orden
*/
SELECT O.ORDERID, O.OrderDate, [Nombre de empleado] = E.FIRSTNAME + ' ' + E.LASTNAME,
	  [Edad cuando se realizo la orden] = DATEDIFF(YY,E.BirthDate, O.OrderDate)
FROM ORDERS O INNER JOIN EMPLOYEES E ON E.EmployeeID = O.EmployeeID;