/*Buenas tardes, mi nombre es juan cruz y trabajo como productor de seguros. Mi temática para este curso 
seria terminar de armar una base de datos para poder mejorar la forma de trabajar, darles rapidez de respuesta 
a los clientes y reducir el tiempo de trabajo para el productor. Al dia de hoy se puede usar para ver vencimientos
a una fecha determinada, calcular sumas de primas (precio del seguro) como también sus máximas y mínimas. Además la
uso para buscar información específica o filtrar por alguna dato que necesite en el momento, ya sea para enviar 
información o hacer alguna evaluación de rendimientos. Otra de las ideas que le ayudarian a este proyecto final 
seria poder tener un seguimiento de la ultima charla con un determinado cliente con alguna observación de la misma
para que a la próxima visita(también tener un control de visitas para “no olvidarte del cliente”) uno puede sacar esa 
servación y transformarlo como venta o seguir afianzando la confianza. Mi idea final seria poder diseñar una base de 
datos la cual pueda ser usada por otro productor para que con ella pueda reducir su tiempo de trabajo  sin tomar 
riesgos sobre su cartera y con este tiempo libre poder dedicar  para lo que uno quiera. 

*/

-- PROYECTO --> Cartera para cliente de seguros
-- CREADO POR -- > Masjoan Juan Cruz

START TRANSACTION ; 

CREATE SCHEMA IF NOT EXISTS cartera_cliente ;
COMMIT ;

SET  FOREIGN_KEY_CHECKS=0;
USE cartera_cliente;


/* --tabla para el inicio de seccion
CREATE TABLE IF NOT EXISTS cartera_cliente.user (
  id INT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(200) NOT NULL,
  PRIMARY KEY (id),
; */

CREATE TABLE IF NOT EXISTS cartera_cliente.productor (
  id_productor INT  AUTO_INCREMENT,
  productor VARCHAR(100) NOT NULL UNIQUE,
  matricula INT NOT NULL,
  organizador VARCHAR(100) NULL DEFAULT NULL,
  /*id INT(11) NOT NULL,*/
  productor_actualizacion datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_productor)
  /* CONSTRAINT 'fkproductor_id_user 'FOREIGN KEY (id) REFERENCES cartera_cliente.user (id) ON DELETE CASCADE */)
;

SAVEPOINT bd_productor;

CREATE TABLE IF NOT EXISTS cartera_cliente.cia (
  id_cia INT AUTO_INCREMENT,
  cia VARCHAR(50) NOT NULL UNIQUE,
  ejecutivo VARCHAR(100) NOT NULL,
  telefono VARCHAR(50) ,
  correo VARCHAR(100) NOT NULL,
  codigo_cia INT NULL DEFAULT NULL UNIQUE,
  cuit_cia bigint , 
  PRIMARY KEY (id_cia))
;

CREATE TABLE IF NOT EXISTS cartera_cliente.clientes (
  id_dni BIGINT UNIQUE,
  nom_apell VARCHAR(200) NOT NULL ,
  representante VARCHAR(150) ,
  cuit BIGINT,
  fecha_nac DATE NULL,
  id_estado_civil INT NULL,
  dir_part VARCHAR(150)  NULL,
  dir_legal VARCHAR(150) NULL,
  codigo_postal INT NOT NULL,
  id_provincia INT not null,
  tel BIGINT NULL,
  mail VARCHAR(150) NULL,
  observ VARCHAR(150) NULL ,
  fecha_carga_cliente datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_upd_cliente datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_dni, nom_apell),
  CONSTRAINT fkcliente_id_estado_civil FOREIGN KEY  (id_estado_civil) REFERENCES cartera_cliente.estado_civil (id_estado_civil),
  CONSTRAINT fkcliente_id_provincia FOREIGN KEY  (id_provincia) REFERENCES cartera_cliente.provincia (id_provincia))
;

SAVEPOINT bd_clientes;


