
-- PROYECTO --> Cartera para cliente de seguros
-- CREADO POR -- > Masjoan Juan Cruz

/*   archivo para la creacion de TABLAS ESTATICAS para la base de datos cartera_cliente. 

*/

START TRANSACTION ; 

USE cartera_cliente;


CREATE TABLE IF NOT EXISTS cartera_cliente.estado_civil (
  id_estado_civil INT AUTO_INCREMENT,
  estado_civil VARCHAR(60) NOT NULL UNIQUE,
  PRIMARY KEY (id_estado_civil))
;

CREATE TABLE IF NOT EXISTS cartera_cliente.provincia (
  id_provincia INT AUTO_INCREMENT,
  provincia VARCHAR(100) UNIQUE,
  PRIMARY KEY (id_provincia))
;

-- planes dentro de un ramo
CREATE TABLE IF NOT EXISTS cartera_cliente.plan_comision (
  id_plan_comision INT AUTO_INCREMENT,
  nombre_plan_comision VARCHAR(50) NOT NULL UNIQUE,
  plan_comision_ult_actual datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_plan_comision))
;


SAVEPOINT BD_01_02_db_CarteraCliente_TEstaticas;

CREATE TABLE IF NOT EXISTS cartera_cliente.ramo (
  id_ramo INT AUTO_INCREMENT,
  ramo VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (id_ramo))
;

CREATE TABLE IF NOT EXISTS cartera_cliente.cia_premio_prima (
  id_cia_premio_prima INT AUTO_INCREMENT,
  cia_premio_prima VARCHAR(10) NOT NULL UNIQUE,
  PRIMARY KEY (id_cia_premio_prima))
;

-- de poliza
CREATE TABLE IF NOT EXISTS cartera_cliente.ciclo_facturacion (
  id_ciclo_facturacion INT AUTO_INCREMENT,
  ciclo_facturacion VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (id_ciclo_facturacion))
;

SAVEPOINT BD_02_02_db_CarteraCliente_TEstaticas;

CREATE TABLE IF NOT EXISTS cartera_cliente.cuotas_pago (
  id_cuotas INT AUTO_INCREMENT,
  cantidad_cuotas varchar(10) not null,
  PRIMARY KEY (id_cuotas))
;

-- eft ,  cbu , tc, canje
CREATE TABLE IF NOT EXISTS cartera_cliente.forma_pago_clientes (
  id_forma_pago_clientes INT AUTO_INCREMENT,
  forma_pago_cliente VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (id_forma_pago_clientes))
;

-- baja / nueva / renovacion ...
CREATE TABLE IF NOT EXISTS cartera_cliente.estado_poliza (
  id_estado_poliza INT AUTO_INCREMENT,
  estado_poliza VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (id_estado_poliza))
;

SAVEPOINT BD_03_db_CarteraCliente_TEstaticas;

CREATE TABLE IF NOT EXISTS cartera_cliente.estado_certificados (
  id_estado_certificados INT AUTO_INCREMENT,
  estado_certificados VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (id_estado_certificados))
;

CREATE TABLE IF NOT EXISTS cartera_cliente.tipo_siniestro (
  id_tipo_siniestro INT AUTO_INCREMENT,
  tipo_siniestro VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (id_tipo_siniestro))
;

CREATE TABLE IF NOT EXISTS cartera_cliente.estado_siniestro (
  id_estado_siniestro INT NOT NULL AUTO_INCREMENT,
  estado_siniestro VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (id_estado_siniestro))
;

SAVEPOINT BD_04_db_CarteraCliente_TEstaticas;


-- upd ultima vez de la app
CREATE TABLE IF NOT EXISTS cartera_cliente.tg_fecha_ult_upd (
	id_fecha_ult_upd INT auto_increment,
  fecha_ult_upd date,
  PRIMARY KEY (id_fecha_ult_upd)
 ) ;

SAVEPOINT BD_05_db_CarteraCliente_TEstaticas;


COMMIT;

