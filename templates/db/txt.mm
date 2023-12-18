-- SINIESTROS --- FALTARIA QUE FIGURE EL NOMBRE DEL CLIENTE ,  TRAER INFO DESDE POLIZA? SOLO TRAERIA DNI.
-- JOIN CON CLIENTES PERO SUMARIA MAS INFO A TRAER A LA TABLA, QUE ESTA EN TABLA POLIZA COMO RAMO Y CIA 


create table bkp_actor as (select * from actor);

SI LE PONES UN WHERE DONDE NO TRAIGA REGISTROS (1=2) SE HACE UN BK DE LA ESTRUCTURA NO DE LOS INSERT

PARA PONER EL DIA NOW()

-- FUNCION SIMPLE
delimiter $$
create definer = `root`@`localhost`
FUNCTION `f_margen` (precio float, preciocompra float) returns float
deterministic
begin
    return round(((preciocompra/precio)-1),2);
end$$

delimiter ;

select f_margen ( 0.10 , 0.25) as Margen;

select  f_margen(q  5890, 4320) as Margen;

SET SQL_SAFE_UPDATES = 0
modificas toda msql desbloqueo
SET SQL_SAFE_UPDATES = 
modificas toda msql bloquea


select productor, id_poliza as poliza, id_dni as dni, nom_apell as Cliente, cia as compania,ramo,
descrip as descripcion,prima,fecha_alta as alta,fecha_baja as baja from vw_polizas 
	where fecha_baja < "2022-02-15";



delete from  bkp_actor  where  actor_id = 1;

select concat ( columna1 ,' ' , columna2 ) as nombre. from table;
	q

select columna, count(*) from tabla `

update tabla
join (
	..
)
set .. 
where..
; `

CMD  <--

cd C:\Program Files\MySQL\MySQL Workbench 8.0
/usr/local/mysql/bin/mysql -u root -p
C:\ProgramData\Microsoft\Windows\Start Menu\Programs>mysql -u root -p

load data load data local infile'/Users/contingencia/Downloads/Productos - Hoja 1.csv' into table productos fields terminated by ',' terminated by '\r\n\




## procedureeee

DELIMITER //
CREATE PROCEDURE SP_PROCEDIMIETOS()
BEGIN

END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SP_PROCEDIMIENTOS1()
BEGIN
*/ clientes
insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values;
END//
DELIMITER ;


parametro de entrada
DELIMITER //
CREATE PROCEDURE SP_PROCEDIMIENTOS3(IN PARAM INT)
BEGIN
SELECT * FROM ORDERS WHERE ORDER_ID = PARAM ;
END//
DELIMITER ;

;

DELIMITER ;

SET @PARAMAETRO1=10; -- PARAMETROS DE ENTRADA Y SALIDA AL TIEMPO SE SETEAN , SE LE ASIGNA VALOR
CALL SP_PROCEDIMIENTOS7(@PARAMAETRO1,4);
SELECT @PARAMAETRO1 ; -- ACÁ VA EL PARAMETRO DE SALIDA 


DELIMITER //
CREATE PROCEDURE SP_INSERT(INOUT  PARAMETRO1 INT , IN PARAMETRO2 CHAR )
BEGIN

 SELECT MAX(AUTOR_ID) INTO PARAMETRO1   FROM AUTORES;
 SET  PARAMETRO1 = PARAMETRO1 + 1 ;
 
INSERT INTO AUTORES  (AUTOR_ID , NOMBRE_COMPLETO)  VALUES  ( PARAMETRO1, PARAMETRO2 );

END//
DELIMITER ;



------ gtrigger
DROP DATABASE IF EXISTS BASE_TRIGGERS ;
CREATE DATABASE BASE_TRIGGERS;
USE BASE_TRIGGERS;
CREATE TABLE  VENTAS  (
ID INT NOT NULL AUTO_INCREMENT,
VENDEDOR VARCHAR(255) NOT NULL, 
PRODUCTO_VENDIDO  VARCHAR(255) NOT NULL, 
CANTIDAD_VENDIDA INT NOT NULL ,
COSTO FLOAT NOT NULL DEFAULT 0.0 ,
PRECIO FLOAT NOT NULL DEFAULT 0.0,
PRIMARY KEY(ID)
);

CREATE TABLE LOG_VENTAS (
ID_AUDITORIA INT NOT NULL AUTO_INCREMENT,
ID INT ,
VENDEDOR VARCHAR(255) , 
PRODUCTO_VENDIDO  VARCHAR(255) , 
CANTIDAD_VENDIDA INT ,
COSTO FLOAT ,
PRECIO FLOAT,
USER_QUE_MODIFICO VARCHAR(255) ,
TIPO_DE_OPERACION VARCHAR(255) ,
FECHA_MODIFICADA TIMESTAMP,
PRIMARY KEY(ID_AUDITORIA)
);

