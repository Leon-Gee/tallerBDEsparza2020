--Familias de vistas
--PLAN PARA GENERAR LA FAMILIA DE VISTAS EN LA BASE DE DATOS NORTHWIND

--SE DEBE IR GENERANDO LAS VISTAS DE AFUERA HACIA ADENTRO E IR REUTILIZANDO LAS VISTAS CREADAS PREVIAMENTE CON TODAS SUS COLUMNAS

--SECUENCIA DE CREACION DE VISTAS
--NOMBRE TABLAS UTILIZADAS

-------------------------------------------------
/*
VW_PRODUCTS               PRODUCTS, CATEGORIES, SUPPLIERS
VW_ORDERS                 ORDERS,EMPLOYEES, SHIPPERS, CUSTOMERS
VW_ORDERDETAILS           [ORDER DETAILS], VW_ORDERS, VW_PRODUCTS

--SUPLEMENTARIAS
VW_TERRITORIES            TERRITORIES,REGION
VW_EMPLOYEETERRIOTRIES    VW_TERRITORIES, EMPLOYEES, EMPLOYEETERRITORIES
*/
-----------------------------------------------
use Northwind;
GO

-- PRODUCTS VIEW
create view vw_products as
select
p.productid, p.productname, p.quantityperunit, productunitprice = p.unitprice, p.unitsinstock, p.unitsonorder,
p.reorderlevel, p.discontinued,
s.supplierid, s.companyname, s.contactname, s.contacttitle, s.address, s.city, s.region, s.postalcode,
s.country,s.phone, s.fax, s.homepage,
c.categoryid, c.categoryname, c.description, c.picture
from products p
inner join Categories c ON p.CategoryID =c.CategoryID
inner join Suppliers s ON p.SupplierID = s.SupplierID
GO
select * from vw_products

-- ORDERS VIEW
create view vw_orders as
select o.OrderID, o.OrderDate, o.RequiredDate, o.Freight, s.Phone ,
o.ShipAddress, o.ShipCountry,  o.ShippedDate, s.ShipperID, s.CompanyName, ShipperPhone =  s.Phone,
c.CustomerID, CusCompanyName = c.CompanyName, CusContactName = c.ContactName, CusContactTittle = c.ContactTitle, 
CusContry = c.Country, CusFax = c.Fax, CusPhone = c.phone, CusPostalCode =  c.PostalCode,CusRegion = c.Region,
e.EmployeeID, EmpFirstName = e.FirstName, EmpLastName = e.LastName, EmpAdrees = e.Address, e.BirthDate, EmpCity = e.City,
EmpCountry = e.Country, e.HireDate, EmpHomePhone = e.HomePhone, e.Notes, e.Photo, e.PhotoPath,
EmpPostalCode =  e.PostalCode, EmpRegion = e.Region, e.ReportsTo, e.Title, e.TitleOfCourtesy
from orders o 
inner join Employees e on o.EmployeeID = e.EmployeeID
inner join Customers c on o.CustomerID = c.CustomerID
inner join Shippers s on s.ShipperID = o.ShipVia
GO
select * from vw_orders

