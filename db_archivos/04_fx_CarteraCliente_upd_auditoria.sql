START TRANSACTION ;

-- FX actualizacion en base de dato de modificacion de fila - id poliza
DROP FUNCTION IF EXISTS cartera_cliente.fx_upd_fecha_mod_pol;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_upd_fecha_mod_pol (p_poliza varchar(80)) 
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_dias_ult_upd INT;

    update cartera_cliente.polizas
	set fecha_modificacion_polizas = CURRENT_TIMESTAMP
	where id_poliza= p_poliza;
      
    
    SET ins_pol_renov = ROW_COUNT();
    RETURN ins_pol_renov > 0;
END
$$ DELIMITER 


-- FX actualizacion en base de dato de modificacion de fila - id poliza
DROP FUNCTION IF EXISTS cartera_cliente.fx_upd_fecha_mod_cl;
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_upd_fecha_mod_cl (p_dni bigint) 
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_dias_ult_upd_cliente INT;

    update cartera_cliente.clientes
	set fecha_upd_cliente = CURRENT_TIMESTAMP
	where id_dni= p_dni;
      
    
    SET v_dias_ult_upd_cliente = ROW_COUNT();
    RETURN v_dias_ult_upd_cliente > 0;
END;
$$ DELIMITER 

SAVEPOINT FX_01_fx_CarteraCliente_upd_auditoria;


COMMIT;
