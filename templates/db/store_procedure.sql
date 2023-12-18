START TRANSACTION ; 

/* esto es para agregar clientes nuevos*/
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_CLIENTES;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_ALTA_CLIENTES(in par_id_dni varchar(100), in par_nom_apell varchar(200), 
in par_cuit bigint, in par_representante varchar(100),in par_fecha_nac date,in par_id_estado_civil int,
in par_dir_part varchar(150),in par_dir_legal varchar(150),in par_codigo_postal int,in par_id_provincia int,
in par_tel varchar(150), in par_mail varchar(150), in observ varchar(150))
BEGIN
/* clientes */
    insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
        dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ,cuit)
        values (par_id_dni,par_nom_apell,par_representante,par_fecha_nac,par_id_estado_civil,par_dir_part,
        par_dir_legal,par_codigo_postal,par_id_provincia,par_tel,par_mail,observ, par_cuit);
END
$$ DELIMITER ;

SAVEPOINT SP_ALTA_CLIENTES;

-- ordenar siniestros por lo que quiera
DROP PROCEDURE IF EXISTS CARTERA_CLIENTE.SP_ORDENAR_SINIESTROS ;
DELIMITER $$
CREATE PROCEDURE CARTERA_CLIENTE.SP_ORDENAR_SINIESTROS (INOUT column_to_orden VARCHAR(50) ,
 INOUT column_asc_desc VARCHAR(50))
BEGIN
  SET @ordenar = CONCAT('SELECT * FROM cartera_cliente.vw_siniestros stro order by ',
     column_to_orden,' ',column_asc_desc);  
  PREPARE param_stmt FROM @ordenar;
  EXECUTE param_stmt;  
  DEALLOCATE PREPARE param_ordenar;
END 
$$ DELIMITER ;

SAVEPOINT SP_ORDENAR_SINIESTROS;
/* SET @column_to_orden = 'estado_siniestro';
SET @column_asc_desc = 'asc'; 
CALL CARTERA_CLIENTE.SP_ORDENAR_SINIESTROS (@column_to_orden, @column_asc_desc); */
0
-- alta de polizas nueva 
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_POLIZA;
DELIMITER $$
create PROCEDURE cartera_cliente.SP_ALTA_POLIZA (IN par_poliza varchar(40),IN par_productor int,
IN par_dni varchar(100),IN par_cia int,IN par_ramo int,IN par_descrip varchar(150),IN par_fecha_alta date,
IN par_fecha_baja date, in par_refacturacion date,IN par_forma_pago int,in par_cbu_tc bigint, 
IN par_cuotas int,IN par_ciclo_facturacion int,
IN par_prima int,IN par_estado int,IN par_ajustado_dolar tinyint(1))
BEGIN
    insert into cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,fecha_alta,
        fecha_baja,fecha_refacturacion,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza,
        sa_ajustado_dolar, cbu_tc)
        values (par_poliza, par_productor,par_dni,par_cia,par_ramo,par_descrip,par_fecha_alta,
        par_fecha_baja,par_refacturacion,par_forma_pago,par_cuotas,par_ciclo_facturacion,par_prima,
        par_estado,par_ajustado_dolar, par_cbu_tc);
END
$$ DELIMITER;

SAVEPOINT SP_ORDENAR_SINIESTROS;
/*CALL cartera_cliente.SP_ALTA_POLIZA (
 '10571361', 2,'34838647',4,4, 'SHW884 SENDA', '2022-02-12','2022-05-12',2,3,3,2826,1,0);*/

-- CARGA DE FACTURAS
DROP PROCEDURE IF EXISTS cartera_cliente.SP_CARGA_FACTURA;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_CARGA_FACTURA (in p_factura int,in p_fecha_factura date,in tipo_factura varchar (5),
in id_cia int,in mes_comisiones int,in monto_comisiones float,in retenciones_comisiones float,in cobrada tinyint(1))
	begin
		insert into cartera_cliente.comisiones_facturas (numero_factura,fecha_factura,tipo_factura,id_cia,mes_comisiones,
			monto_comisiones,retenciones_comisiones,cobrada)
		values (p_factura,p_fecha_factura,tipo_factura,id_cia,mes_comisiones,
			monto_comisiones,retenciones_comisiones,cobrada);
	end	
