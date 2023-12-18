START TRANSACTION ;

DROP DATABASE IF EXISTS LOG_CARTERA_CLIENTE;
CREATE DATABASE LOG_CARTERA_CLIENTE;
USE LOG_CARTERA_CLIENTE;

SAVEPOINT TG_db;

CREATE TABLE IF NOT EXISTS LOG_POLIZAS (
	id_log_polizas int AUTO_INCREMENT ,
	id_poliza varchar (40),
	id_productor int,
	id_dni  varchar(100),
	id_cia int,
	id_ramo int,
	descrip varchar(150) ,
	fecha_alta date ,
	fecha_baja date ,
	id_forma_pago_clientes int ,
	id_cuotas int ,
	id_ciclo_facturacion int ,
	prima float ,
	id_estado_poliza int ,
	sa_ajustado_dolar tinyint(1) ,
    operacion varchar (50),
	fecha_modificacion_polizas	datetime ,
    primary KEY (id_log_polizas)
    )
;

SAVEPOINT tg_tablal;

-- TRG PARA NUEVAS POLZIAS

    DELIMITER $$ 
 DROP TRIGGER IF EXISTS CARTERA_CLIENTE.TRG_POLIZAS_INSERT $$
 CREATE TRIGGER CARTERA_CLIENTE.TRG_POLIZAS_INSERT BEFORE INSERT ON cartera_cliente.polizas 
 FOR EACH ROW 
   BEGIN
    DECLARE USUARIO VARCHAR(255) ;
    IF  NOT EXISTS (SELECT 1 FROM POLIZAS WHERE id_poliza = NEW.id_poliza) THEN
        SET  USUARIO  = (select  USER  from mysql.user  ORDER BY USER DESC LIMIT 1 ) ;
           INSERT INTO LOG_CARTERA_CLIENTE.LOG_POLIZAS (id_poliza,id_productor,id_dni,id_cia,id_ramo,descrip,fecha_alta,
					fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza,
                    sa_ajustado_dolar,USUARIO, operacion ,fecha_modificacion_polizas) 
       VALUES ( NEW.id_poliza ,NEW.id_productor, NEW.id_dni , NEW.id_cia,NEW.id_ramo, NEW.descrip ,NEW.fecha_alta,
			NEW.fecha_baja,NEW.id_forma_pago_clientes,NEW.id_cuotas, NEW.id_ciclo_facturacion,NEW.prima,NEW.id_estado_poliza,
            NEW.sa_ajustado_dolar,  USUARIO  ,'NUEVA' , NOW() );    
   END IF;
  END
  $$ DELIMITER 
  ;


  DELIMITER $$ 
 DROP TRIGGER IF EXISTS cartera_cliente.TRG_POLIZAS_UPD $$
 CREATE TRIGGER cartera_cliente.TRG_POLIZAS_UPD BEFORE UPDATE ON cartera_cliente.polizas
 FOR EACH ROW 
   BEGIN
    DECLARE USUARIO VARCHAR(255) ;
    IF   NEW.id_productor <> OLD.id_productor  OR NEW.id_forma_pago_clientes <> 
		OLD.id_forma_pago_clientes OR NEW.id_ciclo_facturacion <> OLD.id_ciclo_facturacion OR 
		NEW.prima <> OLD.prima OR NEW.id_estado_poliza <> OLD.id_estado_poliza   THEN
		SET  USUARIO  = (select  USER  from mysql.user  ORDER BY USER DESC LIMIT 1 ) ;
		INSERT INTO LOG_POLIZAS (id_poliza,id_productor,id_dni,id_cia,id_ramo,descrip,fecha_alta,
					fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza,
                    sa_ajustado_dolar,USUARIO, operacion ,fecha_modificacion_polizas) 
			VALUES ( NEW.id_poliza ,NEW.id_productor, NEW.id_dni , NEW.id_cia,NEW.id_ramo, NEW.descrip ,NEW.fecha_alta,
				NEW.fecha_baja,NEW.id_forma_pago_clientes,NEW.id_cuotas, NEW.id_ciclo_facturacion,NEW.prima,NEW.id_estado_poliza,
				NEW.sa_ajustado_dolar,  USUARIO  ,'ACTUALIZACION' , NOW() );
           
   END IF;
  END $$    
DELIMITER ;

SAVEPOINT tg_creacion;
/*
CALL cartera_cliente.SP_ALTA_POLIZA (
 '10571361', 
 2,
 '34838647',
 4, 
 4,
 'SHW884 SENDA', 
 '2022-02-12', 
 '2022-05-12',
 2,
 3, 
 3,
 2826,
 1,
 0)
 ;CALL cartera_cliente.SP_ALTA_POLIZA (
 '10571361', 
 2,
 '34838647',
 4, 
 4,
 'SHW884 SENDA', 
 '2022-02-12', 
 '2022-05-12',
 2,
 3, 
 3,
 2826,
 1,
 0)
 ;
 
 select cartera_cliente.fx_cambio_estado (10143503, 1) as resultado;

COMMIT;
*/
