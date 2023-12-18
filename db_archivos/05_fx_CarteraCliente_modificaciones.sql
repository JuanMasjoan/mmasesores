START TRANSACTION ;


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
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_dir_part;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_dir_part (  p_dni bigint , p_dir_part varchar(150) )
returns varchar(20)
deterministic
begin
	DECLARE v_dias_ult_upd INT;

    UPDATE cartera_cliente.clientes
    set dir_part = p_dir_part
	where id_dni = p_dni;

    SET v_dias_ult_upd = fx_upd_fecha_mod_cl(p_dni);
        
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;
    
    
END $$
DELIMITER


--  MODIFICACION DE DIRECCION LEGAL DE CLIENTES

DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_dir_legal;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_dir_legal (  p_dni bigint , p_dir_legal varchar(150) )
returns varchar(20)
deterministic
begin

	DECLARE v_dias_ult_upd INT;

    UPDATE cartera_cliente.clientes
    set dir_legal = p_dir_legal
	where id_dni = p_dni
	;

    SET v_dias_ult_upd = fx_upd_fecha_mod_cl(p_dni);
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;

END $$
DELIMITER 

SAVEPOINT FX_01_fx_CarteraCliente_modificaciones;

--  MODIFICACION DE CODIGO POSTAL DE CLIENTES
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_cod_posta;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_cod_posta (  p_dni bigint , p_cod_postal int )
returns varchar(20)
deterministic
begin
	DECLARE v_dias_ult_upd INT;
    
    UPDATE cartera_cliente.clientes
    set codigo_postal = p_cod_postal
	where id_dni = p_dni
	;

    SET v_dias_ult_upd = fx_upd_fecha_mod_cl(p_dni);
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;

END $$
DELIMITER 

--  MODIFICACION DE TELEFONO DE CLIENTES
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_tel;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_tel (  p_dni bigint , p_tel bigint )
returns varchar(20)
deterministic
begin
	DECLARE v_dias_ult_upd INT;

    UPDATE cartera_cliente.clientes
    set tel = p_tel
	where id_dni = p_dni
	;

    SET v_dias_ult_upd = fx_upd_fecha_mod_cl(p_dni);
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;
END $$
DELIMITER 

--  MODIFICACION DE MAIL DE CLIENTES
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_mail;

DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_mail (  p_dni bigint , p_mail varchar(150) )
returns varchar(20)
deterministic
begin

	DECLARE v_dias_ult_upd INT;

    UPDATE cartera_cliente.clientes
    set mail = p_mail
	where id_dni = p_dni
	;

    SET v_dias_ult_upd = fx_upd_fecha_mod_cl(p_dni);
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;
END $$
DELIMITER 

SAVEPOINT FX_02_fx_CarteraCliente_modificaciones;


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
END; $$
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
END; $$
DELIMITER 

SAVEPOINT FX_03_fx_CarteraCliente_modificaciones;

--  MODIFICACION DESCRIPCION DE POLIZAS
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_desc_poliza;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_desc_poliza (  p_poliza bigint , p_descrip varchar(150))
returns varchar(20)
deterministic
begin
    DECLARE v_dias_ult_upd INT;

    UPDATE cartera_cliente.polizas
    set descrip = p_descrip
	where id_poliza = p_poliza;

    SET v_dias_ult_upd = fx_upd_fecha_mod_pol(p_poliza);
        
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;

END $$
DELIMITER 

--  MODIFICACION FORMA DE PAGO  DE POLIZAS
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_froma_pago;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_froma_pago (  p_polizas bigint , p_forma_pago int)
RETURNS varchar(20) 
    DETERMINISTIC
deterministic
BEGIN

    DECLARE v_dias_ult_upd INT;
    
	UPDATE cartera_cliente.polizas
    set id_forma_pago_clientes = p_forma_pago
	where id_poliza = p_polizas;
    
    SET v_dias_ult_upd = fx_upd_fecha_mod_pol(p_polizas);
    
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;

return resultado;
END $$
DELIMITER 

SAVEPOINT FX_04_fx_CarteraCliente_modificaciones;

--  MODIFICACION PRIMA DE POLIZAS
DROP FUNCTION IF EXISTS cartera_cliente.fx_mod_prima;

DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_mod_prima ( p_poliza bigint , p_prima float)
returns varchar(20)
deterministic
begin
    DECLARE v_dias_ult_upd INT;

    update cartera_cliente.polizas
	set prima = p_prima
	where id_poliza = p_poliza;

    SET v_dias_ult_upd = fx_upd_fecha_mod_pol(p_poliza);
        
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;
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

SAVEPOINT FX_05_fx_CarteraCliente_modificaciones;

COMMIT; 

