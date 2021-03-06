

--Funcones de converci�n
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

select (FirstName+' '+LastName+' nacio el d�a ') +
	datename(dw, BirthDate)+' '+
	datename(dd, BirthDate)+' de '+
	datename(mm, BirthDate)+' de '+
	convert(char(4), datepart(yy,BirthDate))
from Employees

select datename(dw, getdate())

--A�os vividos
select EmployeeID, FirstName, BirthDate,
		datediff(yy, BirthDate, getdate()),
		year(getdate()) - year(BirthDate)
From Employees
--nombre y antiguedad
select FirstName, HireDate,
		datediff(yy, HireDate, getdate())
From Employees
--la edad con la que entr� a trabajar
select FirstName, BirthDate, HireDate,
		datediff(yy,BirthDate,HireDate)
from Employees

--Opradores de comparaci�n
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

--Correlaci�n de datos [JOINS]
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
-- mostrar solo las de los d�s lunes
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
--mostrar solo los cliente que vivan paises que su nombre empiece con M � B
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

2.- Las intrucciones create view no pueden combinarse con ning�n otra
	  instrucci�n de SQL en un lote. Un lote es un conjunto de instrucciones
    separadas por la palabra GO

3.- Todos los objetos de BD a los que se haga referecia en la vista,
    se verifican al momento de crearla

4.- No se pueden incluir las clausulas ORDER BY en la instruccion
	SELECT dentro de la vista

5.- Si se eliminan objetos a los que se hace referencia dentro de una vista,
    la vista permanece, la siguiente vez que intente usar esa vista recibira un mensaje de error

6.- No puede hcer referencia a tablas temporales en una vista

7.- Si la vista emplea un asterisco en la instrucci�n select y la
	tabla base a la que hace referencia se le agregan nuevas columnas,
	estas no se mostrar�n en la vista

8.- Si se crea una vista hija con base en una vista padre, debe tomar presente lo uqe esta haciendo la vista padre

9.- Los datos de las vistas no se almacenan por separado, si se cambia un dato en una
	vista, est� modificando el dato en una tabla base

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

--Consulta con el nombre de producto, nombre de la categor�a y nombre del provedor
select ProductName, cAtegoryName, CompanyName
from vw_products

--Funciones de agregaci�n
COUNT
SUM
AVJ 
MAX
MIN

--Consulta con el nombre del proveedor y total de prod que surte
Select CompanyName, count(*)
from vw_products
group by ComanyName --Encontrar los proveedores distintos

--La categor�a y el total de productos que contiene
Select CategoryName, count(*)
from vw_products
group by CategoryName --Encontrar las categor�as distintas

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
--consulta con el nombre de la categor�a y total de productos que surte,
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

--consulta con el nombre de la semana, total de ordenes realizadas e importe deventa de ese d�a
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
select @@FETCH_STATUS --se utiliza en cursores, indica la posici�n del cursor
select @@ERROR --administra el tipo de error que ha ocurrido
select @@CONNECTIONS --indica el n�mero de conexiones activas
select @@ROWCOUNT --indica los renglones afectados por la instrucci�n insert/update
select @@IDENTITY --indica el ultimo valor optenido en una tabla con la propiedad identity

---------------------------------------------------------------------------------------/10/03/2020/

--creaci�n
Create procedure Pa_Nombre
@parametro int
as
begin
	--sentencias
	select 1
end

--modificaci�n 
alter procedure Pa_nombre
as
begin
	select 2
end

--eliminacion
drop procedure Pa_nombre

--ejecuci�n
exec Pa_nombre

--Ejecutar una consulta mediante una cadena de caracteres, debe ejecutar una sentencia select
declare @sql varchar
set @sql = 'select * from Orders'
exec (@sql)

--sentencia raiserror : se utiliza para mandar mensajes de error a una aplocaci�n
/*
	faltan apuntes
*/

--2.- Sin parametros
--procedimiento que actualice el precio de todos los productos y aumente el 10%
create procedure Pa_Aumento
as
update Products 

/*
	faltan apuntes
*/

---------------------------------------------------------------------------------------/11/03/2020/
--3.-Sp con parametros de entrada
--Sp que reciba 4 calificaciones imprimir el promdeio
Create proc Pa_Calificaciones
@cal1 int,
@cal2 int,
@cal3 int
as
Select (@cal1 + @cal2 + @cal3) / 3

--4.-Sp con parametros de salida
-- Sp que reciba 4 calificaciones y regrese el promedio y si fue aprobado
create proc Pa_Calif
@cal1 int,
@cal2 int,
@cal3 int,
@prom numeric(12,3) output,
@tipo char(20) output
as
begin
Select @prom = (@cal1 + @cal2 + @cal3) / 3
if(@prom > 70)
	select @tipo = 'Aprobado'
else
	select @tipo = 'Reprobado'
end
	--Ejecuci�n
declare @A numeric(12,3), @B char(20)
exec Pa_Calif 70,80,70, @A output, @B output
Select @A, @B

--5.-Por valor de retorno
--Regresa solo valores enteros
create proc Pa_CalifReturn
@cal1 int,
@cal2 int,
@cal3 int
as
begin
declare @prom int
Select @prom = (@cal1 + @cal2 + @cal3) / 3
return @prom
end
	--Ejecuci�n
Declare @A integer
exec @A = Pa_CalifReturn 60,70,98
Select @A

--6.-Procedimientos con valores predefinidos
--Recibe parametros y tinen valores predefinicidos
create proc Pa_RecibirDefault 
@val1 int,
@val2 int = 20
as
begin 
select @val1 + @val2
end

