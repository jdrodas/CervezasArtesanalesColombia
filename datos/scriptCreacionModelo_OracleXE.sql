-- Script de clase - Junio 9 de 2023
-- Curso de Topicos Avanzados de Base de datos
-- Juan Dario Rodas - juand.rodasm@upb.edu.co

--Proyecto: Cervezas Artesanales de Colombia
-- Motor de Base de datos: Oracle XE 21C

-- Creamos el esquema/usuario CervezasColombia

-- Con el usuario system

-- Importante: Tener presente en que contenedor estás ubicado
alter session set container=xepdb1;

-- USER SQL
CREATE USER "CERVEZAS_DB" IDENTIFIED BY "unaclav3"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER "CERVEZAS_DB" QUOTA UNLIMITED ON "USERS";

-- ROLES
GRANT "CONNECT" TO "CERVEZAS_DB" ;
GRANT "RESOURCE" TO "CERVEZAS_DB" ;

-- SYSTEM PRIVILEGES
GRANT CREATE VIEW TO "CERVEZAS_DB" ;
GRANT CREATE SESSION TO "CERVEZAS_DB" ;
GRANT CREATE TABLE TO "CERVEZAS_DB" ;
GRANT CREATE SYNONYM TO "CERVEZAS_DB" ;
GRANT CREATE SEQUENCE TO "CERVEZAS_DB" ;

-- Con el usuario/esquema CERVEZAS_DB

-- *******************************
-- Creacion de tablas
-- *******************************

-- Tabla Ubicaciones
create table ubicaciones
(
	id int generated always as identity not null,
	municipio varchar2(50) not null,
    departamento varchar2(50) not null,
	
	constraint ubicaciones_pk primary key (id) enable	
);

comment on table ubicaciones is 'Ubicaciones - Locations'; 
comment on column ubicaciones.id is 'Código de la ubicación'; 
comment on column ubicaciones.municipio is 'Nombre del municipio'; 
comment on column ubicaciones.departamento is 'Nombre del departamento'; 

-- Tabla Cervecerias
create table cervecerias
(
	id int generated always as identity not null,
	nombre varchar2(100) not null,
	ubicacionId int not null,
	sitioWeb varchar2(200) not null,
	instagram varchar2(50) not null,
	
	constraint cervecerias_pk primary key (id) enable
);

comment on table cervecerias is 'Cervecerias - Breweries'; 
comment on column cervecerias.id is 'Código de la cerveceria'; 
comment on column cervecerias.nombre is 'Nombre de la cerveceria'; 
comment on column cervecerias.ubicacion is 'Ubicacion de la cerveceria'; 
comment on column cervecerias.sitioWeb is 'Sitio Web de la cerveceria'; 
comment on column cervecerias.instagram is 'Cuenta de instagram de la cerveceria'; 

alter table cervecerias
 add constraint cervecerias_ubicaciones_fk foreign key (ubicacionId)
	references ubicaciones (id) enable;

-- Tabla Estilos
create table estilos
(
	id int generated always as identity not null,
	nombre varchar2(50) not null,
	
	constraint estilos_pk primary key (id) enable	
);

comment on table estilos is 'Estilos - Styles'; 
comment on column estilos.id is 'Código del estilo'; 
comment on column estilos.nombre is 'Nombre del estilo';

-- Tabla RangosAbv
create table rangosAbv
(
	id int generated always as identity not null,
	nombre varchar2(100) not null,
	valorInicial float not null,
	valorFinal  float not null,
	
	constraint rangosAbv_pk primary key (id) enable
);

comment on table rangosAbv is 'Rangos Alcohol por Volumen - Alcohol by Volume Ranges'; 
comment on column rangosAbv.id is 'Código del rango'; 
comment on column rangosAbv.nombre is 'Nombre del rango';
comment on column rangosAbv.valorInicial is 'Valor inicial del rango';
comment on column rangosAbv.valorFinal is 'Valor final del rango';

-- Tabla RangosIbu
create table rangosIbu
(
	id int generated always as identity not null,
	nombre varchar2(100) not null,
	valorInicial float not null,
	valorFinal  float not null,
	
	constraint rangosIbu_pk primary key (id) enable
);

comment on table rangosIbu is 'Rangos de Unidades Internacionales de Amargor - International Bitterness Units Ranges'; 
comment on column rangosIbu.id is 'Código del rango'; 
comment on column rangosIbu.nombre is 'Nombre del rango';
comment on column rangosIbu.valorInicial is 'Valor inicial del rango';
comment on column rangosIbu.valorFinal is 'Valor final del rango';

-- Tabla Cervezas
create table cervezas
(
	id int generated always as identity not null,
	nombre varchar2(100) not null,
	cerveceriaId int not null,
	estiloId int not null,
	ibu float default 0 not null,
	rangoIbuId float default 1 not null,
	abv float default 0 not null,
	rangoAbvId float default 1 not null,

	constraint cervezas_pk primary key (id) enable
);

alter table cervezas 
	add constraint cervezas_abv_chk check
		(abv between 0 and 12) enable;	 

alter table cervezas 
	add constraint cervezas_ibu_chk check
		(ibu between 0 and 100) enable;		

alter table cervezas
	add constraint cervezas_cervecerias_fk foreign key (cerveceriaId)
	references cervecerias (id) enable;		

alter table cervezas
	add constraint cervezas_rangosAbv_fk foreign key (rangoAbvId)
	references rangosAbv (id) enable;

alter table cervezas
	add constraint cervezas_rangosIbu_fk foreign key (rangoIbuId)
	references rangosIbu (id) enable;


-- ****************************************************
-- Actualización de Rangos Abv y Ibu para las cervezas
-- ****************************************************

-- Actualizacion Rango IBU
update cervezas cv
set rangoIbuId = 
(select distinct id
 from rangosIbu ri where cv.ibu between ri.valorInicial and ri.valorFinal)
 where cv.rangoIbuId is not null;


-- Actualizacion Rango ABV
update cervezas cv
set rangoAbvId = 
(select distinct id
 from rangosAbv ra where cv.abv between ra.valorInicial and ra.valorFinal)
 where cv.rangoAbvid is not null;



-- *****************************************
-- Consultas de verificacion del modelo
-- *****************************************

-- Cervecerías con su ubicación:
select distinct
    c.nombre,
    c.sitioWeb,
    c.instagram,
    (u.municipio || ',' || u.departamento) ubicacion
from cervecerias c join ubicaciones u on c.ubicacionId = u.id;

-- Cervezas con Información General
select distinct
    cv.nombre,
    cr.nombre cerveceria,
    e.nombre estilo,
    cv.ibu,
    ri.nombre rangoIbu,
    cv.abv,    
    ra.nombre rangoAbv    
from cervezas cv join cervecerias cr on cv.cerveceriaId = cr.id
                 join estilos e on cv.estiloId = e.id
                 join rangosIbu ri on cv.rangoIbuId = ri.id
                 join rangosAbv ra on cv.rangoAbvId = ra.id;
