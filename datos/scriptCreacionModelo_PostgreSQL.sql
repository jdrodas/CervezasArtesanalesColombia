-- Script de clase - Junio 9 de 2023
-- Curso de Topicos Avanzados de Base de datos
-- Juan Dario Rodas - juand.rodasm@upb.edu.co

--Proyecto: Cervezas Artesanales de Colombia
-- Motor de Base de datos: PostgreSQL 15.x

-- Con usuario Root:

-- crear el esquema la base de datos
create database cervezas_db;

-- crear el usuario con el que se realizarán las acciones
create user cervezas_usr with encrypted password 'unaClav3';

-- asignación de privilegios para el usuario
grant all privileges on database cervezas_db to cervezas_usr;

-- A partir de PostgreSQL 15.x, explicitamente asignar privilegios al schema public
grant all on schema public to cervezas_usr;

-- ********** --
-- IMPORTANTE --
-- ********** --
-- Pésima práctica de seguridad asignarle TODOS los privilegios
-- Si haces "grant all", estás haciendo algo muuuuy malo

-- ==============================================================
-- Coloca en este espacio cual es la solución a este problema
-- basado en lo que estaremos haciendo en el ejercicio

-- ==============================================================

-- Con el esquema/usuario: cervezas_db / cervezas_usr

-- *******************************
-- Creacion de tablas
-- *******************************

-- Tabla Ubicaciones
create table ubicaciones
(
    id  integer generated always as identity
        constraint ubicaciones_pk primary key,
    municipio    varchar(50) not null,
    departamento varchar(50) not null,

    constraint ubicaciones_uk
        unique (municipio, departamento)
);

comment on table ubicaciones is 'Ubicaciones - Locations';
comment on column ubicaciones.id is 'Id de la ubicación';
comment on column ubicaciones.municipio is 'Nombre del municipio';
comment on column ubicaciones.departamento is 'Nombre del departamento'; 


-- Tabla Cervecerias
create table cervecerias
(
    id  integer generated always as identity
        constraint cervecerias_pk primary key,
	nombre      varchar(100) not null,
	ubicacionId integer not null
        constraint cervecerias_ubicaciones_fk references ubicaciones,    
	sitioWeb    varchar(200) not null,
	instagram   varchar(50) not null	
);

comment on table cervecerias is 'Cervecerias - Breweries'; 
comment on column cervecerias.id is 'Id de la cerveceria'; 
comment on column cervecerias.nombre is 'Nombre de la cerveceria'; 
comment on column cervecerias.ubicacionId is 'Id de la Ubicacion de la cerveceria'; 
comment on column cervecerias.sitioWeb is 'Sitio Web de la cerveceria'; 
comment on column cervecerias.instagram is 'Cuenta de instagram de la cerveceria'; 

-- Tabla Estilos
create table estilos
(
    id  integer generated always as identity
        constraint estilos_pk primary key,
    nombre    varchar(50) not null,

    constraint estilos_uk unique (nombre)	
);

comment on table estilos is 'Estilos - Styles'; 
comment on column estilos.id is 'Id del estilo'; 
comment on column estilos.nombre is 'Nombre del estilo';

-- Tabla RangosAbv
create table rangosAbv
(
    id  integer generated always as identity
        constraint rangosAbv_pk primary key,
	nombre varchar(100) not null,
	valorInicial float not null,
	valorFinal  float not null,
	
    constraint rangosAbv_uk unique (nombre)
);

comment on table rangosAbv is 'Rangos Alcohol por Volumen - Alcohol by Volume Ranges'; 
comment on column rangosAbv.id is 'Id del rango'; 
comment on column rangosAbv.nombre is 'Nombre del rango';
comment on column rangosAbv.valorInicial is 'Valor inicial del rango';
comment on column rangosAbv.valorFinal is 'Valor final del rango';

-- Tabla RangosIbu
create table rangosIbu
(
    id  integer generated always as identity
        constraint rangosIbu_pk primary key,
	nombre varchar(100) not null,
	valorInicial float not null,
	valorFinal  float not null,
	
    constraint rangosIbu_uk unique (nombre)
);

comment on table rangosIbu is 'Rangos de Unidades Internacionales de Amargor - International Bitterness Units Ranges'; 
comment on column rangosIbu.id is 'Id del rango'; 
comment on column rangosIbu.nombre is 'Nombre del rango';
comment on column rangosIbu.valorInicial is 'Valor inicial del rango';
comment on column rangosIbu.valorFinal is 'Valor final del rango';

