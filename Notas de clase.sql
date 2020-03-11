

--Funcones de converción
select 'El precio es ' + ltrim(str(UnitPrice,50,8)) from Products --Solo int a char

select 'El precio es ' + convert(varchar, UnitPrice ) from Products

select 'El precio es ' + cast(UnitPrice as varchar ) from Products

--Funciones para manejo de fecha
select getdate()
select dateadd(yy, 1, getdate())
select datediff(yy,getdate(), dateadd(yy, 1, getdate()))
select datename(dw, getdate())
select datepart(yy, getdate())
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
where Len(replace(replace(replace(replace(ProductName,'a',''),'e',''),'o',''),'u','')) = (len(ProductName) - 3)

--consulta empleados que no trngan region
select region from Employees where Region is null

--consulta con los clientes que no tengan fax
select fax,* from Customers where Fax is null

--Ordenamiento
--consulta ordenada por nombre de contacto
Select * from Customers order by ContactName desc
--consulta ordenada por el precio
Select ProductID, ProductName, UnitPrice from Products order by 3 desc

--TOP
--consulta los 5 productos mas caros
Select top 5 ProductID, ProductName, UnitPrice from Products order by UnitPrice desc
--consulta los 10 productos mas baratos
Select top 5 ProductID, ProductName, UnitPrice from Products order by UnitPrice asc
--Consulta ultimas 10 ordenes realizadas en 1996
Select top 10 OrderID,OrderDate from Orders
where year(OrderDate) = 1996
order by OrderDate desc

--Correlación de datos [JOINS]
--Cross Join
Select * from Products cross join Categories

--Inner Join 
/*
select * from M.nombre, M.edo, E.nombre
from Municipios M inner join Estados on E.edo = M.edo
*/

select p.ProductName, C.CategoryName from Products P inner join Categories C on C.CategoryID = P.CategoryID
select p.ProductName, S.CompanyName, C.CategoryName
from Products P inner join Suppliers S on S.SupplierID = P.SupplierID 
				inner join Categories C on C.CategoryID = P.CategoryID

---------------------------------------------------------------------------------------/17/02/2020/

select O.OrderID, O.OrderDate, (E.FirstName +' '+ E.LastName) as Employee, C.CompanyName
from Orders O inner join Employees E on E.EmployeeID = O.EmployeeID
			  inner join Customers C on C.CustomerID = O.CustomerID
where year(O.OrderDate) = 1996

--consulta con clave de la orden, nombre del producto, cantidad, precio y total de la venta
-- mostrar solo las de los dás lunes
select O.OrderID, P.ProductName, D.Quantity, D.UnitPrice, (D.Quantity * D.UnitPrice) as Total
from Orders O inner join [Order Details] D on D.OrderID = O.OrderID
			  inner join Products P on P.ProductID = D.ProductID
where datepart(dw, O.OrderDate) = 2

-- consulta nombre de empleado y nombre del territorio que atiede
select E.FirstName, T.TerritoryDescription
from Employees E inner join EmployeeTerritories ET on E.EmployeeID = ET.EmployeeID
				 inner join Territories T on ET.TerritoryID = T.TerritoryID

Select E.LastName as Empleado, J.LastName as Jefe
from Employees E inner join Employees J on E.ReportsTo = J.EmployeeID
where (J.Address like 'blvd' and J.Region is null) or
	  (E.Address like 'blvd' and E.Region is null)

--consulta con la clave y fecha de la orden, nombre del empleado y nombre del cliente
--mostrar solo los cliente que vivan paises que su nombre empiece con M ó B
select O.OrderID, O.OrderDate, E.FirstName+' '+E.LastName as Employee, C.CompanyName, C.Country
from Orders O inner join Employees E on O.EmployeeID = E.EmployeeID
			  inner join Customers C on O.CustomerID = C.CustomerID
where C.Country like '[mb]%'

-------------------------------UNIDAD 2--------------------------------------------------/19/02/2020/
/*
--1.- Creacion
create view nom_vista [whit encryption] as 
instruccion_select

--2.- Manupulacion
select * from nom_vista

insert / update / delete nomm_vista

--3.-Modificacion
alter view nom_vista as
instruccion_select

--4.-Eliminacion
drop view nom_vista
*/
go
--vista con el nombre y precio del producto
create view vw_productos as
select ProductID, ProductName, UnitPrice from Products
go
--utilizar la vista
select * from vw_productos

--dentro de una combinacion
select * from vw_productos P inner join [Order Details] D on D.ProductID = P.ProductID

--con este procedimiento  se ve el contenido de la vista si no esta encriptada
sp_helptext vw_products

--eliminacion de una vista
drop view vw_productos
go
--ahora la vista creada y encriptada
create view vw_products with encryption as
select ProductID, ProductName, UnitPrice from Products
go
/*
	[Restricciones]
1.- Debe especificar los nommbre de todas las columnas derivadas y estos nombres no deben repetirse

2.- Las intrucciones create view no pueden combinarse con ningún otra
	  instrucción de SQL en un lote. Un lote es un conjunto de instrucciones
    separadas por la palabra GO

3.- Todos los objetos de BD a los que se haga referecia en la vista,
    se verifican al momento de crearla

4.- No se pueden incluir las clausulas ORDER BY en la instruccion
	SELECT dentro de la vista

5.- Si se eliminan objetos a los que se hace referencia dentro de una vista,
    la vista permanece, la siguiente vez que intente usar esa vista recibira un mensaje de error

6.- No puede hcer referencia a tablas temporales en una vista

7.- Si la vista emplea un asterisco en la instrucción select y la
	tabla base a la que hace referencia se le agregan nuevas columnas,
	estas no se mostrarán en la vista

8.- Si se crea una vista hija con base en una vista padre, debe tomar presente lo uqe esta haciendo la vista padre

9.- Los datos de las vistas no se almacenan por separado, si se cambia un dato en una
	vista, está modificando el dato en una tabla base

10.-En una vista no se puede hacer referencia a mas de 1024 columnas

11.-En una vista no puede crear indices, ni desencadenadores

*/

