	CREATE DATABASE FERRETERIAS;
	GO
	USE FERRETERIAS;
	GO
	CREATE TABLE ZONAS(
	ZONAID INT NOT NULL,
	ZONANOMBRE NVARCHAR(20) NOT NULL
	)
	GO
	CREATE TABLE COLONIAS(
	COLID INT NOT NULL,
	COLNOMBRE NVARCHAR (50) NOT NULL,
	COLCP NCHAR ( 5 ) NULL,
	MUNID INT NOT NULL
	)
	GO
	CREATE TABLE MUNICIPIOS(
	MUNID INT NOT NULL,
	MUNNOMBRE NVARCHAR (50) NOT NULL
	)
	GO
	CREATE TABLE FAMILIAS(
	FAMID INT NOT NULL,
	FAMNIMBRE NVARCHAR(50) NOT NULL
	)
	GO
	CREATE TABLE FERRETERIAS(
	FERRID INT NOT NULL,
	FERRNOMBRE NVARCHAR(20) NOT NULL,
	FERRCALLE NVARCHAR(20) NOT NULL,
	FERRTELEFONO NVARCHAR(10) NOT NULL
	)

	GO
	CREATE TABLE EMPLEADOS(
	EMPID INT NOT NULL,
	EMPNOMBRE NVARCHAR (50) NOT NULL,
	EMPAPEPAT NVARCHAR(50) NOT NULL,
	EMPAPEMAT NVARCHAR (50) NOT NULL,
	EMPDOMICILIO NVARCHAR(50) NOT NULL,
	EMPTELEFONO NVARCHAR(10) NULL,
	EMPCELULAR NVARCHAR(10) NULL,
	EMPRFC NCHAR(13) NULL,
	EMPCURP NCHAR(15) NULL,
	EMPFECHAINGRESO DATETIME NOT NULL,
	EMPFECHANACIMINIENTO DATETIME NOT NULL,
	ZONAID INT NOT NULL

	)
	CREATE TABLE CLIENTES(
	CTEID INT NOT NULL,
	CTENOMBRE VARCHAR(50) NOT NULL,
	CTEAPEPAT VARCHAR(50) NOT NULL,
	CTEAPEMAT VARCHAR(50) NOT  NULL,
	CTEDOMICILIO VARCHAR(50) NOT NULL,
	CTETELEFONO VARCHAR(10) NULL,
	CTECELULAR VARCHAR(10) NULL,
	CTERFC CHAR(13) NULL,
	CTECURP CHAR(15) NULL,
	CTEFECHANACIMIENTO DATETIME NOT NULL,
	CTESEXO CHAR(1) NOT NULL,
	CTETIPOPER CHAR(1) NOT NULL,
	COLID INT NOT NULL
	)
	GO
	CREATE TABLE ARTICULOS(
	ARTID INT NOT NULL,
	ARTNOMBRE VARCHAR(50) NOT NULL,
	ARTDESCRIPCION VARCHAR(50) NOT NULL,
	ARTPRECIO NUMERIC(12,2) NOT NULL,
	FAMID INT NOT NULL
	)
	GO
	CREATE TABLE DETALLE(
	FOLIO INT NOT NULL,
	ARTID INT NOT NULL,
	CANTIDAD NUMERIC(12,2) NOT NULL,
	PRECIO NUMERIC(12,2) NOT NULL
	)
	GO


	--instruccion completa
	INSERT INTO COLONIAS(COLID,COLNOMBRE,COLCP,MUNID)
		VALUES(1,'LOPEZ MATEOS',80000,'1')

	INSERT INTO COLONIAS(COLCP, MUNID, COLID, COLNOMBRE)
		VALUES('80000',1,2,'CENTRO')

	--SE PUEDE OMINITIR EN LA LISTA DE COLUMNAS SOLO LAS QUE PERMITEN NULOS
	--EN ESTE CASO LA COLUMNA COLCP
	INSERT INTO COLONIAS(MUNID,COLNOMBRE,COLID)
		VALUES(1,'ZAPATA',3)

	--INSERT CORTO, SE OMITEN EN LA LISTA DE LAS COLUMNAS, DEBEN
	--PASARSE TODOS LOS VALORES EN EL ORDEN EN QUE FUERON CREADOS
	INSERT COLONIAS VALUES(4,'BUENOS AIRES','82050',1)

	--SE PUEDE PASAR UN VALOR NULO SI EL CAMPO LO PERMITE--
	INSERT COLONIAS VALUES(5,'GUADALUPE',NULL,1)

	--creamos la tabla prueba
	create table prueba(clave int, nombre varchar(50))
	--verificamos que no tenga datos
	SELECT * from prueba
	--insercion masiva con los datos de la colonia
	insert prueba
	SELECT colid,colnombre FROM COLONIAS
	--marca error
	insert prueba
	SELECT colid,colnombre, colcp FROM COLONIAS

	--creamos el proc alm
	create procedure sp_tabla as
	SELECT colid,colnombre,colcp FROM COLONIAS
	go
	--ejecucion del proc alm
	exec sp_tabla

	--insertcion masiva con proc alm
	insert prueba exec sp_tabla

	--LLAVES PRIMARIS
	alter table detalle add constraint pk_detalle primary key(folio,artid)
	alter table municipios add constraint pk_municipios primary key(munid)
	alter table colonias add constraint pk_colonias primary key(colid)
	alter table empleados add constraint pk_empleados primary key(empid)
	alter table clientes add constraint pk_clientes primary key(cteid)
	alter table articulos add constraint pk_articulos primary key(artid)
	alter table familias add constraint pk_familias primary key(famid)
	alter table ventas add constraint pk_veentas primary key(folio)
	alter table ferreterias add constraint pk_ventas primary key(folio)

	--creamos el proc alm


	ALTER TABLE ARTICULOS ADD
	CONSTRAINT FK_ARTICULOS_FAMILIAS FOREIGN KEY (FAMID) REFERENCES FAMILIAS (FAMID)
	GO
	ALTER TABLE DETALLE ADD
	CONSTRAINT FK_DETALLE_ARTICULOS FOREIGN KEY(ARTID) REFERENCES ARTICULOS (ARTID),
	CONSTRAINT FK_DETALLE_VENTAS FOREIGN KEY (FOLIO) REFERENcES VENTAS(FOLIO)
	GO
	ALTER TABLE COLONIAS ADD
	CONTRAINT FK_COLONIAS_MUN FOREIGN KEY (MUNID) REFERENCES MUNICIPIOS(MUNID)
	GO
	ALTER TABLE CLIENTES ADD
	CONSTRAINT FK_CLIENTES_COL FOREIGN KEY (COLID) REFERENCES COLONIAS(COLID)
	GO
	ALTER TABLE EMPLEADOS ADD
	CONSTRAINT FK_EMP_ZONAS FOREIGN KEY (ZONAID) REFERENCES ZONAS (ZONAID)
	GO
	ALTER TABLE VENTAS ADD
	CONSTRAINT FK_VENTAS_FERR FOREIGN KEY (FERRID) REFERENCES FERRETERIAS(FERRID),
	CONSTRAINT FK_VENTAS_CTE FOREIGN KEY (CTEID) REFERENCES CLIENTES(CTEID),
	CONSTRAINT FK_VENTAS_EMP FOREIGN KEY(EMPID) REFERENCES EMPLEADOS(EMPID)
	GO
	alter table clientes add
	constraint uc_clientes_rfc unique (cterfc),
	constraint uc_clientes_curp unique(ctecurp)
	go
	alter table empleados add
	constraint uc_empleados_rfc unique(emprfc),
	constraint uc_empleados_curp unique(empcurp)
	go	
	alter table cliente add
	constraint cc_clientes_sexo check(ctesexo in('f''m'))
	go
	alter table detalle add
	constraint cc_detalle_precio check(precio>0),
	constraint cc_detalle_cantidad check(cantidad >0)
	go
	alter table articulos add
	constraint cc_articulos_precio check(artprecio >0)

	--default constraint
	--default constraint
	alter table empleados add
	constraint dc_empleados_dom default ('Domicilio conocido') for empdomicilio,
	constraint dc_empleados_tel default('sin telefono') for emptelefono
	go
	alter table clientes add
	constraint dc_clientes_dom default('domicilio conocido') for ctedomicilio,
	constraint dc_clientes_dombod default('sin telefono') for ctetelefono

	SELECT * FROM CLIENTES;