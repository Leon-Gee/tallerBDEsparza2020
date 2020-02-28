----------------


/*
Municipios
munid
mnnombre

uno a muchos con clientes
Clientes
clid
clinnom
cliapellidos
cliRFC
clidomicilio
clisexo
munid

uno am uchos con envios

evnios
folio
fecha
cliid
peso
importe




Vw_Municipios estados, municipios
vw_clientes clientes,vm_municipios
vw_rentas rentas,vw_clientes
vw_radios rentas,tamano, modelos
vw_rad*rentas vw_rentas, vw_radio

*/


-----------------------
create database envios
go
use envios
go
create table municipios(
munid int not null,
munnombre varchar(50) not null

)

go
create table clientes(
cteid int not null,
ctenombre varchar(50) not null,
cteapellidos varchar(50) not null,
cterfc varchar(50) not null,
ctedomicilio varchar(100) not null,
ctesexo char(1) not null,
munid int not null

)

go
create table envios(
folio int not null,
fecha datetime not null,
peso numeric(12,2) not null,
importe numeric(12,2) not null,
cteid int not null
)
go
--llaves primarias
go
alter table municipios add constraint pk_municipios primary key (munid)
go
alter table clientes add constraint pk_clientes primary key (cteid)
go
alter table evios add constraint pk_envios primary key( folio )
--llaver externas
go
alter table clientes add constraint fk_cte_mun foreign key ( munid ) references municipios 
go
alter table envios add constraint fk_envios_cte foreign key ( cteid ) references clientes
go
--llave unica
alter table clientes add constraint uc_cte_rfc unique ( cterfc )
--check
go
alter table envios add
constraint cc_envios_peso check ( peso > 0),
constraint cc_envios_importe check ( importe > 0)
--familias de vistas de base de datos
go
create view vw_clientes as
select
c.cteid,c.ctenombre,c.cteapellidos,c.cterfc,c.ctedomicilio,c.ctesexo,
m.munid,m.munnombre
from clientes c
inner join municipios m on m.munid = c.munid
go
create view vw_envios as
select e.folio, e.fecha,e.peso,e.importe,
c.cteid,c.ctenombre,c.cteapellidos,c.cterfc,c.ctedomicilio,c.munid,c.munnombre
from envios e
inner join vw_clientes c on c.cteid = e.cteid;

