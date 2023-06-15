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

alter table ubicaciones add constraint ubicaciones_uk unique (municipio,departamento);

comment on table ubicaciones is 'Ubicaciones - Locations'; 
comment on column ubicaciones.id is 'Id de la ubicación'; 
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
comment on column cervecerias.id is 'Id de la cerveceria'; 
comment on column cervecerias.nombre is 'Nombre de la cerveceria'; 
comment on column cervecerias.ubicacionId is 'Id de la Ubicacion de la cerveceria'; 
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

alter table estilos add constraint estilos_nombre_uk unique (nombre);

comment on table estilos is 'Estilos - Styles'; 
comment on column estilos.id is 'Id del estilo'; 
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
comment on column rangosAbv.id is 'Id del rango'; 
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
comment on column rangosIbu.id is 'Id del rango'; 
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
	rangoIbuId id default 1 not null,
	abv float default 0 not null,
	rangoAbvId id default 1 not null,

	constraint cervezas_pk primary key (id) enable
);

comment on table cervezas is 'Cervezas - Beers'; 
comment on column cervezas.id is 'Id de la cerveza'; 
comment on column cervezas.nombre is 'Nombre de la cerveza';
comment on column cervezas.cerveceriaId is 'Id de la cervecería';
comment on column cervezas.estiloId is 'Id del estilo';
comment on column cervezas.ibu is 'Valor del Amargor';
comment on column cervezas.rangoIbuId is 'Id del rango del amargor';
comment on column cervezas.abv is 'Valor del porcentaje de alcohol';
comment on column cervezas.rangoAbvId is 'Id del Rango del porcentaje de alcohol';


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

alter table cervezas
	add constraint cervezas_estilos_fk foreign key (estiloId)
	references estilos (id) enable;

-- Tabla TiposIngredientes
create table tiposIngredientes
(
	id int generated always as identity not null,
	nombre varchar2(50) not null,
	
	constraint tiposIngredientes_pk primary key (id) enable	
);

alter table tiposIngredientes add constraint tiposIngredientes_nombre_uk unique (nombre);

comment on table tiposIngredientes is 'Tipos de Ingredientes - Ingredient types'; 
comment on column tiposIngredientes.id is 'Id del tipo de ingrediente'; 
comment on column tiposIngredientes.nombre is 'Nombre del tipo de ingredientes';

-- Tabla Ingredientes
create table ingredientes
(
	id int generated always as identity not null,
	nombre varchar2(50) not null,
	tipoIngredienteId int not null,
	
	constraint ingredientes_pk primary key (id) enable	
);

comment on table ingredientes is 'Ingredientes - Ingredients'; 
comment on column ingredientes.id is 'Id del ingrediente'; 
comment on column ingredientes.nombre is 'Nombre del ingredientes';
comment on column ingredientes.tipoIngredienteId is 'Id del tipo de Ingrediente';

alter table ingredientes
	add constraint ingredientes_tiposIngredientes_fk foreign key (tipoIngredienteId)
	references tiposIngredientes (id) enable;

-- Tabla IngredientesCervezas
create table ingredientesCervezas
(
    cervezaId int not null,
    ingredienteId int not null,
    
    constraint ingredientesCervezas_pk primary key
    (cervezaId, ingredienteId) enable
);

Comment on table ingredientesCervezas is 'Ingredientes por cerveza - Beer Ingredients';
comment on column ingredientesCervezas.cervezaId is 'Id de la cerveza';
comment on column ingredientesCervezas.ingredienteId is 'Id del ingrediente';

alter table ingredientesCervezas
    add constraint ingredientesCervezas_cervezas_fk foreign key (cervezaId)
    references cervezas (id) enable;
    
alter table ingredientesCervezas
    add constraint ingredientesCervezas_ingredientes_fk foreign key (ingredienteId)
    references ingredientes (id) enable;

-- Tabla UnidadesVolumen
create table unidadesVolumen
(
	id int generated always as identity not null,
	nombre varchar2(50) not null,
	abreviatura varchar2(10) not null,
    
    constraint unidadesVolumen_pk primary key (id) enable	
);

alter table unidadesVolumen add constraint unidadesVolumen_nombre_uk unique (nombre);

comment on table unidadesVolumen is 'Unidades de Volumen - Volume Units'; 
comment on column unidadesVolumen.id is 'Id de unidad de volumen'; 
comment on column unidadesVolumen.nombre is 'Nombre de la unidad de volumen';
comment on column unidadesVolumen.abreviatura is 'abreviatura de la unidad de volumen';

-- Tabla Envasados
create table envasados(
    id int generated always as identity not null,
    nombre varchar2(50) not null,
    volumen int not null,
    unidadVolumenId int not null,
    
    constraint envasados_pk primary key (id) enable	    
);

alter table envasados 
    add constraint envasados_unidadesVolumen_fk foreign key (unidadVolumenId)
    references unidadesVolumen (id) enable;

comment on table envasados is 'Envasados - Packaging'; 
comment on column envasados.id is 'Id del evasado'; 
comment on column envasados.nombre is 'Nombre del envasado';
comment on column envasados.volumen is 'cantidad de unidades de volumen';
comment on column envasados.unidadVolumenId is 'Id de la unidad de volumen';

-- Tabla IngredientesCervezas
create table envasadosCervezas
(
    cervezaId int not null,
    envasadoId int not null,
    
    constraint envasadosCervezas_pk primary key
    (cervezaId, envasadoId) enable
);

Comment on table envasadosCervezas is 'Envasados por cerveza - Beer Packaging';
comment on column envasadosCervezas.cervezaId is 'Id de la cerveza';
comment on column envasadosCervezas.envasadoId is 'Id del envasado';

alter table envasadosCervezas
    add constraint envasadosCervezas_cervezas_fk foreign key (cervezaId)
    references cervezas (id) enable;
    
alter table envasadosCervezas
    add constraint ienvasadosCervezas_envasados_fk foreign key (envasadoId)
    references envasados (id) enable;



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
    (u.municipio || ', ' || u.departamento) ubicacion
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