DELIMITER $$ 
 DROP TRIGGER IF EXISTS TRG_VENTAS_INSERT$$
 CREATE TRIGGER TRG_VENTAS_INSERT BEFORE INSERT ON VENTAS 
 FOR EACH ROW 
   BEGIN
    DECLARE USER_Q_MODIFICA VARCHAR(255) ;
    IF  NOT EXISTS (SELECT 1 FROM VENTAS WHERE ID = NEW.ID) THEN
        SET  USER_Q_MODIFICA  = (select  USER  from mysql.user  ORDER BY USER DESC LIMIT 1 ) ;
           INSERT INTO LOG_VENTAS (ID, VENDEDOR , PRODUCTO_VENDIDO , CANTIDAD_VENDIDA,COSTO, PRECIO,USER_QUE_MODIFICO, TIPO_DE_OPERACION,  FECHA_MODIFICADA ) 
       VALUES ( NEW.ID ,NEW.VENDEDOR , NEW.PRODUCTO_VENDIDO , NEW.CANTIDAD_VENDIDA,NEW.COSTO, NEW.PRECIO , USER_Q_MODIFICA ,'INSERT' , NOW() );    
   END IF;
  END $$    
DELIMITER ;

 
  DELIMITER $$ 
 DROP TRIGGER IF EXISTS TRG_VENTAS_UPDATE$$
 CREATE TRIGGER TRG_VENTAS_UPDATE BEFORE UPDATE ON VENTAS 
 FOR EACH ROW 
   BEGIN
    DECLARE USER_Q_MODIFICA VARCHAR(255) ;
    IF   NEW.CANTIDAD_VENDIDA <> OLD.CANTIDAD_VENDIDA  OR NEW.PRODUCTO_VENDIDO <> OLD.PRODUCTO_VENDIDO OR NEW.PRECIO <> OLD.PRECIO  THEN

         SET  USER_Q_MODIFICA  = (select  USER  from mysql.user  ORDER BY USER DESC LIMIT 1 ) ;
           INSERT INTO LOG_VENTAS (ID, VENDEDOR , PRODUCTO_VENDIDO , CANTIDAD_VENDIDA,COSTO, PRECIO,USER_QUE_MODIFICO, TIPO_DE_OPERACION,  FECHA_MODIFICADA ) 
       VALUES ( NEW.ID ,NEW.VENDEDOR , NEW.PRODUCTO_VENDIDO , NEW.CANTIDAD_VENDIDA,NEW.COSTO, NEW.PRECIO , USER_Q_MODIFICA ,'UPDATE' , NOW() );   
           
   END IF;
  END $$    
DELIMITER ;

dato anterior 22 dato actual 3
 
SELECT * FROM  VENTAS ;
SELECT * FROM LOG_VENTAS ;
 
 UPDATE VENTAS SET CANTIDAD_VENDIDA = 3 WHERE ID = 4 ;
 
 SELECT * FROM  VENTAS WHERE ID = 4 ;  -- paso de 22   a ser 3.


bkkk

-- creas un bk de otra tabla.. 
create  table esquema_productivo.nombre_tabla_productiva  as 
( select * from esquemapreproductivo.nombre_tabla_preproductiva ) 


-- CREACIÓN DE 3  USUARIOS 

CREATE USER 'USUARIOUNO_WORKSHOPTRES'@'LOCALHOST' IDENTIFIED BY '123456' ;
CREATE USER 'USUARIODOS_WORKSHOPTRES'@'LOCALHOST' IDENTIFIED BY '789101112' ;
CREATE USER 'USUARIOTRES_WORKSHOPTRES'@'LOCALHOST' IDENTIFIED BY '131415161718' ;

-- PARA EL USUARIO 1 VAMOS A AGREGAR PERMISOS DE SOLO LECTURA PARA UNA TABLA 

GRANT SELECT ON AFTER_CLASS.CLIENTE TO 'USUARIOUNO_WORKSHOPTRES'@'LOCALHOST';
GRANT SELECT ON AFTER_CLASS.PERSONA TO 'USUARIOUNO_WORKSHOPTRES'@'LOCALHOST';


-- PARA EL USUARIO 2 VAMOS A DAR PERMISOS SOBRE TODAS LAS TABLAS DE LECTURA / ESCRITURA

GRANT SELECT, INSERT  ON AFTER_CLASS.CLIENTE TO 'USUARIODOS_WORKSHOPTRES'@'LOCALHOST' ;
GRANT SELECT , INSERT ON AFTER_CLASS.PERSONA TO 'USUARIODOS_WORKSHOPTRES'@'LOCALHOST' ;
GRANT SELECT , INSERT  ON AFTER_CLASS.PRODUCTO TO 'USUARIODOS_WORKSHOPTRES'@'LOCALHOST' ;
GRANT SELECT, INSERT ON AFTER_CLASS.VENTA TO 'USUARIODOS_WORKSHOPTRES'@'LOCALHOST' ;
