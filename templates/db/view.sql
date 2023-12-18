START TRANSACTION ;

-- vista de cartera de polizas completa
CREATE OR REPLACE VIEW cartera_cliente.vw_polizas as (
select  p2.productor,cia.cia, r.ramo, p.id_poliza, p.id_dni, cl.nom_apell,
 p.descrip, p.fecha_alta,p.fecha_baja,p.prima,p.fecha_refacturacion, p.sa_ajustado_dolar, fp.forma_pago_cliente,p.cbu_tc,
cp.cantidad_cuotas, cf.ciclo_facturacion,ep.estado_poliza, p.fecha_modificacion_polizas,
ep.id_estado_poliza
from cartera_cliente.polizas p
join cartera_cliente.productor p2 on (p.id_productor = p2.id_productor)
left join cartera_cliente.clientes cl on (p.id_dni = cl.id_dni)
join cartera_cliente.cia cia on (p.id_cia = cia.id_cia)
join cartera_cliente.ramo r on (p.id_ramo = r.id_ramo)
join cartera_cliente.forma_pago_clientes fp on (p.id_forma_pago_clientes = fp.id_forma_pago_clientes)
join cartera_cliente.cuotas_pago cp on (p.id_cuotas = cp.id_cuotas)
join cartera_cliente.ciclo_facturacion cf on (p.id_ciclo_facturacion = cf.id_ciclo_facturacion)
join cartera_cliente.estado_poliza ep on (p.id_estado_poliza = ep.id_estado_poliza)	
);

CREATE OR REPLACE VIEW cartera_cliente.vw_pol_act as (
select * from vw_polizas where id_estado_poliza = 1 or id_estado_poliza = 10);

SAVEPOINT vw_polizas ;

--  POLIZAS EN MORA 
CREATE OR REPLACE VIEW cartera_cliente.vw_polizas_enmora as (
select cia.cia, r.ramo, p.id_poliza, p.id_dni, cl.nom_apell,
 p.descrip, p.fecha_alta,p.fecha_baja, p.fecha_modificacion_polizas,
ep.id_estado_poliza
from cartera_cliente.polizas p
left join cartera_cliente.clientes cl on (p.id_dni = cl.id_dni)
join cartera_cliente.cia cia on (p.id_cia = cia.id_cia)
join cartera_cliente.ramo r on (p.id_ramo = r.id_ramo)
join cartera_cliente.estado_poliza ep on (p.id_estado_poliza = ep.id_estado_poliza)	
where p.id_estado_poliza = 10 )
	order by fecha_modificacion_polizas
;	

SAVEPOINT vw_polizas_conproblemas;

--  POLIZAS VENCIDAS
CREATE OR REPLACE VIEW cartera_cliente.vw_polizas_enmora as (
select cia, ramo, id_poliza as poliza,nom_apell as cliente,id_dni as dni, descrip as descripcion
, fecha_alta as Alta, fecha_baja as Baja ,fecha_refacturacion, estado_poliza as Estado from cartera_cliente.vw_polizas 
	where id_estado_poliza = 6 )
	order by fecha_modificacion_polizas
;

--  POLIZAS A VENCER 
CREATE OR REPLACE VIEW cartera_cliente.vw_polizas_avencer as (
select cia.cia, r.ramo, p.id_poliza, p.id_dni, cl.nom_apell,
 p.descrip,p.fecha_baja,p.fecha_refacturacion
from cartera_cliente.polizas p
left join cartera_cliente.clientes cl on (p.id_dni = cl.id_dni)
join cartera_cliente.cia cia on (p.id_cia = cia.id_cia)
join cartera_cliente.ramo r on (p.id_ramo = r.id_ramo)
join cartera_cliente.estado_poliza ep on (p.id_estado_poliza = ep.id_estado_poliza)	
where p.id_estado_poliza = 11 
order by fecha_modificacion_polizas)
;	
	
-- CLIENTES EN CARTERA
CREATE OR REPLACE VIEW cartera_cliente.vw_clientes as (
select cl.id_dni as DNI, cl.nom_apell as titular , cl.cuit as cuit_cuil ,ec.estado_civil, cl.fecha_nac, 
cl.dir_part ,cl.dir_legal,codigo_postal as CP, prov.provincia, tel, mail, observ, 
fecha_carga_cliente from clientes cl
left join cartera_cliente.estado_civil ec on (cl.id_estado_civil = ec.id_estado_civil)
join cartera_cliente.provincia prov on (cl.id_provincia = prov.id_provincia)
);


SAVEPOINT vw_clientes;