/*	FAMILIAS DE VISTAS
	plan para generar la familia de vistas en la base de datos northwind

	se debe ir generando a las vistas de afuera hacia adentro e ir utilizando las vistas creadas previamente con todas
	sus columnas
*/

create table #CopiaTemp


select * into #CopiaTemp from Products
select #CopiaTemp

--ejecucuion de la vista products
select * from vw_products

--Consulta con el nombre de producto, nombre de la categoría y nombre del provedor
select ProductName, cAtegoryName, CompanyName
from vw_products

--Funciones de agregación
COUNT
SUM
AVJ 
MAX
MIN

--Consulta con el nombre del proveedor y total de prod que surte
Select CompanyName, count(*)
from vw_products
group by ComanyName --Encontrar los proveedores distintos

--La categoría y el total de productos que contiene
Select CategoryName, count(*)
from vw_products
group by CategoryName --Encontrar las categorías distintas

--Consulta nombre del clieente, total de ordenes realizadas, fechade la ultima orden
select orderId, OrderDate, nomCliente 
from vw_orders
group by nomCliente

Select nomCliente, count(*), max(OrderDate)
from vw_Orders
group by NomCliente

--Consulta con el nombre del cliente, total de ordenes realizadas e importe total de ventas 
select orderId, nomCliente, ProductName, Quantity, UnitPrice
from vw_products



---------------------------------------------------------------------------------------/25/02/2020/
--consulta con el nombre de la categoría y total de productos que surte,
--mostrara solo las categorias que tengan menos de 10 productos
select categoryName, count(*)
from vw_products
group by categoryName
having count(*) < 10

--consulta con el nombre del proveedor y total de productos que surte
--mostrar solo los proveedores que su nombre empiece con m, n y que surtan entre 1 y 3 productos
select companyname, count(*)
from vw_products
where companyname like '[mn]%'
having count(*) between 1 and 3

--consulta con el nombre del cliente, total de ordenes realizadas e importe total de ventas
--mostrar solo los clientes con mas de 10,000 en ventas
select nombreCliente,count(distinct orderID) as ordenes, sum(quantity * unitPrice)
from vw_OrderDetails
group by nomCliente
having sum(quantity * unitPrice) > 10000
order by nomCliente

--consulta con el nombre del cliente, el importe total de ventas, importe de 1996, 1997 y 1998
select nomCliente, 
	   importe = sum(quantity * unitPrice),
	   1996 = sum(case when year(orderDate) = 1996 then quantity * unitPrice else 0 end),
	   1997 = sum(case when year(orderDate) = 1997 then quantity * unitPrice else 0 end),
	   1998 = sum(case when year(orderDate) = 1998 then quantity * unitPrice else 0 end),
from vw_OrderDetails
group by nomCliente

--consulta con el nombre de la semana, total de ordenes realizadas e importe deventa de ese día
select datename()Dw,orderDate), count(distinct orderID), sum(quantity * unitPrice)
from vw_orderDetails
group by datename(dw, orderDate)

create view vw_dias
as
select clave = 1, nombre = 'Sunday' union
				  select 2,'Monday' union
				  select 3,'Wednesday' union
				  select 4,'Thursday' union
				  select 5,'Friday' union
				  select 6,'Saturday'

-

---------------------------------------------------------------------------------------/26/02/2020/

select d.nombrbe, count(distinct od.orderiD), isnull(sum(od.quantity * od.unitPrice), 0)
from vw_orderdetails od right outer  join vw_dias D.ON D.clave= datepart(dw, orderdate)
group by d.clave, d.nombre
order by d.clave asc


----------------Transact SQL-----------------------------------------------------------/03/03/2020/

--declaraci+on de varisbles
declare @variable int

--tipos de datp
bit, int, numeric, char, varchar, datetime,etc

--asignacion
set @variable = 1
select @variable = 1

--fechas y caracteres van entre comillas

--ejemplos 
declare @total numeric(7,3)
select @total
select @total = 9999.000
select @total
select @total = count(*) from Employees
select @total

declare @total2 numeric(12,2), @min int
select @total2 = count(*), @min = min(EmployeeID) from Employees
select @total2, @min

--variables del sistema
select @@VERSION --contiene la version de sql server
select @@FETCH_STATUS --se utiliza en cursores, indica la posición del cursor
select @@ERROR --administra el tipo de error que ha ocurrido
select @@CONNECTIONS --indica el número de conexiones activas
select @@ROWCOUNT --indica los renglones afectados por la instrucción insert/update
select @@IDENTITY --indica el ultimo valor optenido en una tabla con la propiedad identity

---------------------------------------------------------------------------------------/10/03/2020/

--creación
Create procedure Pa_Nombre
@parametro int
as
begin
	--sentencias
	select 1
end

--modificación 
alter procedure Pa_nombre
as
begin
	select 2
end

--eliminacion
drop procedure Pa_nombre

--ejecución
exec Pa_nombre

--Ejecutar una consulta mediante una cadena de caracteres, debe ejecutar una sentencia select
declare @sql varchar
set @sql = 'select * from Orders'
exec (@sql)

--sentencia raiserror : se utiliza para mandar mensajes de error a una aplocación
/*
	faltan apuntes
*/

--2.- Sin parametros
--procedimiento que actualice el precio de todos los productos y aumente el 10%
create procedure Pa_Aumento
as
update Products 