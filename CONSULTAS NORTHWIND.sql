SELECT * FROM CATEGORIES 

SELECT CompanyName, Address FROM Customers

SELECT 'nombre de la compania' = CompanyName, address as 'direccion' FROM Customers

SELECT nombre = 'El nombre es ' + FirstName FROM Employees

--PUBS--

--Pentiumwor--

SELECT PRODUCTNAME, unitprice, '10%' = UNITPRICE *1.1,
'20%' = UNITPRICE *1.2 ,'30%' = UNITPRICE *1.3 
from Products
select PRODUCTNAME, unitprice, 'aumento 20 pesos' = unitprice + 20 from products;
select power(3,2);
select Nombre = 'Nombre' + productname, power(unitprice,2) from products;
select [Precio del producto] = productname,[Precio unitario] = unitprice,'Raiz cuadrada' = sqrt(unitprice) from products;
select ascii('a');
select ascii('A');
--3 formas de sacar espacios--
select firstname + char(32) + ' ' + space(1) + lastname from employees;

select SUBSTRING(firstname,1,1) + '.' + space(1) + lastname from employees;
select upper(firstname + '.' + lastname) from Employees;

select lastname,
nombre = substring(lastname, len(lastname),1),
nombre = right(lastname,1)
from Employees;

--no see puede concatenar texto con un campo numerico de manera directa--
select 'el precio es' + unitprice from products

select 'el precio es ' + ltrim(str(unitprice,50,2)) from products;

select 'el precio es' + convert(varchar(100), unitprice) from products;
select 'el precio es' + cast(unitprice as varchar(10)) from products;

select 'la fecha de la orden es' +convert(varchar(11), orderdate) from orders;

select [Nombre y fecha de nacimiento] = firstname + ' ' + lastname + ' nacio el dia ' +
datename(dw,birthdate) + ' ' + 
datename(dd,birthdate) + ' de ' +
datename(mm,birthdate ) + ' de ' +
convert(char(4), datepart(yy,birthdate))
from Employees;

select getdate();

select EmployeeID, firstname, birthdate, datediff(yy,birthdate,getdate()), year(getdate() - year(birthdate)) from Employees

select firstname, hiredate, datediff(yy,hiredate,getdate()) from Employees;

select firstname,birthdate,hiredate, datediff(yy,birthdate,hiredate) from Employees;

select * from products where unitprice <20;

select * from orders where orderdate > '01-01-1998';

select firstname, birthdate, edad = datediff(yy,birthdate,getdate())
from Employees where datediff(yy,birthdate,getdate())<=55;

select * from employees where len(lastname) > 8;

select * from products where unitprice between 10 and 50;

select * from orders where orderdate not between '01-01-97' and '3-31-97'

select firstname, birthdate from Employees where year(birthdate) between 1950 and 1959

select * from products where unitprice in (18,25,30)

select * from orders where month(orderdate) in (1,3,12);



--Funcones de converción
select 'El precio es ' + ltrim(str(UnitPrice,50,8)) from Products; --Solo int a char

select 'El precio es ' + convert(varchar, UnitPrice ) from Products;

select 'El precio es ' + cast(UnitPrice as varchar ) from Products;

--Funciones para manejo de fecha
select getdate();
select datediff()
select datename()
select datepart()
select day()
select month()
select year()
select getutcdate()

select (FirstName+' '+LastName+' nacio el día ') +
	datename(dw, BirthDate)+' '+
	datename(dd, BirthDate)+' de '+
	datename(mm, BirthDate)+' de '+
	convert(char(4), datepart(yy,BirthDate))
from Employees

select datename(dw, getdate())

--Años vividos
select EmployeeID, FirstName, BirthDate,
		datediff(yy, BirthDate, getdate()),
		year(getdate()) - year(BirthDate)
From Employees
--nombre y antiguedad
select FirstName, HireDate,
		datediff(yy, HireDate, getdate())
From Employees
--la edad con la que entró a trabajar
select FirstName, BirthDate, HireDate,
		datediff(yy,BirthDate,HireDate)
from Employees

--Opradores de comparación
Select * from Products where UnitPrice > 20



-- Rangos
select ProductName, UnitPrice from Products
where UnitPrice between 10 and 50

select FirstName, BirthDate from Employees
where year(BirthDate) between 1950 and 1959

--Madnejo de cadenas
--%
select * from Products 
where ProductName like 'queso'

select * from Products 
where ProductName like 'queso%'

select * from Products 
where ProductName like '%es'

select * from Products 
where ProductName like '%as%'