$$ DELIMITER ;

SAVEPOINT SP_CARGA_FACTURA;
/* CALL cartera_cliente.SP_CARGA_FACTURA(
  <{in p_factura int}>,
  <{in p_fecha_factura date}>, 
  <{in tipo_factura varchar (5)}>,
  <{in id_cia int}>,
  <{in mes_comisiones int}>,
  <{in monto_comisiones float}>, 
  <{in retenciones_comisiones float}>,
  <{in cobrada tinyint(1)}>);
*/

-- COMPARA LAS COMISIONES POR RAMO
DROP PROCEDURE IF EXISTS SP_COMISIONESXRAMO;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_COMISIONESXRAMO ( inout ramo_buscar int)
BEGIN 
-- COMPARA LAS COMISIONES POR RAMO
	select cia as compania, ramo, nombre_plan_comision, comision from vw_comision
	WHERE id_ramo = ramo_buscar
	order by comision desc
;
END
$$ DELIMITER ;

SAVEPOINT SP_COMISIONESXRAMO;

-- COMPARA LAS COMISIONES POR RAMO
DROP PROCEDURE IF EXISTS SP_COMISIONESXCIA;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_COMISIONESXCIA ( inout cia_buscar int)
BEGIN 
-- COMPARA LAS COMISIONES POR RAMO
	select cia as compania, ramo, nombre_plan_comision, comision from vw_comision
	WHERE id_cia = cia_buscar
	order by comision desc
;
$$ DELIMITER ;

-- buscador de certificados por poliza
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_CERTXPOLIZA ( inout poliza_buscar int)
BEGIN 
-- buscador de certificados por poliza
	select id_dni as DNI, nom_apell as cliente, id_poliza as poliza, descripcion_certificado as descripcion,
	dni_certificado,nombre_certificado, fecha_nacimiento_certificado as nacimiento, estado_certificados, vigencia
	 from vw_cert_polizas
     where id_poliza = poliza_buscar
;
END
$$ DELIMITER ; 

SAVEPOINT SP_END;

/* ALTA DE CERT EN POLIZA EXISTENTE*/
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_CERT;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_ALTA_CERT (in p_dni bigint, in p_poliza bigint,
in p_numcert int, in p_desc varchar(100), in p_dni_cert int, p_nom_cert varchar(45), in p_nac_cert date)
BEGIN
	insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
		values (p_dni, p_poliza, p_numcert, p_desc, p_dni_cert, p_nom_cert, p_nac_cert,1);
END
$$ DELIMITER ;



/* Renovacion de poliza s*/
DROP PROCEDURE IF EXISTS cartera_cliente.SP_RENOVACION_POLIZA;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_RENOVACION_POLIZA  (IN p_param varchar(40), in p_nueva varchar(40),
in p_alta date, in p_baja date, p_prima float)
begin

insert into cartera_cliente.polizas (id_poliza, id_productor, id_dni,id_cia, id_ramo, descrip, fecha_alta,
fecha_baja, id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza,sa_ajustado_dolar)
values ( p_nueva,   
(select id_productor from cartera_cliente.polizas where id_poliza = p_param),
(select id_dni from cartera_cliente.polizas where id_poliza = p_param),
(select id_cia from cartera_cliente.polizas where id_poliza = p_param),
(select id_ramo from cartera_cliente.polizas where id_poliza = p_param),
(select descrip from cartera_cliente.polizas where id_poliza = p_param),
p_alta,
p_baja,
(select id_forma_pago_clientes from cartera_cliente.polizas where id_poliza = p_param),
(select id_cuotas from cartera_cliente.polizas where id_poliza = p_param),
(select id_ciclo_facturacion from cartera_cliente.polizas where id_poliza = p_param),
p_prima,
1,
(select sa_ajustado_dolar from cartera_cliente.polizas where id_poliza = p_param));

END
$$ DELIMITER ;


-- alta de USUARIO
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_USUARIO;
DELIMITER $$
create PROCEDURE  cartera_cliente.SP_ALTA_USUARIO (IN par_user varchar(50),
IN par_pass varchar(200))
BEGIN
    insert into cartera_cliente.user (username, password)
        values (par_user,par_pass);
END
$$ DELIMITER;