--RESTRICCIONES DE VISTAS--
--1. DEBE ESPECIFICAR EN UNA VISTA LOS NOMBRES DE TODAS LAS COLUMNAS DERIVADAS,
-- ADEMAS LOS NOMBRES DE LAS COLUMNAS NO SE DEBEN REPETIR--

CREATE VIEW VW_PRODUCTOPRECIO AS
SELECT PRODUCTNAME, PRECIO = UNITPRICE * 1.4 FROM PRODUCTS;

GO

--2. LAS INSTRUCCIONES CREATE VIEW NO PUEDEN COMBINARSE CON NINGUN OTRA INSTRUCCION SQL DE UN LOTE.
--INSTRUCCION DE SQL EN UN LOTE. UN LOTE ES UN CONJUNTO DE INSTRUCCIONES
--SEPARADAS POR LA PALABRA GO.

CREATE VIEW VW_PRODUCTOS 2 AS
SELECT * FROM PRODUCTS;
GO s
CREATE VIEW VW_PRODUCTOS3 AS
SELECT * FROM PRODUCTS
GO
--3. TODAS LOS OBJETOS DE BD A LAS QUE SE HACE REFERENCIA A LAS VISTA,
--SE VERIFICAN AL MONETO DE CREARLA.

CREATE VIEW VW_PRODUCTOS4 AS
SELECT GASTOS FROM PRODUCTS;

--4. NO SE PUEDEN INCLUIR LAS CLAUSULAS ORDER BY EN LA INSTRUCCION
--SELECT DENTRO DE UNA VISTA--

CREATE VIEW VW_PRODUCTOS6 AS 
SELECT * FROM PRODUCTS
ORDER BY PRODUCTNAME
GO

--SE ORDENA HASTA QUE SE EJECUTA LA VISTA
SELECT * FROM VW_PRODUCTOS6 ORDER BY PRODUCTNAME;

--5. SI SE ELIMINAN OBJETOS A LOS QUE SE HACE REFERENCIA DENTRO DE UNA VISTA--
--LA VISTA PERMANECE LA SIGUIENTE VEZ QUE INTENTE USAR ESA VISTA RECIBIRA UN MENSAJE DE ERROR--

CREATE VIEW VW_PRODUCTOS7 AS 
SELECT * FROM VW_PRODUCTOS6
GO
DROP VIEW VW_PRODUCTOS6
--LA VISTA 7 YA NO SE EJECUTA, LA VSITA 6 FUE ELIMINDA PREVIAMENTE
SElECT * FROM VW_PRODUCTOS7 ORDER BY PRODUCTID

--6 NO PUEDE HACER REFERENCIA A TABLAS TEMPORALES EN UNA VISTA.
--TAMPOCO PUEDE UTILIZAR LA CLAUSULA SELECT INTO DENTRO DE LA VISTA.

--TABLA TEMPORAL LOCAL
create table #local(col 1 int, col2 int)
--tabla temporal global
create table ##global(col 1 int, col2 int)

select * from #local
select * from ##global
--marca error
create view vw_productos5 as
select * from #local

--SELECT INTO, copia la estructura de una tabla y la llena de datos
select *
INTO #COPIAPROD
from products

select * from #copiaprod

drop table #COPIAPROD


--marca error
create view vw_productos5 as
select *
into tabla4
from products;


-- 7 SI LA VISTA EMPLEA EL ASTERISCO * EN LA INSTRUCCION SELECT Y
-- LA TABLA BASE A LA QUE HACE REFERENCIA SE LE AGREGAN NUEVAS COLUMNAS,
--ESTAS NO SE MOSTRARAN EN LA VISTA

create table tabla1(col1 int, col2 int)
go
create view vw_tablaA as
select * from tabla1
go
alter table tabla 1 add col3 int
go
select * from vw_tablaA
--Es necesario utilizar el comando alter view para actualizar los campos en la vista
alter view vw_tablaA as
select * from tabla1
--al eliminar una columna de tabla1, la vista marcara error al ejecutarse
alter table tabla1 drop column col1


select * from vw_tablaA
--se corrige ejecutando alter view

--8 Si se crea una vista hija con base en una vista padre, debe tomar presente lo que esta haciendo la vista padre.

--9 Los datos de las vistas no se almacenan por separado, si cambia un dato en una vista esta modificando
-- el dato en la tabla base--
update vw_products set unitprice = unitprice + 10 where productid = 1;

select * from products where productid = 1;

--10 En una vista no se puede hacer referencia a mas de 1024 columnas

--11 En una vista no se puede crear indices ni desencadenadores ( triggers)