CREATE TABLE IF NOT EXISTS cartera_cliente.comisiones_facturas (
  id_num_factura INT AUTO_INCREMENT,
  numero_factura INT UNSIGNED UNIQUE NOT NULL,
  fecha_factura DATE NOT NULL,
  tipo_factura VARCHAR(5) NOT NULL,
  id_cia INT NOT NULL,
  mes_comisiones INT NOT NULL,
  ano_comision int not null,
  monto_comisiones FLOAT NOT NULL,
  retenciones_comisiones FLOAT NOT NULL,
  cobrada boolean NULL DEFAULT NULL,
  fecha_carga_factura datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ano_comision int ,
  pto_venta int,
  retenciones_comisiones varchar(100),
  PRIMARY KEY (id_num_factura),
  CONSTRAINT fkcomisionfacturas_id_cia FOREIGN KEY (id_cia) REFERENCES cartera_cliente.cia (id_cia))
;


-- si paga a $prima o $premio la cia y quien paga la cobranza
CREATE TABLE IF NOT EXISTS cartera_cliente.forma_pago_comision_cia (
  id_forma_pago_comision_cia INT AUTO_INCREMENT,
  id_cia INT UNIQUE,
  id_cia_premio_prima INT NOT NULL,
  paga_cobranza boolean NOT NULL,
  forma_pago_comision_cia_ult_actualiz datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_forma_pago_comision_cia),
  CONSTRAINT fkcomisioncia_id_cia FOREIGN KEY (id_cia) REFERENCES cartera_cliente.cia (id_cia),
  CONSTRAINT fkcomisioncia_id_cia_premio_prima FOREIGN KEY (id_cia_premio_prima) REFERENCES cartera_cliente.cia_premio_prima (id_cia_premio_prima))
;

SAVEPOINT bd_forma_pago_comision_cia;

-- comision a cobrar por ramo
CREATE TABLE IF NOT EXISTS cartera_cliente.comision (
  id_comision INT AUTO_INCREMENT,
  id_cia INT NOT NULL,
  id_plan_comision INT NOT NULL DEFAULT '2',
  id_ramo INT NOT NULL,
  comision FLOAT NOT NULL,
  comision_ult_actual datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_comision),
  CONSTRAINT fkcomision_id_cia FOREIGN KEY (id_cia) REFERENCES cartera_cliente.cia (id_cia),
  CONSTRAINT fkcomision_id_plan_comision FOREIGN KEY (id_plan_comision) REFERENCES cartera_cliente.plan_comision (id_plan_comision),
  CONSTRAINT fkcomision_ramo FOREIGN KEY (id_ramo) REFERENCES cartera_cliente.ramo (id_ramo))
;



SAVEPOINT bd_contacto_cliente;


-- PARA ENVIAR A CLIENTE PARA COTIZAR
CREATE TABLE IF NOT EXISTS cartera_cliente.info_a_pedir (
  id_info_a_pedir INT AUTO_INCREMENT,
  id_ramo INT NOT NULL UNIQUE,
  listado_info_pedir_al_cliente VARCHAR(500) NOT NULL,
  info_a_pedir_ult_actual datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_info_a_pedir),
  CONSTRAINT fkinfoapedir_id_ramo FOREIGN KEY (id_ramo) REFERENCES cartera_cliente.ramo (id_ramo))
;

/*
-- dist forma de pago de poliza 
-- 02/01/22 SEPARAR 2 FK EN TABLAS SEPARADAS Y AGREGADAS A TABLA POLIZA -- 02/03 SE EVALUA SI CONVIENE
CREATE TABLE IF NOT EXISTS cartera_cliente.pago_clientes (
  id_pago_clientes INT AUTO_INCREMENT,
  id_forma_pago_clientes INT NOT NULL,
  id_cuotas INT NOT NULL,
  PRIMARY KEY (id_pago_cliente),
  CONSTRAINT fkpagoclientes_id_forma_pago_clientes FOREIGN KEY (id_forma_pago_clientes) REFERENCES cartera_cliente.forma_pago_cliente (id_forma_pago),
  CONSTRAINT fkpagoclientes_id_cuotas FOREIGN KEY (id_cuotas) REFERENCES cartera_cliente.cuotas_pago (id_cuotas))
;     
*/

