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
go
 create view vw_productos as
 select [Clave del producto]=p.productid, [Nombre del producto] = p.productName,[Categoria] = c.categoryname, [Proovedor] = s.contactname 
 from products p
 inner join categories c on c.categoryid = p.categoryid 
 inner join suppliers s on s.supplierid = p.supplierid ;

go
 create view vw_orders as
 select [Clave de la orden]=o.orderid, [Nombre del empleado] = e.firstname + ' ' + e.lastname, [Contacto] = s.ContactName,
 [Nombre del Cliente] = c.ContactName from orders o
 inner join employees e on e.employeeid = o.employeeid
 inner join suppliers s on s.SupplierID = o.ShipVia
 inner join customers c on c.CustomerID = o.CustomerID;

 go
 create view vw_orderdetails as
 select od.*, o.*,p.*
 from [Order Details] od
 inner join vw_orders o on o.[Clave de la orden] = od.OrderID
 inner join vw_productos p on p.[Clave del producto] = od.ProductID;

 go