--EJERCICIO	
Create procedure Pa_Ordenes
@emp int,
@orders varchar(200) output
as
begin
	declare @clave int
	select @clave = min(OrderID) from Orders where EmployeeID = @emp
	while(@clave is not null)
	begin
		select @texto += ', ' + @clave
		select @clave = min(OrderID) from Orders
		where EmployeeID = @emp and OrderID > @clave
	end
end

select EmployeeID, OrderID from Orders

declare @clave int, @emp int, @texto varchar(200)
create table #table(emp int, orders varchar(200))


insert into #table values (@emp, @texto)
select * from #table


---------------------------------------------------------------------------------------/12/03/2020/
create proc Sp_Cliente 
@cliente varchar(5),
@product varchar(2000) output
as
begin
	declare @clave int
	set @product = ''
	select @clave = min(ProductID) from [Order Details] D inner join Orders O on D.OrderID = D.OrderID
	where CustomerID = @cliente
	while(@clave is not null)
	begin 
		Select @product = @product + ', ' + ProductName from Products
		where ProductID = @clave
		
		select @clave = min(O.OrderID) from [Order Details] D inner join Orders O on D.OrderID = D.OrderID
		where CustomerID = @cliente and ProductID > @clave
	end
end

go

alter proc Sp_Empleados
@cliente varchar(5),
@empleados varchar(2000) output
as
begin
	declare @clave int
	set @empleados = ''

	select @clave = min(EmployeeID) from Orders 
	where CustomerID = @cliente

	while(@clave is not null)
	begin 
		Select @empleados = @empleados + ', ' + convert(varchar, EmployeeID) from Employees
		where EmployeeID = @clave
		
		select @clave = min(EmployeeID) from Orders
		where CustomerID = @cliente and EmployeeID > @clave
	end
end

go

create proc Sp_todo
as
begin
	declare @cliente char(5), @products varchar(200), @empleados varchar(200)
	create table #tabla (cliente int, productos varchar(200), empleados varchar(200))

	select @cliente = min(CustomerID) from Customers

	while(@cliente is not null)
	begin 
		exec Sp_Cliente @cliente, @products output
		exec Sp_Empleados @cliente, @empleados output

		insert into #tabla values (@cliente, @products, @empleados)

		select @cliente = min(CustomerID) from Customers
		where CustomerID > @cliente
	end

	select * from #tabla
end

exec Sp_todo


---------------------------------------------------------------------------------------/17/03/2020/

--SP recursivo, recibe nombre del empleado y regresa todos sus jefes y su nivel
create proc Sp_NombreJefesNivel
@emp int,
@jefes varchar(200),
@nivel int output
as
begin
	declare @clavejefe int
	if @nivel is null
		select @nivel = 0
	if @nivel is null
		select @je = 0
	select @clavejefe = ReportsTo from Employees where EmployeeID = @emp

	if @clavejefe is not null
	begin
		select qnivel = @nivel + 1
		select @jefes = @jefes + FirstName + ' ' + LastName from Employees
		where EmployeeID = @clavejefe

		exec Sp_NombreJefesNivel @clavejefe, @jefes output, @nivel output
	end
end

--FUNCIONES
/* Tipos de funciones defindas por el usuario
tipos:
	1.- las funciones esclalares
	2.- tabla en linea
	3.- funciones de tabla de multi sentencias
*/

-- 1.- Funciones Escalares
go
create function dbo.Cubo (@num numeric(12,2))
returns numeric(12,2)
as
begin
	return @num * @num * @num
end
go
select dbo.Cubo (5)

go
-- 2.- Funciones de tabla en linea
create function dbo.Ordenes (@parametro int)
returns table
as
return (select * from Employees where EmployeeID = @parametro)

go

create function dbo.FuncionSelect (@emp int)
returns table
as
return (select * from Orders where EmployeeID = @emp)

go

select * from dbo.Ordenes (1) O inner join [Order Details] OD on O.OrderID = OD.OrderID
								inner join Employees E on E.EmployeeID = O.EmployeeID

go

create function dbo.OrdenesA�o (@a�o int)
returns table
as
return(
	select C.CompanyName, count(O.OrderID) as Total
	from Orders O right join Customers C on O.CustomerID = C.CustomerID and year(O.OrderDate) = 2000
	Group by C.CompanyName
)

go
Select * from dbo.OrdenesA�o(2000) Order by 1

select A.CompanyName, A.Total as T96, B.Total as T97, C.Total as T98
from dbo.OrdenesA�o(1996) A join dbo.OrdenesA�o(1997) B on A.CompanyName = B.CompanyName
							join dbo.OrdenesA�o(1998) C on A.CompanyName = C.CompanyName

go

create function dbo.Fu_VentasDia (@a�o int)
returns table
as return(
	select clave = Datepart(DW, O.OrderDate), Dia = dateName(DW, O.OrderDate)
	from Orders O inner join [Order Details] OD on O.OrderID = OD.OrderID
	where year(O.OrderDate) = @a�o
	group by datename(dw, O.OrderDate), DATEPART(DW, O.OrderDate)
)

go

create function dbo.Fu_Semana()
returns table
as return(
	select clave = 1, nombre = 'sunday'
	union
	select 2, 'monday'
	union
	select 3, 'tuesday'
	union
	select 4, 'wednesday'
	union
	select 5, 'thursday'
	union
	select 6, 'friday'
	union
	select 7, 'saturday'
)
go