CREATE TABLE IF NOT EXISTS cartera_cliente.polizas (
  id_poliza BIGINT,
  id_productor INT NOT NULL,
  id_dni BIGINT NOT NULL,
  id_cia INT NOT NULL,
  id_ramo INT NOT NULL,
  descrip VARCHAR(150) NULL,
  fecha_alta DATE NOT NULL,
  fecha_baja DATE NOT NULL,
  fecha_refacturacion date null,
  /*id_pago_cliente INT NOT NULL,    OBSERVACIONES EN CREATE PAGO_CLIENTE . */
  id_forma_pago_clientes INT NOT NULL,
  id_cuotas INT NOT NULL,
  id_ciclo_facturacion INT NOT NULL,
  prima FLOAT NOT NULL,
  id_estado_poliza INT NOT NULL,
  sa_ajustado_dolar boolean NULL,
  fecha_modificacion_polizas datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_modificacion_polizas datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_poliza),
  CONSTRAINT fkpolizas_id_cia FOREIGN KEY (id_cia) REFERENCES cartera_cliente.cia (id_cia),
  CONSTRAINT fkpolizas_id_dni FOREIGN KEY (id_dni) REFERENCES cartera_cliente.clientes (id_dni) ON DELETE CASCADE,
  CONSTRAINT fkpolizas_id_ramo FOREIGN KEY (id_ramo) REFERENCES cartera_cliente.ramo (id_ramo),
  /*CONSTRAINT fkpolizas_id_pago_cliente FOREIGN KEY (id_pago_cliente) REFERENCES cartera_cliente.pago_cliente (id_pago_cliente),*/
  CONSTRAINT fkpolizas_id_forma_pago_clientes FOREIGN KEY (id_forma_pago_clientes) REFERENCES cartera_cliente.forma_pago_clientes (id_forma_pago_clientes),
  CONSTRAINT fkpolizas_id_cuotas FOREIGN KEY (id_cuotas) REFERENCES cartera_cliente.cuotas_pago (id_cuotas),
  CONSTRAINT fkpolizas_id_ciclo_facturacion FOREIGN KEY (id_ciclo_facturacion) REFERENCES cartera_cliente.ciclo_facturacion (id_ciclo_facturacion),
  CONSTRAINT fkpolizas_id_productor FOREIGN KEY (id_productor) REFERENCES cartera_cliente.productor (id_productor) ON DELETE CASCADE,
  CONSTRAINT fkpolizas_estado_poliza FOREIGN KEY (id_estado_poliza) REFERENCES cartera_cliente.estado_poliza (id_estado_poliza))
;

SAVEPOINT bd_polizas;

-- para el momento de mantenimiento de cartera
CREATE TABLE IF NOT EXISTS cartera_cliente.contacto_cliente (
  id_contacto_cliente INT AUTO_INCREMENT,
  utlimo_contacto_cliente DATE,
  vencimiento_contacto_cliente DATE,
  comentarios VARCHAR(250) NOT NULL,
  id_poliza bigint NOT NULL,
  PRIMARY KEY (id_contacto_cliente),
  CONSTRAINT fkid_poliza FOREIGN KEY (id_poliza) REFERENCES cartera_cliente.polizas (id_poliza) ON DELETE CASCADE )
;





-- certificados de autos/ap (falata crear para AP uniones)
CREATE TABLE IF NOT EXISTS cartera_cliente.certificados_polizas (
  id_certificados_polizas INT AUTO_INCREMENT,
  id_dni BIGINT NOT NULL,
  id_poliza BIGINT NOT NULL,
  num_certificados INT UNSIGNED NOT NULL,
  descripcion_certificado VARCHAR(100), 
  dni_certificado INT UNSIGNED,
  nombre_certificado VARCHAR(45) ,
  fecha_nacimiento_certificado DATE,
  id_estado_certificados INT NOT NULL,
  fecha_modificacion_certificados datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_certificados_polizas),
  CONSTRAINT fkcertificados_id_poliza FOREIGN KEY (id_poliza) REFERENCES cartera_cliente.polizas (id_poliza) ON DELETE CASCADE,
  CONSTRAINT fkcertificados_id_dni FOREIGN KEY (id_dni) REFERENCES cartera_cliente.clientes (id_dni) ON DELETE CASCADE,
  CONSTRAINT fkcertificados_id_estado_certificados FOREIGN KEY (id_estado_certificados) REFERENCES cartera_cliente.estado_certificados (id_estado_certificados))
;

SAVEPOINT bd_certificados_polizas;