select * from Products 
where ProductName like 'g%a'
--[]
select * from Products 
where ProductName like '[mgr]%'
--[^]
select * from Products 
where ProductName like '%[^aeiou]'
--__
select * from Products 
where ProductName like '_[aeiou]%'

select * from Products 
where ProductName like '____[aeiou]%'
--consulta que los productos tengan 5 caracteres
select * from Products 
where ProductName like '_____'
--producto que solo 2 palabras
select * from Products 
where ProductName like '% %' and ProductName not like '% % %'

select * from Products
where Len(replace(ProductName,' ','')) = (len(ProductName) - 1)
--Productos que contengan 3 vocales
select * from Products 
where ProductName like '%[aeiou]%[aeiou]%[aeiou]%'

select * from Products
where Len(replace(replace(replace(replace('a','',''),'e',''),'o',''),'u','')) = (len(ProductName) - 3)


--incorrecto marca error--
--select region ,* from Employees where region is null;--

-- Consulta incorrecta no marca error--
select region ,* from Employees where region = null;

--consulta con los clientes que no tengan fax
SELECT FAX ,* FROM CUSTOMERS WHERE FAX IS NULL;

--CONSULTA CON LOS EMPLEADOS QUE NO TIENEN DOMICILIO--
SELECT Address ,* from Employees where ADDRESS is null;


--CONSULTA CON LOS CLIENTES ORENADOS POR EL NOMBRE DEL CONTACTO EN FORMA DESCENDENTE
SELECT * FROM CUSTOMERS ORDER BY CONTACTNAME DESC;

--CONSULTA CON LOS PRODUCTOS ORDENADOS POR EL PRECIO
SELECT PRODUCTID, PRODUCTNAME, UNITPRICE FROM PRODUCTS ORDER BY 3 DESC;

--CONSULTA CON LOS 5 PRODUCTOS MAS CAROS--
SELECT TOP 5 PRODUCTID, PRODUCTNAME, UNITPRICE FROM PRODUCTS ORDER BY 3 DESC;

--CONSULTA CON LOS 10 PRODUCTOS MAS BARATOS--
SELECT TOP 10 PRODUCTID, PRODUCTNAME, UNITPRICE FROM PRODUCTS ORDER BY UNITPRICE ASC;

--CONSULTA CON LAS ULTIMAS 10 ORDENES REALIZADAS EN 1996--
SELECT TOP 10 ORDERID, ORDERDATE FROM ORDERS WHERE YEAR(ORDERDATE) = 1996
ORDER BY ORDERDATE DESC; 

--CROSS JOIN--

--ANSI--
SELECT * FROM Employees CROSS JOIN ORDERS;

--CROSS JOIN

--10 COLUMNAS, 77 RENGLONES
SELECT * FROM PRODUCTS

--4 COLUMNAS, 8 RENGLONES
SELECT * FROM Categories

--COLUMNAS 10 + 4 = 14
--RENGOLES 77 * 8 = 616
SELECT * FROM PRODUCTS  CROSS JOIN CATEGORIES;

--BD ESTADOS--

--INNER JOIN
--SELECT * FROM ESTADOS
--SELECT * FROM MUNICIPIOS

--SELECT * FROM MUNICIPIOS CROSS JOIN ESTADOS

--COMBINACNION INTERNA
--MUESTRAS LOS REGISTROS QUE EXISTEN EN LAS 2 TABLAS
--SELECT M.NOMMUN, M.EDO, E.EDO, E.NOMEDO
--FROM MUNICIPIOS M INNER JOIN ESTADOS E ON E.EDO = M.EDO

--CONSULTA CON EL NOMBRE DEL PRODUCTO Y NOMBRE DE LA CATEGORIA
SELECT PRODUCTS.ProductName, categories.CategoryID FROM PRODUCTS
INNER JOIN CATEGORIES ON PRODUCTS.CategoryID = Categories.CategoryID;

SELECT P.PRODUCTNAME, C.CATEGORYNAME
FROM PRODUCTS P INNER JOIN CATEGORIES C ON C.CATEGORYID = P.CATEGORYID;

--CONSULTA CON EL NOMBRE DEL PRODUCTO, NOMBRE DEL PROOVEDOR Y NOMBRE DE LA CATEGORIA
SELECT P.PRODUCTNAME, S.COMPANYNAME, C.CATEGORYNAME
FROM PRODUCTS P
INNER JOIN SUPPLIERS S ON S.SUPPLIERID = P.SupplierID
INNER JOIN CATEGORIES C ON C.CategoryID = P.CategoryID

