-- siniestros 
CREATE OR REPLACE VIEW cartera_cliente.vw_siniestros as (
select stro.id_siniestro,es.estado_siniestro,stro.numero_siniestro, p.id_poliza,cia.cia, r.ramo,ts.tipo_siniestro,
ts.id_tipo_siniestro,es.id_estado_siniestro,descripcion_siniestro as descripcion, stro.siniestro_ultimo_update 
from cartera_cliente.siniestros stro
join cartera_cliente.polizas p on (p.id_poliza = stro.id_poliza)
join cartera_cliente.cia cia on (stro.id_cia = cia.id_cia)
join cartera_cliente.ramo r on (stro.id_ramo = r.id_ramo)
join cartera_cliente.tipo_siniestro ts on (stro.id_tipo_siniestro = ts.id_tipo_siniestro)
join cartera_cliente.estado_siniestro es on (es.id_estado_siniestro = stro.id_estado_siniestro)
);

SAVEPOINT vw_siniestros;

CREATE OR REPLACE VIEW cartera_cliente.vw_reclamos as (
select rec.id_reclamo, es.estado_siniestro as estado_reclamo ,rec.numero_reclamo, p.id_poliza,p.id_dni as dni,
cia.cia, r.ramo,ts.tipo_siniestro as tipo_reclamo, ts.id_tipo_siniestro as id_tipo_reclamo,
es.id_estado_siniestro as id_estado_reclamo ,descripcion_reclamo as descripcion, rec.reclamo_ultimo_update 
from cartera_cliente.reclamos rec
join cartera_cliente.polizas p on (rec.id_poliza = p.id_poliza)
join cartera_cliente.cia cia on (rec.id_cia = cia.id_cia)
join cartera_cliente.ramo r on (rec.id_ramo = r.id_ramo)
join cartera_cliente.tipo_siniestro ts on (rec.id_tipo_siniestro = ts.id_tipo_siniestro)
join cartera_cliente.estado_siniestro es on (es.id_estado_siniestro = rec.id_estado_siniestro)
);

SAVEPOINT vw_reclamo;

-- cant polizas por cada compañia
CREATE OR REPLACE VIEW cartera_cliente.vw_polizaspor_cia as (
select productor,cia,count(cia) as polzas_activas,estado_poliza
from vw_polizas 
group by cia,productor
having estado_poliza = ' VIGENTE '
order by cia asc
);

-- cant polizas por cada ramo
CREATE OR REPLACE VIEW cartera_cliente.vw_polizaspor_ramo as (
select productor,ramo,count(cia) as polzas_activas,estado_poliza
from vw_polizas 
group by ramo,productor
having estado_poliza = ' VIGENTE '
order by ramo asc
);

-- cant polizas por cada compañia
CREATE OR REPLACE VIEW cartera_cliente.vw_polizaspor_cia_ramo as (
select productor,cia,ramo,count(cia) as polzas_activas,estado_poliza
from vw_polizas 
group by cia,ramo,productor
having estado_poliza = ' VIGENTE '
order by ramo asc
);

-- prom prima por poliza por cada compañia
CREATE OR REPLACE VIEW cartera_cliente.vw_promedio_prima as (
select productor,cia,ramo,avg(prima) as polzas_activas,estado_poliza
from vw_polizas 
group by cia,ramo,productor
having estado_poliza = ' VIGENTE '
order by ramo asc
);

SAVEPOINT vw_promedio_prima;

-- control de polizas por sumas aseguradas en poliza ajustadas a valores en dolares. 
CREATE OR REPLACE VIEW cartera_cliente.vw_poliza_sadolar as (
	select fecha_modificacion_polizas as ultima_actualizacion ,productor, concat(cia, ' - ',
    ramo) as cia , concat (id_poliza, ' - ', nom_apell) as poliza_titular ,descrip, fecha_baja 
    from cartera_cliente.vw_polizas
	where sa_ajustado_dolar = 1
    and id_estado_poliza = 1 
);

-- Formas y condicciones de pago de la cia 
CREATE OR REPLACE VIEW cartera_cliente.vw_forma_pago_cia as (
select cia as Compania, cia_premio_prima as forma_pago, paga_cobranza as cobranza 
from cartera_cliente.forma_pago_comision_cia fp
join cartera_cliente.cia c on (c.id_cia = fp.id_cia)
join cartera_cliente.cia_premio_prima pp on (pp.id_cia_premio_prima = fp.id_cia_premio_prima)
);

SAVEPOINT vw_forma_pago_cia;

