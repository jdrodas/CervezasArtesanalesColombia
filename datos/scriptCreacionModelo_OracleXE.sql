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

-- Tabla Cervecerias
create table cervecerias
(
	id int generated always as identity not null,
	nombre varchar2(100) not null,
	ubicacion varchar2(200) not null,
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

-- Tabla Estilos
create table estilos
{
	id int generated always as identity not null,
	nombre varchar2(50) not null,
	
	constraint estilos_pk primary key (id) enable	
};

comment on table estilos is 'Estilos - Styles'; 
comment on column estilos.id is 'Código del estilo'; 
comment on column estilos.nombre is 'Nombre del estilo'; 