drop view vw_orderdetails;
-- ORDER DETAILS VIEW
create view vw_orderdetails as
select 
od.orderID, od.ProductID, od.Quantity, od.UnitPrice, od.Discount, 
vp.productname, vp.quantityperunit, vp.productunitprice, 
vp.unitsinstock, vp.unitsonorder,vp.reorderlevel, vp.discontinued,vp.supplierid, 
supplierCompanyName = vp.companyname, 
supplierContactname = vp.contactname, supplierContactTittle = vp.contacttitle, 
supaddress = vp.address, supCity = vp.city, 
supRegion = vp.region, supPostalCode = vp.postalcode, 
supplierCountry = vp.country,vp.phone as 'SupplierPhone', 
supFax = vp.fax, supHomepage = vp.homepage, vp.categoryid, vp.categoryname, catDescription = vp.description,
catpicture = vp.picture,
vo.OrderDate, vo.RequiredDate, vo.Freight, vo.Phone ,
vo.ShipAddress, vo.ShipCountry,  vo.ShippedDate, vo.ShipperID, vo.CompanyName, shipperPhone = vo.Phone,
vo.CustomerID, vo.CusCompanyName, vo.CusContactName, vo.CusContactTittle, 
vo.CusContry, vo.CusFax, CustomerPhone = vo.phone, vo.CusPostalCode,vo.CusRegion,
vo.EmployeeID, vo.EmpFirstName, vo.EmpLastName ,vo.EmpAdrees, vo.BirthDate, vo.EmpCity,
vo.EmpCountry, vo.HireDate, vo.EmpHomePhone,vo.Notes, vo.Photo, vo.PhotoPath,
vo.EmpPostalCode, vo.EmpRegion, vo.ReportsTo, vo.Title, vo.TitleOfCourtesy
from [Order Details] od
inner join vw_orders vo on od.OrderID = vo.OrderID
inner join vw_products vp on vp.productid = od.ProductID
GO
select * from vw_orderdetails

 /*
--SUPLEMENTARIAS
VW_TERRITORIES            TERRITORIES,REGION
VW_EMPLOYEETERRIOTRIES    VW_TERRITORIES, EMPLOYEES, EMPLOYEETERRITORIES
*/

--- TERRITORIES VIEW
create view vw_territories as
select t.TerritoryID, t.TerritoryDescription, r.RegionID, r.RegionDescription from Territories t
inner join Region r on t.RegionID = r.RegionID
GO
select * from vw_territories

-- EMPLOYEETERRITORIES VIEW
create view vw_employeeterritories as
select et.TerritoryID, t.territoryDescription, t.RegionID, t.RegionDescription,
e.EmployeeID, e.FirstName, e.LastName, e.TitleOfCourtesy,e.BirthDate ,e.HireDate,
e.Address, e.City, e.PostalCode, e.Country,e.HomePhone, e.Extension, e.photo,e.notes,e.ReportsTo, 
e.PhotoPath
from EmployeeTerritories et
inner join vw_territories t on et.TerritoryID = t.TerritoryID
inner join Employees e on e.EmployeeID = et.EmployeeID
GO
select * from vw_employeeterritories;

--ejecucion de vista products
select * from vw_products;

--consulta con el nombre del producto, nombre de la categoria y nombre del proovedor
select Productname, CategoryName, CompanyName
from vw_products;

--funciones de agregado
select count(productname) from vw_products;
select sum(unitprice) from vw_orderdetails;
select avg(unitprice) from vw_orderdetails;
select max(unitprice) from vw_orderdetails;
select min(unitprice) from vw_orderdetails;

select productname, categoryname, companyname from vw_products
--consulta con el nombre del proveedor y total de prod que suerte

select companyname, count(*)
from vw_products
group by companyname -- encontrar los proveedores distintos

--la categoria y el total de prod que contiene
select categoryname,count(*)
from vw_products
group by categoryname --encontrar las categorias distintas	

--consulta con el nombre del cliente, total de ordenes realizadas, fecha de la ultima
select orderid, orderdate, nomcliente from vw_orders order by nomcliente;

select nomcliente, count(*), max(orderdate)
from vw_orders
group by nomcliente;

--consulta con el nombre de la categoria y total de productos que surte

--mostrar solo las categorias que tengan menos de 10 productos
select productname,categoryname,companyname from vw_products order by 3;


--consulta con el nombre del cliente, total de ordenes realizadas e importe total de ventas
select orderid, nomcliente, productname,quantity, unitprice from vw_orderdetails order by nomcliente;

select nomcliente, ordenes = count(distinct orderid), importe = sum( quantity * unitprice)
from vw_orderdetails group by nomcliente order by nomcliente

--CONSULTA CON EL FOLIO DE LA ORDEN Y EL IMPORTE TOTAL DE LA ORDEN
SELECT ORDERID, PRODUCTNAME, QUANTITY, UNITPRICE FROM VW_ORDERDETAILS

SELECT ORDERID, IMPORTE = SUM(QUANTITY * UNITPRICE)
FROM VW_ORDERDETAILS
GROUP BY ORDERID;








