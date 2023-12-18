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




-- cambio de estado poliza a vencido
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_poliza_vencida (p_realizar INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE modifications INT DEFAULT 0;

    IF p_realizar = 1 THEN
        UPDATE cartera_cliente.polizas
        SET id_estado_poliza = 6,
            fecha_modificacion_polizas = CURRENT_TIMESTAMP
        WHERE id_estado_poliza = 1 or 10 or 11
        AND fecha_baja < CURDATE();

        SET modifications = ROW_COUNT();
    END IF;

    RETURN modifications;
END $$
DELIMITER ;

-- cambio de estado poliza a por vencer
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_poliza_avencida (p_fecha_avencer DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE modificaciones INT DEFAULT 0;

    UPDATE cartera_cliente.polizas 
    SET id_estado_poliza = 11,
        fecha_modificacion_polizas = CURRENT_TIMESTAMP
    WHERE fecha_baja < p_fecha_avencer 
    AND id_estado_poliza = 1;

    SELECT ROW_COUNT() INTO modificaciones;
    RETURN modificaciones;
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


 
-- CAMBIO ESTADO DE COBRADO
DROP FUNCTION IF EXISTS cartera_cliente.fx_fact_cobrada;
DELIMITER $$
CREATE FUNCTION fx_fact_cobrada(p_fact int) 
    RETURNS varchar(20) 
    DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(20);
    IF EXISTS (SELECT 1 FROM cartera_cliente.comisiones_facturas WHERE numero_factura = p_fact) THEN
        UPDATE cartera_cliente.comisiones_facturas
        SET cobrada = 1
        WHERE numero_factura = p_fact;
        
        SET resultado = 'echo';
    ELSE
        SET resultado = 'Factura no encontrada';
    END IF;

    RETURN resultado;
END;
$$

DELIMITER ;


--  Refacturacion Poliza
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_refact_precio (  p_polizas bigint , p_refacturacion bigint,  p_prima float)
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

-- Insertar stro nvo
DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_ins_stro( p_numero_siniestro VARCHAR(45), p_id_poliza BIGINT, p_id_tipo_siniestro INT,
            p_id_estado_siniestro INT, p_fecha_siniestro DATETIME, p_comen_stro VARCHAR(300), p_descripcion_siniestro VARCHAR(100) )
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_id_siniestro INT;

    INSERT INTO siniestros (numero_siniestro,id_poliza,id_tipo_siniestro,id_estado_siniestro,
            fecha_siniestro,comen_stro,descripcion_siniestro)
    VALUES (p_numero_siniestro,p_id_poliza,p_id_tipo_siniestro,p_id_estado_siniestro,p_fecha_siniestro,p_comen_stro,
            p_descripcion_siniestro);
    
    SET v_id_siniestro = LAST_INSERT_ID();
    RETURN v_id_siniestro;
END; $$
DELIMITER ;


-- upd Stro
DELIMITER $$
CREATE FUNCTION fx_upd_stro(p_id_siniestro INT,p_id_estado_siniestro INT,
            p_comen_stro VARCHAR(300))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_row_count INT;
    
    UPDATE siniestros SET
        id_estado_siniestro = p_id_estado_siniestro,
        comen_stro = p_comen_stro
    WHERE id_siniestro = p_id_siniestro;
    
    SET v_row_count = ROW_COUNT();
    RETURN v_row_count > 0;
END;
$$
DELIMITER ;



--- MODIFICACIONES POR PAGO EN EFECTIVO en fecha e pago a en mora

DROP FUNCTION IF EXISTS cartera_cliente.fx_poliza_efect ;

DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_poliza_efect (fecha_a_comparar DATE, p_fecha DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE modificaciones INT DEFAULT 0;

    DECLARE dia_comparar INT;
    SET dia_comparar = DAY(NOW());

    UPDATE cartera_cliente.polizas 
    SET id_estado_poliza = 10,
        fecha_modificacion_polizas = CURRENT_TIMESTAMP
    WHERE  id_forma_pago_clientes = 1 
       AND id_estado_poliza = 1
       AND  DAY(fecha_baja) BETWEEN DAY(fecha_a_comparar) AND dia_comparar
       AND fecha_modificacion_polizas >= p_fecha;



    SELECT ROW_COUNT() INTO modificaciones;
    RETURN modificaciones;
END $$

DELIMITER ;

-- actualizacion de app

DELIMITER $$

CREATE FUNCTION `fx_upd_app`(p_realizar int) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_row_count INT;
    
    INSERT INTO cartera_cliente.tg_fecha_ult_upd (fecha_ult_upd)
    VALUES (NOW());
    
    SET v_row_count = ROW_COUNT();
    RETURN v_row_count > 0;
END
$$  DELIMITER;

--  ultimo upd de base de datos
DELIMITER $$

CREATE FUNCTION `fx_dias_ult_upd`(p_realizar int) 
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_dias_ult_upd INT;
    
    SELECT DATEDIFF(NOW(), MAX(fecha_ult_upd))  INTO v_dias_ult_upd FROM tg_fecha_ult_upd
    
   
    RETURN v_dias_ult_upd
END
$$ DELIMITER ; 

-- FX ins poliza renovada

DROP FUNCTION IF EXISTS cartera_cliente.fx_alta_poliza_renov;
DELIMITER $$
CREATE FUNCTION fx_alta_poliza_renov ( par_poliza varchar(40), par_productor int,
 par_dni varchar(100), par_cia int, par_ramo int, par_descrip varchar(150), par_fecha_alta date,
 par_fecha_baja date,  par_refacturacion date, par_forma_pago int, par_cbu_tc varchar(1000), 
 par_cuotas int, par_ciclo_facturacion int, par_prima int,par_estado int, par_ajustado_dolar tinyint(1), par_poliza_renov tinyint(1))
    RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE ins_pol_renov INT;

    insert into cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,fecha_alta,
     fecha_baja,fecha_refacturacion,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza,
        sa_ajustado_dolar, cbu_tc, poliza_renov)

        values (par_poliza, par_productor,par_dni,par_cia,par_ramo,par_descrip,par_fecha_alta,
        par_fecha_baja,par_refacturacion,par_forma_pago,par_cuotas,par_ciclo_facturacion,par_prima,
        par_estado,par_ajustado_dolar, par_cbu_tc,par_poliza_renov);
    
    SET ins_pol_renov = ROW_COUNT();
    RETURN ins_pol_renov > 0;
END

$$ DELIMITER;



-- cambio de estado poliza
DROP FUNCTION IF EXISTS cartera_cliente.fx_cambio_estado;

DELIMITER $$
CREATE FUNCTION cartera_cliente.fx_cambio_estado ( p_poliza varchar (40), p_estado int)
returns varchar(40)
deterministic
begin
    DECLARE v_dias_ult_upd INT;
    
    update cartera_cliente.polizas
	set id_estado_poliza = p_estado
	where id_poliza= p_poliza;

    SET v_dias_ult_upd = fx_upd_fecha_mod_pol(p_poliza);
        
    SET v_dias_ult_upd= ROW_COUNT();
    RETURN v_dias_ult_upd > 0;
END $$
DELIMITER 

SAVEPOINT fx_cambio_estado ;

DELIMITER $$

CREATE FUNCTION cartera_cliente.busc_cia(p_cuit_cia BIGINT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE id_cia INT;

    SELECT id_cia INTO id_cia
    FROM cia
    WHERE cuit_cia = p_cuit_cia;

    RETURN id_cia;
END;
$$
DELIMITER ;

--- INSERT DE CARGA DE FACTURAS
DROP FUNCTION IF EXISTS cartera_cliente.fx_carga_factura;
DELIMITER $$

CREATE FUNCTION cartera_cliente.fx_carga_factura (p_numero_factura INT, p_fecha_factura DATE,
                                     p_tipo_factura VARCHAR(10), p_id_cia INT, p_mes_comisiones INT,
                                     p_monto_comisiones INT, p_retenciones_comisiones INT, p_cobrada BOOLEAN,
                                     p_ano_comision INT, p_pto_venta INT, p_titular_factura VARCHAR(200))
RETURNS INT
DETERMINISTIC
BEGIN

    DECLARE ins_pol_renov INT;

    INSERT INTO cartera_cliente.comisiones_facturas(numero_factura,fecha_factura,tipo_factura, id_cia, mes_comisiones, monto_comisiones,
                                            retenciones_comisiones, cobrada, ano_comision, pto_venta, titular_factura)
    VALUES (p_numero_factura, p_fecha_factura, p_tipo_factura, p_id_cia, p_mes_comisiones, p_monto_comisiones, p_retenciones_comisiones,
        p_cobrada, p_ano_comision, p_pto_venta, p_titular_factura);

    SET ins_pol_renov = ROW_COUNT();
    RETURN ins_pol_renov > 0;

END;
$$ DELIMITER



COMMIT;

