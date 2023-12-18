START TRANSACTION ; 

-- cantidad de polizas por ramo / cia
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_count_polizas ( p_cia varchar(40), p_ramo varchar(40))
returns int
deterministic
BEGIN
	return (select count(ramo) 
	from vw_polizas 
	where cia = lcase(p_cia)
	and ramo = lcase(p_ramo)  
	and id_estado_poliza = 1) 	
    ;
END $$
DELIMITER 

SAVEPOINT fx_count_polizas ;

/* ejemplo
select fx_count_polizas ( 'sancor' , 'ACCIDENTES PERSONALES') as cantidad_polzias; */

-- cambio de estado poliza
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_cambio_estado ( p_poliza varchar (40), p_estado int)
returns varchar(40)
deterministic
begin
	declare resultado varchar(40);
    set resultado = 'realizado';
    update cartera_cliente.polizas
	set id_estado_poliza = p_estado
	where id_poliza= p_poliza;
    set resultado = 'realizado';
    return resultado;
END $$
DELIMITER 

SAVEPOINT fx_cambio_estado ;

/* select cartera_cliete.fx_cambio_estado (10586450, 2) as resultado; */

-- cambio de estado poliza a vencido
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_poliza_vencida ( realizar int)
returns varchar(50)
deterministic
begin
	declare respuesta varchar (40);
    set respuesta = 'ERROR';
	update cartera_cliente.polizas 
	set id_estado_poliza = 6
	where fecha_baja < curdate() 
    and id_estado_poliza = 1;
    set respuesta = 'realizado';
    return respuesta;
END $$
DELIMITER ;

-- cambio de estado poliza a por vencer
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_poliza_avencida ( p_date date)
returns varchar(50)
deterministic
begin
	declare respuesta varchar (40);
    set respuesta = 'ERROR';
	update cartera_cliente.polizas 
	set id_estado_poliza = 11
	where fecha_baja < p_date 
    and id_estado_poliza = 1;
    set respuesta = 'realizado';
    return respuesta;
END $$
DELIMITER ;

SAVEPOINT fx_poliza_vencida;
/* select fx_poliza_vencida (1) as Resultado;*/


-- cambio estado anulada
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_baja_cert ( p_dni_cert varchar (40))
returns varchar(40)
deterministic
begin
	declare resultado varchar(40);
    set resultado = 'realizado';
    update cartera_cliente.certificados_polizas
	set id_estado_certificados = 2     /*estado anulado*/
	where id_certificados_polizas > 0
	where dni_certificado = p_dni_cert ;
    set resultado = 'realizado';
    return resultado;
END $$
DELIMITER 

COMMIT;
 
-- CAMBIO ESTADO DE COBRADO
DROP FUNCTION IF EXISTS cartera_cliente.fx_fact_cobrada;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_fact_cobrada ( p_fact int , p_cobrad int)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' no echo';
    UPDATE cartera_cliente.comsiones_facturas
    set cobrada = p_cobrad
	where numero_factura = p_fact
	;
    set resultado = 'echo';
    return resultado;
END $$
DELIMITER 


--  MODIFICACION DE ESTADO CIVIL DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_est_civil (  p_dni bigint , p_est_civil int)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set id_estado_civil = p_est_civil
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION DE DIRECCION PARTICULAR DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_dir_part (  p_dni bigint , p_dir_part varchar(150) )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set dir_part = p_dir_part
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION DE DIRECCION LEGAL DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_dir_legal (  p_dni bigint , p_dir_legal varchar(150) )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set dir_legal = p_dir_legal
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION DE CODIGO POSTAL DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_cod_posta (  p_dni bigint , p_cod_postal int )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set codigo_postal = p_cod_postal
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION DE TELEFONO DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_tel (  p_dni bigint , p_tel bigint )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set tel = p_tel
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION DE MAIL DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_mail (  p_dni bigint , p_mail varchar(150) )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set mail = p_mail
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION OBSERVACIONES DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_observ (  p_dni bigint , p_observ varchar(150) )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set observ = p_observ
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 


--  MODIFICACION DE RESPRESENTANTE DE CLIENTES
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_represent (  p_dni bigint , p_representante varchar(150) )
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.clientes
    set representante = p_representante
	where id_dni = p_dni
	;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION PRODUCTOR DE POLIZAS
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_productor (  p_polizas bigint , p_productor int)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.polizas
    set id_productor = p_productor
	where id_poliza = p_polizas;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 


--  MODIFICACION DESCRIPCION DE POLIZAS
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_desc_poliza (  p_polizas bigint , p_descrip varchar(150))
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.polizas
    set descrip = p_descrip
	where id_poliza = p_polizas;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 


--  MODIFICACION FORMA DE PAGO  DE POLIZAS
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_froma_pago (  p_polizas bigint , p_forma_pago int)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.polizas
    set id_forma_pago_clientes = p_forma_pago
	where id_poliza = p_polizas;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 

--  MODIFICACION PRIMA DE POLIZAS
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_prima (  p_polizas bigint , p_prima float)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.polizas
    set prima = p_prima
	where id_poliza = p_polizas;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 


--  MODIFICACION PRIMA DE POLIZAS
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_cbutc (  p_polizas bigint , p_cbu_tc bigint)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.polizas
    set cbu_tc = p_cbu_tc
	where id_poliza = p_polizas;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 


--  Refacturacion Poliza
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_refact (  p_polizas bigint , p_refacturacion bigint,  p_prima float)
returns varchar(20)
deterministic
begin
	declare resultado varchar(20);
    set resultado = ' NO REALIZADO';
    UPDATE cartera_cliente.polizas
    set fecha_refacturacion  = p_refacturacion
	where id_poliza = p_polizas;
    UPDATE cartera_cliente.polizas
    set prima = p_prima
	where id_poliza = p_polizas;
    set resultado = 'REALIZADO';
    return resultado;
END $$
DELIMITER 