-- valor comisiones x cia
create or replace view cartera_cliente.vw_comision as (
select com.id_comision , com.id_cia , com.id_plan_comision , com.id_ramo,com.comision , com.comision_ult_actual,
c.cia, pc.nombre_plan_comision, r.ramo
from cartera_cliente.comision com
join cartera_cliente.cia c on (com.id_cia = c.id_cia)
join cartera_cliente.plan_comision pc on (com.id_plan_comision = pc.id_plan_comision)
join cartera_cliente.ramo r on (com.id_ramo = r.id_ramo)
);
 
-- certificados por cada poliza
CREATE OR REPLACE VIEW cartera_cliente.vw_cert_polizas as (
SELECT cp.id_certificados_polizas, cp.id_dni, c.nom_apell , cp.id_poliza, cp.num_certificados, 
cp.descripcion_certificado, cp.nombre_certificado,cp.dni_certificado, cp.fecha_nacimiento_certificado,
cp.id_estado_certificados, cp.fecha_modificacion_certificados, ec.estado_certificados,
concat (p.fecha_alta, ' - ', p.fecha_baja) as vigencia
FROM cartera_cliente.certificados_polizas cp
join cartera_cliente.clientes c on (cp.id_dni = c.id_dni)
join cartera_cliente.polizas p on (cp.id_poliza = p.id_poliza)
join cartera_cliente.estado_certificados ec on (cp.id_estado_certificados = ec.id_estado_certificados)
);

SAVEPOINT vw_end;


-- certificados ACTIVOS por cada poliza 
CREATE OR REPLACE VIEW cartera_cliente.vw_cert_pol_activos as (
SELECT cp.id_dni as dni, c.nom_apell as tomador , cp.id_poliza as poliza, cp.num_certificados as numero_certificado, 
cp.dni_certificado as dni_asegurado , cp.nombre_certificado as Nombre_asegurado,
 cp.fecha_nacimiento_certificado as fecha_nacimiento, cp.descripcion_certificado as descripion
FROM cartera_cliente.certificados_polizas cp
join cartera_cliente.clientes c on (cp.id_dni = c.id_dni)
join cartera_cliente.polizas p on (cp.id_poliza = p.id_poliza)
join cartera_cliente.estado_certificados ec on (cp.id_estado_certificados = ec.id_estado_certificados)
where cp.id_estado_certificados = 1
);

-- vw de todas las facturas 
create or replace view vw_adm_fac_tot as
(select cf.numero_factura as Factura, cf.tipo_factura as Tipo, cf.fecha_factura fecha,
concat(cf.mes_comisiones, '-',ano_comision) as Periodo, 
c.cia as cia, cf.monto_comisiones as Facturado, cf.retenciones_comisiones as Retenciones,
cf.cobrada as Depositada, cf.fecha_carga_factura as Ultima_actualizacion  
from cartera_cliente.comisiones_facturas cf
join cartera_cliente.cia c on (cf.id_cia = c.id_cia)
order by Periodo)
;

-- vw de facturas NO cobradas
create or replace view vw_adm_fac_pen as
select cf.numero_factura as Factura,cf.fecha_factura fecha, 
concat(cf.mes_comisiones, '-',ano_comision) as Periodo,c.cia as cia,
cf.monto_comisiones as Facturado, cf.fecha_carga_factura as Ultima_actualizacion 
from cartera_cliente.comisiones_facturas cf
join cartera_cliente.cia c on (cf.id_cia = c.id_cia)
where cobrada = 0
order by Periodo;

-- vw de facturas SI cobradas
create or replace view vw_adm_fac_cob as
select cf.numero_factura as Factura,cf.fecha_factura fecha, 
concat(cf.mes_comisiones, '-',ano_comision) as Periodo,c.cia as cia,
cf.monto_comisiones as Facturado,cf.cobrada as Depositada ,cf.fecha_carga_factura as Ultima_actualizacion 
from cartera_cliente.comisiones_facturas cf
join cartera_cliente.cia c on (cf.id_cia = c.id_cia)
where cobrada = 1
order by Periodo;

-- retencion de Facturas
create or replace view vw_adm_fac_cob as
select cf.numero_factura as Factura,cf.fecha_factura fecha, 
concat(cf.mes_comisiones, '-',ano_comision) as Periodo,c.cia as cia,
cf.retenciones_comisiones as Retenciones, cf.fecha_carga_factura as Ultima_actualizacion 
 from cartera_cliente.comisiones_facturas cf
join cartera_cliente.cia c on (cf.id_cia = c.id_cia)
order by Periodo;


COMMIT;