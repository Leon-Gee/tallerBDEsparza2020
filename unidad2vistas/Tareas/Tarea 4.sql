CREATE DATABASE HOSPITAL
GO
USE HOSPITAL
GO
CREATE TABLE ZONAS(
	ZonId INT NOT NULL, --PK
	Nombre VARCHAR(50) NOT NULL
)
CREATE TABLE HOSPITALES(
	HosId INT NOT NULL, --PK
	Nombre VARCHAR(50) NOT NULL,
	ZonId INT NOT NULL --FK
)
CREATE TABLE CONSULTORIOS(
	ConId INT NOT NULL, --PK
	Nombre VARCHAR(50) NOT NULL,
	HosId INT NOT NULL --FK
)
CREATE TABLE CITAS(
	Cita INT NOT NULL, --PK
	Fecha DATETIME NOT NULL,
	Peso NUMERIC(5,2) NOT NULL,
	Estatura NUMERIC(3,2) NOT NULL,
	Presion NUMERIC(5,2) NOT NULL,
	Observaciones VARCHAR(100) NOT NULL,
	ConId INT NOT NULL --FK
)
GO
ALTER TABLE ZONAS ADD
	CONSTRAINT PK_ZONAS PRIMARY KEY (ZonId)
ALTER TABLE HOSPITALES ADD
	CONSTRAINT PK_HOSPITALES PRIMARY KEY (HosId)
ALTER TABLE CONSULTORIOS ADD
	CONSTRAINT PK_CONSULTORIOS PRIMARY KEY (ConId)
ALTER TABLE CITAS ADD
	CONSTRAINT PK_CITAS PRIMARY KEY (Cita)
GO
ALTER TABLE HOSPITALES ADD
	CONSTRAINT FK_HOSPITALES_ZONAS FOREIGN KEY (ZonId) REFERENCES ZONAS (ZonId)
ALTER TABLE CONSULTORIOS ADD
	CONSTRAINT FK_CONSULTORIOS_HOSPITALES FOREIGN KEY (HosId) REFERENCES HOSPITALES (HosId)
ALTER TABLE CITAS ADD
	CONSTRAINT FK_CITAS_CONSULTORIOS FOREIGN KEY (ConId) REFERENCES CONSULTORIOS (ConId)

GO

INSERT INTO ZONAS VALUES
	(1, 'NORTE'),
	(2, 'SUR'),
	(3, 'CENTRO'),
	(4, 'ESTE'),
	(5, 'OESTE')
INSERT INTO HOSPITALES VALUES
	(1, 'Hospital del norte',  1),
	(2, 'Hospital del sur',    2),
	(3, 'Hospital del centro', 3),
	(4, 'Hospital del este',   4),
	(5, 'Hospital del oeste',  5)
INSERT INTO CONSULTORIOS VALUES
	(1,  'Consultorio norte 1',  1),
	(2,  'Consultorio norte 2',  1),
	(3,  'Consultorio sur 1',    2),
	(4,  'Consultorio sur 2',    2),
	(5,  'Consultorio centro 1', 3),
	(6,  'Consultorio centro 2', 3),
	(7,  'Consultorio este 1',   4),
	(8,  'Consultorio este 2',   4),
	(9,  'Consultorio oeste 1',  5),
	(10, 'Consultorio oeste 2',  5)
INSERT INTO CITAS VALUES
	(1, '20170511', 63.20, 1.64, 90.50,  'Gripa',       2),
	(2, '20170809', 71.03, 1.71, 100.80, 'Temperatura', 4),
	(3, '20180325', 47.10, 1.52, 89.20,  'Tos',         1),
	(4, '20190415', 57.64, 1.62, 91.70,  'Dolor',       3),
	(5, '20201014', 82.89, 1.80, 100.20, 'Fiebre',      8)

GO

CREATE VIEW VW_HOSPITALES
AS
	SELECT H.HosId,
		   H.Nombre AS HosNombre,
		   Z.ZonId,
		   Z.Nombre AS ZonNombre
	FROM HOSPITALES H INNER JOIN ZONAS Z ON H.ZonId = Z.ZonId

GO

CREATE VIEW VW_CONSULTORIOS
AS
	SELECT C.ConId,
		   C.Nombre AS ConNombre,
		   VH.HosId,
		   VH.HosNombre,
		   VH.ZonId,
		   VH.ZonNombre
	FROM CONSULTORIOS C INNER JOIN VW_HOSPITALES VH ON C.ConId = VH.HosId

GO

CREATE VIEW VW_CITAS
AS
	SELECT C.Cita,
		   C.Fecha,
		   C.Peso,
		   C.Estatura,
		   C.Presion,
		   C.Observaciones,
		   VC.ConId,
		   VC.ConNombre,
		   VC.HosId,
		   VC.HosNombre,
		   VC.ZonId,
		   VC.ZonNombre
	FROM CITAS C INNER JOIN VW_CONSULTORIOS VC ON C.ConId = VC.ConId

GO
	--CONSULTAS
--1) Nombre de la zona y total de hospitales de la zona.
SELECT ZonNombre, COUNT(HosId) AS TotalHospitales
FROM VW_HOSPITALES
GROUP BY ZonNombre

--2) Nombre del consultorio y total de citas realizadas.
SELECT ConNombre, COUNT(Cita) AS TotalCitas
FROM VW_CITAS
GROUP BY ConNombre

--3) Año y total de citas realizadas.
SELECT DATEPART(YY, Fecha), COUNT(Cita) AS TotalCitas
FROM VW_CITAS
GROUP BY Fecha

--4) Nombre de la zona y total de citas realizadas.
SELECT ZonNombre, COUNT(Cita) AS TotalCitas
FROM VW_CITAS
GROUP BY ZonNombre

--5) Nombre del hospital y total de consultorios que contiene.
SELECT HosNombre, COUNT(ConId) AS TotalConsultorios
FROM VW_CONSULTORIOS
GROUP BY HosNombre

--6) Nombre del consultorio y peso total de los pacientes atendidos en las citas.
SELECT ConNombre, SUM(Peso) AS TotalPeso
FROM VW_CITAS
GROUP BY ConNombre

--7) Hospital y total de citas realizadas por mes del año 2017.
SELECT HosId, COUNT(Cita) AS TotalCitas
FROM VW_CITAS
WHERE DATEPART(YY, Fecha) = 2017
GROUP BY HosId