-- Tabla Cervezas
create table cervezas
(
    id  integer generated always as identity
        constraint cervezas_pk primary key,
	nombre varchar(100) not null,
	cerveceriaId int not null,
	estiloId int not null,
	ibu float default 0 not null,
	rangoIbuId int default 1 not null,
	abv float default 0 not null,
	rangoAbvId int default 1 not null
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
    add constraint cervezas_abv_chk
        check (abv between 0 and 12);	 

alter table cervezas 
	add constraint cervezas_ibu_chk 
        check (ibu between 0 and 100);		

alter table cervezas
    add constraint cervezas_cervecerias_fk
        foreign key (cerveceriaid) references cervecerias;

alter table cervezas
	add constraint cervezas_rangosAbv_fk foreign key (rangoAbvId)
	references rangosAbv (id);

alter table cervezas
	add constraint cervezas_rangosIbu_fk foreign key (rangoIbuId)
	references rangosIbu (id);

alter table cervezas
	add constraint cervezas_estilos_fk foreign key (estiloId)
	references estilos (id);



    -- Tabla TiposIngredientes
create table tiposIngredientes
(
	    id  integer generated always as identity
        constraint tiposIngredientes_pk primary key,
	nombre varchar(50) not null,

    constraint tiposIngredientes_uk unique (nombre)
	
);

alter table tiposIngredientes add constraint tiposIngredientes_nombre_uk unique (nombre);

comment on table tiposIngredientes is 'Tipos de Ingredientes - Ingredient types'; 
comment on column tiposIngredientes.id is 'Id del tipo de ingrediente'; 
comment on column tiposIngredientes.nombre is 'Nombre del tipo de ingredientes';

-- Tabla Ingredientes
create table ingredientes
(
	    id  integer generated always as identity
        constraint ingredientes_pk primary key,
	nombre varchar(50) not null,
	tipoIngredienteId int not null,
	
    constraint ingredientes_uk unique (nombre)
);

comment on table ingredientes is 'Ingredientes - Ingredients'; 
comment on column ingredientes.id is 'Id del ingrediente'; 
comment on column ingredientes.nombre is 'Nombre del ingredientes';
comment on column ingredientes.tipoIngredienteId is 'Id del tipo de Ingrediente';

alter table ingredientes
	add constraint ingredientes_tiposIngredientes_fk foreign key 
    (tipoIngredienteId) references tiposIngredientes (id);

-- Tabla IngredientesCervezas
create table ingredientesCervezas
(
    cervezaId int not null,
    ingredienteId int not null
);

alter table ingredientesCervezas add constraint ingredientesCervezas_pk
    primary key (cervezaId, ingredienteId);

Comment on table ingredientesCervezas is 'Ingredientes por cerveza - Beer Ingredients';
comment on column ingredientesCervezas.cervezaId is 'Id de la cerveza';
comment on column ingredientesCervezas.ingredienteId is 'Id del ingrediente';

alter table ingredientesCervezas
    add constraint ingredientesCervezas_cervezas_fk foreign key (cervezaId)
    references cervezas (id);
    
alter table ingredientesCervezas
    add constraint ingredientesCervezas_ingredientes_fk foreign key (ingredienteId)
    references ingredientes (id);   

-- Tabla UnidadesVolumen
create table unidadesVolumen
(
	    id  integer generated always as identity
        constraint unidadesVolumen_pk primary key,
	nombre varchar(50) not null,
	abreviatura varchar(10) not null,

    constraint unidadesVolumen_nombre_uk unique (nombre)	
);

Comment on table unidadesVolumen is 'Unidades de Volumen - Volume Units'; 
comment on column unidadesVolumen.id is 'Id de unidad de volumen'; 
comment on column unidadesVolumen.nombre is 'Nombre de la unidad de volumen';
comment on column unidadesVolumen.abreviatura is 'abreviatura de la unidad de volumen';

-- Tabla Envasados
create table envasados(
	    id  integer generated always as identity
        constraint envasados_pk primary key,
    nombre varchar(50) not null   
);

comment on table envasados is 'Envasados - Packaging'; 
comment on column envasados.id is 'Id del evasado'; 
comment on column envasados.nombre is 'Nombre del envasado';

-- Tabla EnvasadosCervezas
create table envasadosCervezas
(
    cervezaId int not null,
    envasadoId int not null,
	unidadVolumenId int not null,
	volumen int not null
);

alter table envasadosCervezas add constraint envasadosCervezas_pk
    primary key (cervezaId, envasadoId);


comment on table envasadosCervezas is 'Envasados por cerveza - Beer Packaging';
comment on column envasadosCervezas.cervezaId is 'Id de la cerveza';
comment on column envasadosCervezas.envasadoId is 'Id del envasado';
comment on column envasadosCervezas.unidadVolumenId is 'Id de la unidad del volumen';
comment on column envasadosCervezas.volumen is 'Volumen del envasado';

alter table envasadosCervezas
    add constraint envasadosCervezas_cervezas_fk foreign key (cervezaId)
    references cervezas (id);
    
alter table envasadosCervezas
    add constraint ienvasadosCervezas_envasados_fk foreign key (envasadoId)
    references envasados (id);

alter table envasadosCervezas
    add constraint ienvasadosCervezas_unidadesVolumen_fk foreign key (unidadVolumenId)
    references unidadesVolumen (id);

-- ****************************************************
-- Script para ajustar datos
-- Insertar datos de cervezas en tabla temporal cac_cervezas
-- ****************************************************

insert into cervezas
    (nombre,
     cerveceriaid,
     estiloid,
     ibu,
     rangoibuid,
     abv,
     rangoabvid)
select distinct
    cv.nombre,
    c.id cerveceriaId,
    e.id estiloId,
    cv.ibu,
    ibu.id rangoIbuId,
    cv.abv,
    abv.id rangoAbvId
from cac_cervezas cv
    join cervecerias c on cv.cerveceria = c.nombre
    join estilos e on cv.estilo = e.nombre,
    rangosabv abv,
    rangosibu ibu
where cv.ibu between ibu.valorinicial and ibu.valorfinal
and cv.abv between abv.valorinicial and abv.valorfinal


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
