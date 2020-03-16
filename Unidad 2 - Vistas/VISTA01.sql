--Unidad 2 VISTAS--
use Northwind;
go;

--son objetos contenidos dentro de cada bd y son consultas precompiladas que funcionan
--como tablas virtuales. Debido a que son consultas precompiladas,
--cuando se ejecutan, son mas rapidas que la consulta que contiene--

--1. Creacion--
--create  view nom_vista [with encryption] as instruccion_select;

--2. Manipulacion--
--select * from nom_vista;

--3. Modificacion 
--alter view nom_vista as intruccion_select

--4. Elimincacion
--drop view nom_vista;

--vista con clave, el nombre y precio del producto;
go
 create view vw_productos as
 select productid, productname, unitprice from products;

 select * from vw_productos;

 select * from vw_productos p 
 inner join [Order Details] d on d.ProductID = p.ProductID;

 update vw_productos set UnitPrice = UnitPrice + 1 where productid = 1;

 --con este procedimiento almacenado se ve le contenido de la vista si no esta encriptada--
 sp_helptext vw_productos;

 --eliminacion de una vista--
 drop view vw_productos;
 GO

--ahora la vista creada y encriptada--
create view vw_productos with encryption as
select productid, productname, unitprice from products;

GO

--no se puede mostrar el contenido de la vista--
sp_helptext vw_productos;