-- siniestros de asegurados y terceros
CREATE TABLE IF NOT EXISTS cartera_cliente.siniestros (
  id_siniestro INT AUTO_INCREMENT,
  numero_siniestro VARCHAR(45) NULL DEFAULT '\" STRO PENDIENTE DE RESPUESTA\"',
  id_poliza BIGINT NOT NULL,
  id_tipo_siniestro INT NOT NULL,
  id_estado_siniestro INT NOT NULL,
  fecha_siniestro datetime not null,
  comen_stro varchar(400) DEFAULT NULL,
  descripcion_siniestro LONGTEXT,
  siniestro_ultimo_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  hora_siniestro time,
  ubicacion_siniestro varchar(80),
  PRIMARY KEY (id_siniestro),
  CONSTRAINT fksiniestro_id_poliza FOREIGN KEY (id_poliza) REFERENCES cartera_cliente.polizas (id_poliza) ON DELETE CASCADE,
  CONSTRAINT fksiniestro_id_tipo_siniestro FOREIGN KEY (id_tipo_siniestro) REFERENCES cartera_cliente.tipo_siniestro (id_tipo_siniestro),
  CONSTRAINT fksiniestro_id_estado_siniestro FOREIGN KEY (id_estado_siniestro) REFERENCES cartera_cliente.estado_siniestro (id_estado_siniestro))
;

SAVEPOINT bd_siniestros;

-- reclamos, misma tabla de tipo y estado de siniestro - - VER SI CONVIENE DIFFERENCIAR - MISMAS RESPUESTAS
CREATE TABLE IF NOT EXISTS cartera_cliente.reclamos (
  id_reclamo INT AUTO_INCREMENT,
  numero_reclamo VARCHAR(45) NULL DEFAULT '\"RECLAMO PENDIENTE DE RESPUESTA\"',
  id_poliza BIGINT NOT NULL,
  id_cia INT NOT NULL,
  id_ramo INT NOT NULL,
  id_tipo_siniestro INT NOT NULL,
  id_estado_siniestro INT NOT NULL,
  fecha_reclamo datetime not null,
  descripcion_reclamo VARCHAR(100) NULL,
  reclamo_ultimo_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_reclamo), 
  CONSTRAINT fkreclamo_id_cia FOREIGN KEY (id_cia) REFERENCES cartera_cliente.cia (id_cia),
  CONSTRAINT fkreclamo_id_poliza FOREIGN KEY (id_poliza) REFERENCES cartera_cliente.polizas (id_poliza) ON DELETE CASCADE,
  CONSTRAINT fkreclamo_id_ramo FOREIGN KEY (id_ramo) REFERENCES cartera_cliente.ramo (id_ramo),
  CONSTRAINT fkreclamo_id_tipo_siniestro FOREIGN KEY (id_tipo_siniestro) REFERENCES cartera_cliente.tipo_siniestro (id_tipo_siniestro),
  CONSTRAINT fkreclamo_id_estado_siniestro FOREIGN KEY (id_estado_siniestro) REFERENCES cartera_cliente.estado_siniestro (id_estado_siniestro))
;

-- POLIZAS A CAPTAR  -- crecimiento de cartera
CREATE TABLE IF NOT EXISTS cartera_cliente.polizas_captar (
	id_polizas_captar INT auto_increment,
    id_productor int not null, 
    cliente_captar varchar(100) not null,
    descripcion varchar(250) not null,
    fecha_contactar date not null,
    prima float,
    telefono int,
    PRIMARY KEY (id_polizas_captar),
    CONSTRAINT fkpolizascaptar_productor FOREIGN KEY (id_productor) REFERENCES cartera_cliente.productor(id_productor) ON DELETE CASCADE)
    ; 



-- POLIZAS A CAPTAR  -- crecimiento de cartera
CREATE TABLE IF NOT EXISTS cartera_cliente.polizas_captar (
	id_polizas_captar INT auto_increment,
    id_productor int not null, 
    cliente_captar varchar(100) not null,
    descripcion varchar(250) not null,
    fecha_contactar date not null,
    prima float,
    telefono int,
    PRIMARY KEY (id_polizas_captar),
    CONSTRAINT fkpolizascaptar_productor FOREIGN KEY (id_productor) REFERENCES cartera_cliente.productor(id_productor) ON DELETE CASCADE)
    ; 

SAVEPOINT bd_end;

SAVEPOINT bd_end;

COMMIT;