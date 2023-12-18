START TRANSACTION ;

-- INSERT INCICIAL DE BD 
-- insert en tablas sin relaciones (FK)

INSERT INTO cartera_cliente.productor (productor, matricula, organizador)
    VALUES ('Roberto Masjoan','91994','Grupo PAS'),
        ('Juan Cruz Masjoan','96266','Elegi tu Seguro')
;

INSERT INTO cartera_cliente.cia (cia, ejecutivo, telefono, correo, codigo_cia)
    values ('SANCOR','PEIRETTI DIEGO', '3515586634','dppeiretti@sancorseguros.com','227933'),
       ('LA PERSEVERANCIA','JULIAN G CAVALLO', '3513623098','juliancavallo@lps.com.ar','8145'),
       ('ORBIS','GISELA A LONG', '3516116427','glong@orbiseguros.com.ar','6120901'),
       ('RIO URUGUAY','MICA - GRUPO PAS', '0001','sis@riouruguay.com.ar','14218676'),
       ('RIVADAVIA','ORGANIZACION', '000','ORGANIZACION GRUPO PAS','002'),
       ('BBVA SEGUROS','ERIK BLAES', '000','ERIK BLAES','001'),    
       ('INSUR - CAUCION','VIRGINIA BOSIO','3516016576','vbosio@segurosinsur.com.ar','1095')
;   
 
INSERT INTO cartera_cliente.estado_civil (estado_civil)
    values ('CASADO/A'),
        ('DIVORCIADO/A'),
        ('SOLTERO/A'),
        ('VIUDO/A')
;

SAVEPOINT ins_1trio;

INSERT INTO cartera_cliente.provincia (provincia) 
    VALUES  ('Buenos Aires'),
        ('Buenos Aires-GBA'),
        ('Capital Federal'),
        ('Catamarca'),
        ('Chaco'),
        ('Chubut'),
        ('Cordoba'),
        ('Corrientes'),
        ('Entre Rios'),
        ('Formosa')
;
INSERT INTO cartera_cliente.provincia (provincia) 
    VALUES  ('Jujuy'),
        ('La Pampa'),
        ('La Rioja'),
        ('Mendoza'),
        ('Misiones'),
        ('Neuquen'),
        ('Rio Negro'),
        ('Salta'),
        ('San Juan')
;
INSERT INTO cartera_cliente.provincia (provincia) 
    VALUES  
        ('San Luis'),
        ('Santa Cruz'),
        ('Santa Fe'),
        ('Santiago del Estero'),
        ('Tierra del Fuego'),
        ('Tucuman')
;

SAVEPOINT ins_2trio;

INSERT into cartera_cliente.ramo (ramo)
    values ('ACCIDENTES PERSONALES'),
        ('AP AUTOMOTOR'),
        ('AP MOTOVEHICULO'),
        ('AUTOMOVIL'),
        ('MOTOVEHICULO'),
        ('INTEGRAL DE COMERCIO'),
        ('COMBINADO FAMILIAR'),
        ('SEGURO TECNICO'),
        ('RESPONSABILIDAD CIVIL'),
        ('INCENDIO')
;
INSERT into cartera_cliente.ramo (ramo)
    values('CAUCION'),
        ('ASISTENCIA AL VIAJERO'),
        ('RAMOS ESPECIALES - UNIONES'),
        ('ART'),
        ('PREVENCION SALUD'),
        ('VIDA COLECTIVO'),
        ('AGROPECUARIO')
        ('CALULAR')
;

INSERT INTO cartera_cliente.cia_premio_prima( cia_premio_prima )
    values ('PREMIO'),
        ('PRIMA')
;

SAVEPOINT ins_3trio;

INSERT into cartera_cliente.ciclo_facturacion ( ciclo_facturacion)
    values ('MENSUAL'),
        ('BIMESTRAL'),
        ('TRIMESTRAL'),
        ('CUATRIMESTRAL'),
        ('SEMESTRAL'),
        ('ANUAL'),
        ('POR COSECHA'),
        ('PLAZOS ESPECIALES')
;

INSERT INTO cartera_cliente.cuotas_pago (id_cuotas,cantidad_cuotas)
    values (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10)
;
INSERT INTO cartera_cliente.cuotas_pago (id_cuotas,cantidad_cuotas)
    values (11,11),(12,12),(20,20),(50,'CONVENIOS')
;

SAVEPOINT ins_4trio;

INSERT INTO cartera_cliente.forma_pago_clientes (forma_pago_cliente)
    values (' EFECTIVO '),
        ('TARJETA DE CREDITO'),
        ('CBU'),
        ('CANJE'),
        ('DESCUENTO DE COMISIONES'),
        (' CHEQUE '),
        (' CONVENIOS ')
;

INSERT into cartera_cliente.estado_poliza (estado_poliza)
    values (' VIGENTE '),
        ('ANULADA POR CIA'),
        ('ANULADA'),
        ('RENOVADA'),
        ('NO RENOVADA POR SOCIO'),
        ('VENCIDA'),
        ('BAJA POR MORA'),
        ('VENTA / INEXISTENCIA DEL BIEN'),
        ('FUERA DE COBERTURA'),
        ('EN MORA')
;

INSERT INTO cartera_cliente.estado_certificados (estado_certificados)
    values (' ACTIVO '),
        ('BAJAS'),
        ('MODIFICACIONES'),
        ('RENOVACIONES')
;

SAVEPOINT ins_5trio;

INSERT into cartera_cliente.estado_siniestro (estado_siniestro)
    values ('PENDIENTE DE RESPUESTA'),
        ('TASADOR A CONTACTAR'),
        ('CON TASADOR'),
        ('ENVIO DE PROPUESTA'),
        ('PENDIENTE DE LIQUIDACION'),
        ('PENDIENTE DE DOCUMENTACION'),
        ('LIQUIDADA'),
        ('DESISTIDO POR LA CIA'),
        ('DESISTIDO POR EL CLIENTE'),
        ('RECHAZADO')
;
INSERT into cartera_cliente.estado_siniestro (estado_siniestro)
    values ('DE TERCEROS'),
        ('REALIZADO')
;

INSERT INTO cartera_cliente.tipo_siniestro( tipo_siniestro )
    values (' CHOQUE '),
        ('ROTURA PARCIAL'),
        ('ROBO'),
        ('ROBO PARCIAL'),
        ('HURTO'),
        ('INCENDIO'),
        ('DESTRUCCION TOTAL'),
        ('CRISTALES'),
        ('RECLAMO POR COBRO'),
        ('RECLAMO POR TRASLADO'),
        ('RECLAMO POR DESCUENTO')
;
INSERT INTO cartera_cliente.tipo_siniestro( tipo_siniestro )
    values         
        ('RECLAMO POR DOCUMENTACION'),
        ('ACCIDENTES PERSONALES'),
        ('LESIONES A PERSONAS'),
        ('GRANIZO'),
        ('ELECTRO HOGAR')
;

SAVEPOINT ins_6trio;

--- POR AHORA UTILIZAR LAS FK COMO TABLAS SEPARADAS EN TABLA POLIZA.
/*INSERT INTO cartera_cliente.pago_cliente (id_forma_pago_clientes , id_cuotas)
    values (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),
        (2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),
        (3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9),(3,10),(3,11),(3,12),
        (4,1),
        (5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(5,11),(5,12),
        (6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,9),(6,10),(6,11),(6,12)
;
*/

-- insert de formas de pago de la comision dependiendo cia NO ESTA EN CODER
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (1,2,1);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (2,2,0);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (3,1,0);

SAVEPOINT ins_7trio;

insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza) 
values (4,2,0);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (8,2,0);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza) 
 values (9,2,0);

SAVEPOINT ins_8trio;

-- insert comisiones
insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values ( 1 , 2, 1, 17) ,
 (1 , 2, 2 , 12.5),
 (1 , 2, 3 , 19),
 (1 , 2 , 4 , 13 ),
 (1 , 2, 5 , 13 )
;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
values  (1 , 2, 7 , 20),
 (1 , 2, 9 , 14),
 (1 , 2 , 10 , 22 ),
 (1 , 1, 13 , 25 ),
 (1 , 1, 15 , 16 ),
 (1 , 1, 17 , 8 )
;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
values  (2 , 2, 1 , 32),
	(2 , 2, 4 , 30),
    (2 , 2, 5 , 30),
    (2 , 2, 6 , 28),
    (2 , 2, 7 , 28),
    (2 , 2, 8 , 25 ),
    (2 , 2, 9 , 25),
    (2 , 2, 10 , 39)
;

SAVEPOINT ins_9trio;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values  (3 , 3 , 1 , 15),
	(3 , 4 , 1 , 20),
    (3 , 5 , 1 , 25)
;
insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values 
    (3 , 6 , 1 , 30),
    (3 , 7 , 4 , 20.5),
    (3 , 8 , 4 , 17.5),
    (3 , 9 , 4 , 14.5),
	(3 , 10 , 5 , 15),
    (3 , 11 , 5 , 20),
    (3 , 10 , 6 , 15),
    (3 , 11 , 6 , 20),
    (3 , 10 , 7 , 15),
    (3 , 11 , 7 , 20)
;

SAVEPOINT ins_10trio;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values  (4 , 2 , 2 , 7.5),
	(4 , 2 , 4 , 12),
    (4 , 2 , 5 , 12),
    (4 , 2 , 10 , 20),
    (4 , 2 , 6 , 13),
    (4 , 2 , 7 , 14.5)
;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values  (8 , 2 , 15 , 3.5),
  (9 , 2 , 14 , 3.5)
;

SAVEPOINT ins_11trio;

-- Insert planes para pago de comision
insert into cartera_cliente.plan_comision (nombre_plan_comision) 
 values ('UNICO'),
    ('PLAN 50'),
    ('PLAN 51'),
    ('PLAN 52'),
    ('PLAN 53'),
    ('PLAN 12'),
    ('PLAN 1'),
    ('PLAN 9')
;

insert into cartera_cliente.plan_comision (nombre_plan_comision) 
 values
    ('PLAN 15'),
    ('PLAN 20'),
    ('ACUERDOS ESPECIALES')
;

--- INSERTS CON FK EN TABLA
insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(13537544,'PARADELO RODOLFO',NULL,NULL,1,'Ramon de Chavez 655',NULL,5000,7,351156198827,'paradelor@gmail.com',NULL),
        (25165744,'VESPASIANI BERNARDO JOSE',NULL,'1976-03-31',1,'Matacos 7921','ANDRES PINERO 6151',5147,7,0351157044600,"bernardovespasiani@hotmail.com","SOCIO CEFE"),
        (30707823344,'MORAL MASJOAN SRL','MASJOAN JUAN PEDRO',NULL,NULL,NULL,'9 de julio 3',5152,7,3516761031,NULL,' SRL JUANCHO'),
        (30716775581,'TERRAZAS HESEM','ANDRE ESCUTI',NULL,NULL,NULL,'CELSO BARRIOS 1101',5000,7,3513869290,'aescuti@mcrespo.com.ar','ARGUMENTO RESTARUANT'),
        (31558825,'CEBALLOS GUSTAVO ROBERTO',NULL,'1985-05-08',3,'CARLOS PEREZ CORREA 1565',NULL,5008,7,3516185512,'gustavoceballos85@gmail.com',NULL),
        (31901772,'MEISELES ALEJANDRO',NULL,'1985-10-17',3,'COLON 1750',NULL,5000,7,3512118151,'alelqr@gmail.com','INCENDIO GABO'),        
        (33101294,'SCICHILI EMANUEL DAVID',NULL,'1987-06-01',1,'JOSE SUPERI 3021',NULL,5002,7,3513404326,'emanueldavidscichili@gmail.com','COMPANIERO TRABAJO MARCHI'),
        (33548070,'HANDELSMAN JIMENA',NULL,'1988-02-04',3,'LA MADRID 561',NULL,5900,7,3516133051,'jimena.hand@gmail.com',NULL),
        (34218782,'QUARANTA MASRUGA ROBERTINO',NULL,'1988-11-27',3,'LA MADRID 561',NULL,5900,7,3571638196,'robertinoquaranta@hotmail.com','NOVIO JIME HANDESL'),
        (35530053,'BARBOSA MARIA PAULA',NULL,NULL,NULL,'AV. COLON- TOORE 2 ALTOS DE COLON',NULL,5000,7,3513121349,NULL,"INCENDIO GABO")
;

SAVEPOINT ins_12trio;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(35578059,'PARADELO SANTIAGO',NULL,'1991-03-11',3,'PJE CHAGAS 6045',NULL,5147,7,3513105557,NULL,NULL),
        (35631223,'ABRAHAM TOMAS',NULL,'1991-01-22',3,'IGUALDAD 5643',NULL,5000,7,3512228676,'tomiabraham91@gmail.com',NULL),
        (35888865,'MARCHAND BELACHI GASTON MAXIMILIANO',NULL,'1991-12-24',3,'MARCOS SASTREE 1330',NULL,5009,7,35888865,'gastonm10@hotmail.com',NULL),
        (36140784,'HANSEN MATIAS',NULL,'1991-11-12',1,'EDMUNDO MARIOTTE 5509','RECTA MARTINOLI 6789 LOCAL 3',5147,7,3516183755,'Tutehansen@gmail.com',NULL),
        (36145022,'NINCI JUAN CRUZ',NULL,'1991-12-11',3,'PADRE LUCHESSE 3500 L4 MZA 26',NULL,5105,7,351153985450,NULL,NULL),
        (36706032,'STUTZ KEVIN ALEJANDRO',NULL,'1991-08-24',3,'ESPINOSA NEGRETE 686','calle s/n Capilla',5231,7,3513186213,'kevin.a.stutz@gmail.com',NULL),
        (37852181,'FONTAN JULIAN',NULL,'1993-09-21',3,'Poincare 8450',NULL,5147,7,3512325321,'fontan_julian@hotmail.com',NULL),
        (38332285,'GIL GASTON',NULL,'1994-07-09',3,'ROLAND ROSS 7620','LUIS DE TEJEDA 4342',5009,7,3512510914,'Tomashansen94@gmail.com',NULL),
        (39421779,'Maldonado Malanczuk Karen Soledad','AGUSTIN SUELDO','1995-12-11',3,'pedro chutro 123',NULL,5000,7,3517693238,'agustin_325@hotmail.com','AP PARA AGUSTIN SUELDO'),
        (40106260,'LESCANO EMILIANO NICOLAS',NULL,'1999-01-10',3,'Gral Alvear 71',NULL, 5000,7,3515559900,'christianlescano73@gmail.com','HIJO CRISTIAN LESCANO')
;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values (41522239,'DELFINA MASJOAN',NULL,'1998-09-17',3,'ESTANCIA LAS VIZNAGA 1440',NULL,5149,7,3516502903,'robertomasjoan@gmail.com',NULL),
        (42211228,'FARFAN JIMENA AGUSTINA',NULL,NULL,NULL,'Av_colon_1750',NULL,5000,7,3874592563,'agustinavega.j019@gmail.com',"INCENDIO GABO"),
        (95901236,'RANGEL PERNIA ROYFRED ENRRIQUE',NULL,'1993-10-07',3,'Av_colon_1750',NULL,5000,7,3513151392,'rpre_10@hotmail.com',"INCENDIO GABO"),
        (18498204, 'PERAZOLO DANIEL EMILIO',NULL,NULL,1,'ANDRES PIÑERO 7778', NULL,5000,7,'3516502903 ',NULL,NULL),
        (30715973886,'AC COMUNICACIONES SAS','ACOSTA LEONARDO',NULL,NULL,null,'REP DE CHINA  L 2000',5000,7,35115111111,'leoakosta@gmail.com',NULL),
        (43880988,'RIOS CELESTE CAROLINA',NULL,NULL,3,'PEDRO RUBENS 4122',NULL,5016,7,351153234459,'cele-rios-07@hotmail.com',NULL),
        (34318168,'MANSILLA ARIEL FERNANDO', NULL,'1998-05-12',3,'ARZ CASTELLANOS 934',NULL,5186,7,NULL,NULL,'AP PARA AGUSTIN SUELDO'),
        (20600597,'BARRERA ROSANA FABIANA',NULL,'1968-11-11',1,'Lote 4 mza 115 valle escondido',NULL,5010,7,3513420069,NULL,NULL),
        (34601780,'BOSSIO DANIELA LISETTE', NULL,'1989-08-02',1,'AV. JOSE MARIA EGUIA ZANON 10330',NULL,5149,7,3515556297, 'danielabossio89@gmail.com',NULL),
        (32876502,'MASJOAN MICAEL',NULL,'1987-02-24',1,'AV. JOSE MARIA EGUIA ZANON 10330',NULL,5149,7,3512280491,'micael_m28@hotmail.com',NULL)
;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(24769535,'CASAVECHIA JUAN IGNACIO',NULL,'1975-07-13',1,'C GAITO 1609',NULL,5000,7,4882808,'jcasavecchia@gmail.com', NULL),
        (37616568,'MASJOAN SANTIAGO',NULL,'1993-04-30',3,'lote 22 mz 46 lomas de la Carolina',NULL,5149,7,NULL,NULL,NULL),
        (30707943420,'F.A.M.E.', NULL, NULL,NULL,NULL,'DR M BOEDO 2725',5006,7,3517573899,'contaduria@famesa.com.ar',NULL),
        (16083089,'BARDARO ADRIANA GLADYS',NULL,'1962-03-15',1,'VENTA Y MEDIA 4842 D3',NULL,5000,7,3516337799,'gustavodepozo@hotmail.com',NULL),
        (16677229,'BALLARATI JOSE LUIS',NULL,'1963-12-24',1,'MOLINO DE LA TORRE L11 MZ13 5301',NULL,5149,7,3512222221,'jballarati@deloitte.com',NULL),
        (36235750,'MASJOAN JUAN CRUZ',NULL,'1991-04-21',3,'JORGE DESCOTTE 7366',NULL,5147,7,3516602437,'jcmasjoan91@gmail.com',NULL),
        (13964596,'GALIZZI MARIA SILVINA', NULL,'1960-05-26',1,'JOSE D GIGENA 2049',NULL,5009,7,NULL,NULL,NULL),
        (30660590,'PARADELO GONZALO MARTIN',NULL,'1984-02-06',2,'LOS JACINTOS 1820',NULL,5151,7,NULL,'gonzalomparadelo@hotmail.com',NULL),
        (35189624,'BALLARATI LUCIA',NULL,'1990-04-07',3,'El Bosque Molino de torre 3501 Lote11 Mza 13',NULL,5149,7,3515281218,NULL,NULL),
        (37339743,'BALLARATI CARLA',NULL, '1993-02-26',3,'molino de torres 5301',NULL,5149,7,NULL,'cballarati@ta.telecom.com.ar',NULL)
;        

SAVEPOINT ins_13trio;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(37126084,'CASOR FRANCO JULIAN',NULL,'1993-10-04',3,'av. malvinas argentinas 311',NULL,5107,7,3543589220,'julian.casor@gmail.com',NULL),
        (16230538,'DIBO ENRIQUE DANIEL',NULL,'1963-04-06',2,'lote 12 mz 69 lomas de la carolina',NULL,5149,7,3514280896,'diboestudio@hotmail.com',NULL),
        (13962080,'VIDAL DANIEL EDUARDO',NULL,'1959-12-29',1,'JOSE GIGENA 2049',NULL,5009,7,3513105031,NULL,NULL),
        (2353028,'CARDEZA ELSA LIDYA',NULL,'1933-10-04',4,'JOSE D GIGENA 2041',NULL,5009,7,3516527626,'gabogalizzi@gmail.com',NULL),
        (35964684,'TARQUINI GASTON TOMAS',NULL,'1991-06-06',3,'Tycho Braine 5935',NULL,5147,7,3512313060,'gaston.t.tarquini@gmail.com',NULL),
        (39301762,'TOBAREZ GABRIEL IVAN',NULL,'1995-10-09',3,'Av Colón 1750 Ed Aviva Colón Depto 6D',NULL,5000,7,NULL,NULL,"INCENDIO GABO"),
        (40402516,'CERIONI ARACELI MAGALI',NULL,'1997-02-22',3,'Av Colón 1750 Ed Aviva Colón Depto 4B',NULL,5000,7,3516453145,'magacerioni97@hotmail.com',"INCENDIO GABO"),
        (41382898,'NUNEZ JOAQUIN MARTIN',NULL,'1999-04-01',3,'Av Colón 1750 Ed Aviva Colón Depto 6C',NULL,5000,7,3515212121,NULL,"INCENDIO GABO"),
        (96044764,'ERAZO BRACHO QUENA DEL ROSARIO',NULL,'1984-09-25',1,'Av Colón 1750 Ed Aviva Colón 6D',NULL,5000,7,3513624971,'quena.erazo@gmail.com',"INCENDIO GABO"),
        (5127636,'VICTORIA CRISTINA ESTELA',NULL,'1946-03-09',4,'Av Colón 1750 Ed Aviva Colón 1C',NULL,5000,7,351324620,NULL,"INCENDIO GABO")
;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(27077427,'LUNA MARIO ALBERTO',NULL,'1979-01-01',1,'Av Colón 1750 Ed Aviva Colón 1B',NULL,5000,7,NULL,'roxana636_7@hotmail.com',"INCENDIO GABO"),
        (27249992,'CASTRO CLAUDIA GABRIELA',NULL,'1976-06-08',3,'Av Colón 1750 Ed Aviva Colón 4M',NULL,5000,7,NULL,NULL,"INCENDIO GABO"),
        (36725134,'ARAOZ TANIA CRISTINA',NULL,'1991-11-03',3,'Av Colón 1750 Ed Aviva Colón 7M',NULL,5000,7,3515284666,'tacrisar2306@gmail.com',"INCENDIO GABO"),
        (23686229,'GUEVARA YANINA', NULL,'1973-10-18',3,'Blas Pascal nº 5316',NULL,5147,7,NULL,NULL,"INCENDIO GABO"),
        (22560405,'PACHA ZORDAN FLAVIA ALEJANDRA',NULL,'1971-12-15',2,'MZA 43 LOTE 1',NULL,5009,7,3515502297,NULL,NULL),
        (23940638,'MASJOAN JUAN PEDRO',NULL,'1974-07-12',1,'Pampa de los guanacos 10478',NULL,5149,7,343401287,'jpmasjoan@gmail.com',NULL),
        (37822016,'SLOOTMANS CAMILA',NULL,'1993-08-20',3,'CHASCOMUS 2153',NULL,5000,7,NULL,'slootmanscamila@gmail.com',NULL),
        (24382694,'CHARRON DIEGO DAVID','AGUSTIN SUELDO','1975-01-24',1,'lujan S/N',NULL,5507,14,2615727778,NULL,'AP PARA AGUSTIN SUELDO'),
        (30710091141,'UNION ANDINA DE RUGBY',NULL,NULL,NULL,NULL,'PENINSULA TRINIDAD 3293',5300,13,3804442733,'tesoreriaua2019@gmail.com',null),
        (30672696573,'UNION DE RUGBY DEL ALTO VALLE DE RIO NEGRO Y NEUQUEN',NULL,NULL,NULL,NULL,'TUCUMAN 799',8300,16,2996345582,'rreatti@gmail.com',NULL)
;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(30529742580,'PARANA ROWING CLUB',NULL,NULL,NULL,NULL,'AVENIDA COSTANERA',3100,9,3434218018,'paranarowingclub@arnet.com.ar',NULL),
        (30564215143,'UNION CORDOBESA DE RUGBY',NULL,NULL,NULL,NULL,'BV CASTRO BARROS 155',5000,7,NULL,NULL,NULL),
        (30716338793,'PITAYA CBA S.A.S.', NULL,NULL,NULL,NULL,'Av. Ejército Argentino 9520 Lomas de la Carolina',5149,7,03543449550,NULL,NULL),
        (21585653,'LEIVA ALEJANDRO OSCAR',NULL,'1971-03-02',1,'repubica china 1045',NULL,5149,7,3513922159,NULL,NULL),
        (14387806,'ROMANO DE DIBO MARIA VICTORIA',NULL,'1962-04-13',2,'Mza 14 Lote 18, Barrio Chacras de la Villa',NULL,5105,7,3515109579,'vioia_07@hotmail.com',NULL),
        (30716603764,'AGRO GIG S.A.S.','STUTZ KEVIN-PASTOR BERGESSE',NULL,NULL,NULL,'JOSE B ITURRASPE 1909',2400,7,NULL,'pastorbergese@gmail.com',NULL),
        (30712053034,'CINCO TIERRAS SRL',NULL,NULL,NULL,NULL,'Carlos Gauss 5760 Dpt6',5147,7,NULL,NULL,NULL),
        (30715587358,'INCOR CONSTRUCCIONES SRL',NULL,NULL,NULL,NULL,'Av. Colon 636 dpto 2A',5000,7,NULL,NULL,NULL),
        (36429074,'MARGRINA VALENTINI LEANDRO UMBERTO',NULL,'1992-08-18',3,'MTRO MONTAIGNE 1247',NULL,5000,7,3513667219,NULL,NULL)
;

SAVEPOINT ins_14trio;

insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ)
    values(20528311,'TILLARD MARIA SOLEDAD',NULL,'1968-09-19',2,'LOS ALAMOS 2087',NULL,5151,7,1153870107,NULL,NULL),
        (27672506,'BARDACH PATRICIA ALEJANDRA',NULL,'1979-12-16',1,'LOS TALAS 9',NULL,5107,7,3517886101,'juan_eb1988@hotmail.com',NULL),
        (26082987,'MALDONADO MIGUEL ANGEL',NULL,'1977-08-09',1,'José Ramonda 6505',NULL,5147,7,3516427647,NULL,NULL),
        (23354712,'TILLARD CADAVID PAZ MARIA',NULL,'1973-05-11',2,'MARTEL DE LOS RIOS 1981',NULL,5009,7,3512226658,'paztillard@hotmail.com',NULL),
        (32926240,'ZARATE BON MURIEL',NULL,'1987-04-12',3,'Blas Pascal 5324',null,5147,7,351400606,'murielzarate@hotmail.com',null),
        (35914558,'HEREDIA ALVARO ANDRES',NULL,'1991-01-18',3,'DR PELAGIO B LUNA 3496',NULL,5009,7,3513076134,'aheredialvaro@gmail.com',NULL),
        (28535797,'ACOSTA LEONARDO ARIEL',NULL,'1974-04-15',1,'SANTIAGO DEL ESTERO 946',NULL,5220,7,3514685561,'rmasjoan@celular-srl.com.ar',NULL),
        (35108032,'BEVERINA FELIPE','TEKTON','1990-04-29',3,'LIEBIG 5862','Pasaje velez sarflied GALPON 2',5000,7,3512648855,'f.beverina@gmail.com',null),
        (17541587, 'PEIRETTI SUSANA MARIA', 'TINA PEIRETTI', '1966-05-29', 2, 'Corrientes  47 3B',NULL, '5000', 7, 3513397501, 'agustinapeiretti@gmail.com',NULL),    
        (10904226,'LOPEZ RITA BEATRIZ',null, '1953-10-20',1,'Pascual de rogatis 2727',null, 5000,7,3513063199,'americoferreyra76@gmail.com','mama americo')
;       
            
INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (10677730,1,20600597,1,4,NULL,'2022-01-18','2023-01-18',3,12,6,7594,1),
        (9630507,1,20600597,1,2,'10677730','2022-01-18','2023-01-18',3,12,6,90,1),
        (9964086,1,34601780,1,4,NULL,'2021-04-05','2022-04-05',3,12,6,2384,1),
        (9964084,1,34601780,1,2,'9964086','2021-04-05','2022-04-05',3,12,6,90,1),
        (10425970,1,32876502,1,4,NULL,'2021-10-30','2022-10-30',3,12,6,4592,1),
        (9332235,1,32876502,1,2,'10425970','2021-10-30','2022-10-30',3,12,6,90,1),
        (10503611,1,24769535,1,4,'HHF386 HONDA CIVIC','2021-11-01','2022-11-01',3,12,6,5642,1),
        (9431958,1,24769535,1,2,'10503611','2021-11-01','2022-11-01',3,12,6,90,1),
        (688742,1,24769535,1,16,'10503611','2021-11-01','2022-11-01',3,12,6,35,1),
        (10659613,2,37616568,1,4,NULL,'2022-01-16','2023-01-16',2,12,6,3259,1)
;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (9612514,2,37616568,1,2,'10659613','2022-01-16','2023-01-16',2,12,6,3259,1),
        (10735631,1,30707943420,1,4,'flota','2022-02-12','2023-02-12',3,12,6,78785,1),
        (7489276,1,30707943420,1,2,'10735631','2022-02-12','2023-02-12',3,12,6,90,1),
        (374411,1,28535797,1,5,'KYMCO','2021-04-21','2022-04-21',2,12,6,1148,8),
        (392667,1,30716603764,1,17,NULL,'2021-12-18','2022-05-31',4,1,7,61.70,1),
        (1105118,2,36725134,1,10,'incendio gabo','2021-11-22','2022-11-12',3,1,6,1840,1),
        (10669978,1,37339743,1,4,'AE484AD VOLKSWAGEN T-CROSS ','2022-01-15','2023-01-15',2,12,6,7206,1),
        (9622799,1,37339743,1,2,'10669978','2022-01-15','2023-01-15',2,12,6,90,1),
        (10672356,2,37126084,1,4,'NYB274 TOYOTA ETIOS','2022-01-21','2023-01-21',2,12,6,6971,1),
        (9841586,2,37126084,1,4,'NYB274 TOYOTA ETIOS','2021-01-21','2022-01-21',2,12,6,90,4)
;

SAVEPOINT ins_15trio;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (9625194,2,37126084,1,2,'10672356','2022-01-21','2023-01-21',2,12,6,6971,1),
        (8678956,2,37126084,1,2,'9841586','2021-01-21','2022-01-21',2,12,6,90,4),
        (9895722,1,16677229,1,4,'AC721PH BMW X 1','2021-03-19','2022-03-19',2,12,6,12880,1),
        (8730627,1,16677229,1,2,'9895722','2021-03-19','2022-03-19',2,12,6,70,1),
        (9895811,1,16677229,1,4,'AD679RR FIAT 500X','2021-03-19','2022-03-19',2,12,6,12367,1),
        (8730716,1,16677229,1,2,'9895811','2021-03-19','2022-03-19',2,12,6,90,1),
        (9895633,1,16677229,1,4,'KCU020 FIAT PUNTO','2021-03-19','2022-03-19',2,12,6,6450,1),
        (8730538,1,16677229,1,2,'9895633','2021-03-19','2022-03-19',2,12,6,90,1),
        (2475992,1,16677229,1,7,'CASA LOMAS','2021-03-19','2022-03-19',2,12,6,2360,1),
        (10589772,1,35189624,1,4,'AE544BE VOLKSWAGEN T-CROSS','2021-12-29','2022-12-29',2,12,6,5696,1)
;        

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values(9522735,1,35189624,1,2,'10589772','2021-12-29','2022-12-29',2,12,6,90,1),
        (2606527,2,27672506,1,7,'LOS TALAS Nº 9','2021-07-17','2022-07-17',2,12,6,2687,1),
        (9819047,1,16083089,1,4,'KYN462 CHEVROLET AGILE ','2021-02-18','2022-02-18',2,12,6,4289,1),
        (8643442,1,16083089,1,2,'9819047','2021-02-18','2022-02-18',2,12,6,90,1),
        (10373258,1,2353028,1,4,'IFE660 RENAULT SYMBOL','2021-08-19','2022-09-19',3,12,6,3442,1),
        (9272257,1,2353028,1,2,'10373258','2021-08-19','2022-09-19',3,12,6,90,1),
        (1105000,1,27249992,1,10,'incendio gabo','2021-11-19','2022-11-19',1,1,6,1076,1),
        (1085399,2,40402516,1,10,'incendio gabo','2021-03-12','2022-03-12',1,1,6,1076,1),
        (9475977,2,24382694,1,1,'AP ocasion del trabajo','2021-10-30','2022-10-30',3,12,6,385,1),
        (330954,1,30712053034,1,9,'garage San Martin 42','2021-05-10','2022-05-10',3,10,6,5227,1)
;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values(9920546,1,16230538,1,4,'AE041BP NISSAN FRONTIER ','2021-03-01','2022-03-01',3,12,6,10278,1),
        (8772244,1,16230538,1,2,'9920546 ','2021-03-01','2022-03-01',3,12,6,90,1),
        (1086128,2,96044764,1,10,'incendio gabo','2021-03-16','2022-03-16',1,1,6,1073,1),
        (10196867,1,13964596,1,4,'MAP536 RENAULT SYMBOL','2021-07-24','2022-07-24',2,12,6,4483,1),
        (9060608,1,13964596,1,2,'10196867','2021-07-24','2022-07-24',2,12,6,70,1),
        (9268158,2,38332285,1,1,'FORMAGGIO','2021-09-01','2022-09-01',1,12,1,3236,1),
        (1107433,2,23686229,1,10,'incendio gabo','2021-12-21','2022-12-21',1,1,6,2212,10),
        (2668586,2,35914558,1,7,NULL,'2021-08-18','2022-08-18',3,12,6,2409,1),
        (191557,1,30715587358,1,11,'Ejecución de Contrato Av. Colon 636 2A','2019-06-24','2024-06-24',1,20,3,2579,1),
        (8769241,1,21585653,1,1,'Integro Max','2021-03-01','2022-03-01',3,12,1,1718,1)
;

SAVEPOINT ins_16trio;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values(326995,1,21585653,1,9,null,'2021-03-01','2022-03-01',3,12,6,507,1),
        (1101614,2,27077427,1,10,'incendio gabo','2021-10-06','2022-10-06',1,1,6,1076,1),
        (9733574,2,39421779,1,1,'Accidentes Personales(24 hs)','2021-01-18','2021-02-18',1,1,8,973,1),
        (192246,1,36429074,1,11,'Ejecución de Contrato ','2019-07-05','2024-07-05',1,20,3,600,1),
        (192555,1,36429074,1,11,'Garantía de Anticipos y/o Acopios HIPOLITO MONTAGNE 1247 ','2019-07-16','2024-07-16',1,20,3,1363,1),
        (196430,1,36429074,1,11,'Sustitución Fondo de Reparos','2019-09-27','2024-09-27',1,20,3,600,1),
        (2606528,2,26082987,1,7,'José ramonda 6505','2021-07-17','2022-07-17',3,12,6,2773,1),
        (7598403,2,36235750,1,4,'HZY017 FIAT PALIO','2021-05-05','2022-05-05',3,12,6,4307,1),
        (8898344,2,36235750,1,2,'HZY017 FIAT PALIO','2021-05-05','2022-05-05',3,12,6,4307,1),
        (2694971,1,23940638,1,7,'Pampa de los guanacos 10478','2021-09-10','2022-09-10',2,12,6,2314,1)
;        
        
INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values(375048,1,23940638,1,5,'A075BYI VESPA ','2021-04-30','2022-04-30',3,12,6,1344,1),
        (8934829,1,23940638,1,3,'375048 ','2021-04-30','2022-04-30',3,12,6,91,1),   
        (1098736,2,31901772,1,10,'incendio gabo','2021-08-19','2022-08-19',1,1,6,1076,1),
        (10091796,1,3070782334,1,4,'FLOTA','2021-04-30','2022-04-30',3,12,6,67734,1),
        (9080773,1,3070782334,1,1,'Integro Max','2021-06-14','2022-06-14',3,12,6,2252,1),
        (330935,1,3070782334,1,8,'AV 9 DE JULIO 5','2021-05-10','2022-05-10',3,10,6,1938,1),
        (10586450,2,36145022,1,4,'AD458DQ VOLKSWAGEN POLO','2021-12-17','2022-12-17',3,12,6,5336,1),
        (9519414,2,36145022,1,2,'10586450','2021-12-17','2022-12-17',3,12,6,90,1),
        (1085397,2,41382898,1,10,'incendio gabo','2021-03-12','2022-03-12',1,1,6,1076,1),
        (445357,1,22560405,1,5,'692LLQ KAWASAKI KLE','2022-02-09','2023-02-09',3,12,6,2379,1)
;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (9677448,1,22560405,1,3,'445357','2022-02-09','2023-02-09',3,12,6,90,1),
        (10582223,1,30660590,1,4,'KYD345 RENAULT KANGOO','2021-12-05','2022-12-15',2,12,6,5150,1),
        (9515203,1,30660590,1,2,'10582223','2021-12-05','2022-12-15',2,12,6,90,1),
        (2745305,1,30660590,1,7,'Diego Díaz 450 ','2021-11-16','2022-11-16',2,12,6,1949,1),
        (9018846,1,30529742580,1,13,'Unión Cordobesa de Rugby y Otros','2021-06-05','2022-06-05',7,50,8,122569.70,1),
        (9014205,1,30564215143,1,13,'Unión Cordobesa de Rugby y Otros','2021-03-01','2022-03-01',3,12,8,2168871.58,1),
        (8867131,1,30710091141,1,13,'Unión Cordobesa de Rugby y Otros','2021-03-01','2022-03-01',3,12,8,317353.37,1),
        (8961717,1,30672696573,1,13,'Unión Cordobesa de Rugby y Otros','2021-03-01','2022-03-01',3,12,8,337698.35,1),
        (9127551,1,30716338793,1,1,'PITAYA CBA S.A.S.','2021-07-28','2022-07-28',2,12,1,8034,1),
        (757000,1,30716338793,1,6,'Lomas de la Carolina','2021-07-28','2022-07-28',2,10,1,5055,1)
;

SAVEPOINT ins_17trio;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (1101820,2,95901236,1,10,'incendio gabo','2021-10-14','2022-10-14',1,1,6,1076,1),
        (9105693,1,14387806,1,1,'Integro Max','2021-06-30','2022-06-30',2,12,6,1059,1),
        (8792532,2,37822016,1,1,'AP ocasion del trabajo','2021-04-29','2022-04-29',1,12,6,658,1),
        (10283134,2,36706032,1,4,'AC350OG VOLKSWAGEN SAVEIRO','2021-08-24','2022-08-24',3,12,6,5164,1),
        (96545565,2,36706032,1,2,'10283134','2021-08-24','2022-08-24',3,12,6,5164,1),
        (10688767,2,36706032,1,4,'AE008YW CHEVROLET S10','2021-12-21','2022-12-21',3,12,6,7553,1),
        (9168004,2,36706032,1,2,'10688767','2021-12-21','2022-12-21',3,12,6,90,1),
        (10697841,2,35964684,1,4,'EIH247 FORD FIESTA','2021-12-29','2022-12-29',3,12,6,2400,1),
        (9667072,2,35964684,1,2,'10697841','2021-12-29','2022-12-29',3,12,6,90,1),
        (2756887,1,23354712,1,7,'MARTEL DE LOS RIOS 1981','2022-01-13','2023-01-13',2,12,6,4066,1)
;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (2583692,1,20528311,1,7,'el calicanto casa 7','2021-07-16','2022-07-16',3,10,6,1333,1),
        (1085398,2,39301762,1,10,'incendio gabo','2021-03-12','2022-03-12',1,1,6,1076,1),
        (2784058,1,32926240,1,7,'Blas Pascal 5324','2021-02-24','2022-02-24',1,1,6,3645,1),
        (10143503,1,13962080,1,4,'KZG498 RENAULT FLUENCE','2021-05-27','2022-05-27',2,12,6,4632,1),
        (9014176,1,13962080,1,2,'10143503','2021-05-27','2022-05-27',2,12,6,90,1),
        (1098762,1,5127636,1,10,'incendio gabo','2021-08-20','2022-08-20',1,1,6,1076,1),
        (113447,2,35530053,4,10,'incendio gabo','2021-10-23','2022-10-23',3,12,6,151,1),
        (126373,2,33101294,4,7,null,'2021-10-18','2022-10-18',3,12,6,1233,1),
        (126228,2,33548070,4,7,null,'2021-10-15','2022-10-15',2,12,6,2169,1),
        (126236,2,35888865,4,7,null,'2021-10-15','2022-10-15',3,12,6,2311,1)
;        
        
INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values(55827,2,40106260,4,6,null,'2021-10-01','2022-10-01',3,12,6,1033,1),
        (53752,2,38332285,4,6,'formaggio','2021-07-13','2022-07-13',1,10,6,2588,10),
        (52754,2,361407841,4,6,'censurado recta','2021-05-21','2022-05-21',3,12,6,1971,1),
        (52208,2,30716775581,4,6,'argumento jockey','2021-04-21','2022-04-21',3,10,6,4760,1),
        (1452282,2,35631223,4,5,'051KEP KYMCO LIKE','2022-01-07','2022-04-07',3,3,3,1618,1),
        (10061434,2,31558825,4,4,'AB772EM PEUGEOT 308','2022-01-05','2022-04-05',1,3,3,7870,1),
        (367564,2,31558825,4,2,'10061434','2022-01-05','2022-04-05',1,3,3,35,1),
        (109825,2,42211228,4,10,'incendio gabo','2021-02-02','2022-02-02',1,12,6,110,1),
        (7288515,1,13537544,2,4,'LZO176 peugeot 408','2021-12-19','2022-12-19',1,12,3,7891,10),
        (7288285,1,30715973886,2,4,'AC441LT TOYOTA-ETIOS','2021-12-30','2022-12-30',1,12,3,7114,1)
;

SAVEPOINT  ins_18trio;
rollback to ins_18trio;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values (7286419,2,43880988,2,4,'DWG976 VOLKSWAGEN-GOL','2021-12-24','2022-12-24',1,12,3,2864,10),
        (7265425,1,18498204,2,4,'IXY833 CHEVROLET-MERIVA','2021-11-16','2022-11-16',2,6,5,3703,1),
        (7264923,1,41522239,2,4,'HWY105 SUZUKI-SWIFT','2021-11-26','2022-11-26',2,6,5,1731,1),
        (7189027,2,36145022,2,4,'AE536LQ VOLKSWAGEN-NIVUS','2021-08-06','2022-08-06',3,6,5,4054,1),
        (164674,2,25165744,2,7,'MATACOS 7921','2021-12-21','2022-12-21',1,12,6,3065,1),
        (36934,2,25165744,2,6,'oficina - ANDRES PIÑERO 6151','2021-12-03','2022-12-03',1,1,6,16412,10),
        (20731,2,34218782,2,8,'COMPUTADORA OFICINA MOL','2021-10-20','2022-10-20',2,12,6,1413,1),
        (977063,1,30707823344,3,5,'030iaj motomel ','2022-01-10','2022-05-10',3,4,4,238,1),
        (28889,2,34318168,3,1,'ap ojudo','2022-01-12','2022-01-28',1,1,8,332,10),
        (265333,2,36140784,3,1,'ap censurado','2022-01-11','2022-06-02',3,12,1,1741,1)
;

INSERT INTO cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,
fecha_alta,fecha_baja,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza)
    values(283663,2,37852181,3,1,'lomas de la carolina','2021-12-14','2022-02-12',1,1,8,3681,1),
        (288098,2,39421779,3,1,'ap ojudo - quilmes', '2022-01-26','2022-02-26',1,1,8,342,1),
        (9745625,2,35108032,1,1,'TEKTON EMPLEADOS','2022-01-26','2023-01-26',3,12,1,3579,1),
        (277714,2,95901236,3,1,'AP peluqueria','2021-12-14','2022-10-14',1,10,1,1150,10)
;


insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
    values (30707943420,10735631,1,'LCK 195 BMW X5 35I',null,null,null,1),
        (30707943420,10735631,2,'KQY004 TOYOTA HILUX DC 4X4',null,null,null,1),
        (30707943420,10735631,3,'LDT797 TOYOTA LAND CRUISER PRADO',null,null,null,1),
        (30707943420,10735631,4,'MGQ709 HONDA FIT EX',null,null,null,1),
        (30707943420,10735631,5,'GOV861 CITROEN BERLINGO ',null,null,null,1),
        (30707943420,10735631,6,'LCQ165 FORD ECO SPORT ',null,null,null,1),
        (30707943420,10735631,7,'AA666CS BMW 120I ACTIVE',null,null,null,1),
        (30707943420,10735631,8,'A/D FOTON AUMARK 3.8 S3 916',null,null,null,1),
        (38332285,9268158,1,'FORMAGGIO','39496379','MOYANO MATIAS',NULL,2),
        (38332285,9268158,2,'FORMAGGIO','31669570','RUBIOLO MARCO',NULL,2)
;

savepoint ins_19trio;

insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
    values (38332285,9268158,3,'FORMAGGIO','36784114','COLETTI PABLO NICOLAS',NULL,2),
        (38332285,9268158,4,'FORMAGGIO','40835838','ALLASIA AVALLE ULISES EMILIANO',NULL,2),
        (38332285,9268158,6,'FORMAGGIO','36146200', 'Martin machado','1991-12-20',1),
        (38332285,9268158,7,'FORMAGGIO','34959739','Melisa soledad Garlati','1990-02-21',1),
        (8769241,21585653,1,NULL,'23108139','	AGUIRRE JAVIER ARIE',null,1),
        (8769241,21585653,2,NULL,'27399036','VIDELA DAMIAN DANIEl',null,1),
        (8769241,21585653,3,NULL,'38218727','	GUZMAN ACOSTA JULIO WALTER',null,1),
        (3070782334,10091796,1,'LIL561 TOYOTA HILUX',null,null,null,2),
        (8769241,21585653,4,NULL,'40963728','	ZERBATTO FAUTARIO CRISTIAN DANIEL',null,1),
        (3070782334,10091796,2,'AD635XB HONDA HR-V',null,null,null,1)
;

insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
    values (3070782334,10091796,3,'AA384KL TOYOTA COROLLA ',null,null,null,1),
        (3070782334,10091796,4,'PHO032 VOLSKWAGEN GOLF ',null,null,null,1),
        (3070782334,10091796,5,'MRH692 FORD FIESTA',null,null,null,1),
        (3070782334,10091796,6,'MLS363 TOYOTA HILUX',null,null,null,1),
        (3070782334,10091796,7,'WUJ274 JEEP IKA',null,null,null,1),
        (3070782334,10091796,8,'JFP702 PEUGEOT 207',null,null,null,2),
        (3070782334,10091796,9,'MVV818 FIAT DOBLO',null,null,null,1),
        (3070782334,10091796,10,'AC572JH HONDA HR-V',null,null,null,1),
        (3070782334,10091796,11,'OUA988 CHERY TIGGO',null,null,null,1),
        (3070782334,10091796,12,'AE859OB VOLSKWAGEN AMAROK',null,null,null,1)
;

insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
    values (3070782334,9080773,1,null,'29473520','REYES CRISTIAN ALBERTO',null,1),
        (3070782334,9080773,1,null,'11432240','QUINTERO NOLBERTO BELTRAN',null,1),
        (30716338793,9127551,2,NULL,'36375567','GASPAR JUAN EMILIO',NULL,1),
        (30716338793,9127551,1,NULL,'39935453','GONZALEZ FLORENCIA ANYELEN',NULL,1),
        (30716338793,9127551,4,NULL,'32372305','GREGORI JUAN PABLO',NULL,1),
        (30716338793,9127551,9,NULL,'33201017','OVIEDO ANABELLA STEFANIA',NULL,1),
        (30716338793,9127551,10,NULL,'30660590','PARADELO GONZALO MARTIN',NULL,1),
        (30716338793,9127551,8,NULL,'41524829','PAVON FACUNDO JOAQUIN',NULL,1),
        (30716338793,9127551,3,NULL,'38645444','PERALTA LUCAS ANDRES',NULL,1),
        (30716338793,9127551,5,NULL,'36776029','RAMOS DEBORA GISELA',NULL,1)
;

SAVEPOINT ins_20trio;

insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
    values (30716338793,9127551,6,NULL,'34130103','SANCHEZ CRISTIAN EZEQUIEL',NULL,1),
        (30716338793,9127551,7,NULL,'32875301','WAISS ROGER',NULL,1),
        (30716338793,9127551,2,NULL,'36375567','GASPAR JUAN EMILIO',NULL,2),
        (30716338793,9127551,3,NULL,'38645444','PERALTA LUCAS ANDRES',NULL,2),
        (30716338793,9127551,4,NULL,'32372305','GREGORI JUAN PABLO',NULL,2),
        (30716338793,9127551,11,NULL,'39693132','NIETO MATIAS AGUSTIN',NULL,1),
        (30716338793,9127551,12,NULL,'35581769','GOMEZ MAXIMILIANO ANDRES',NULL,1),
        (30716338793,9127551,13,NULL,'38417955','OLMOS GABRIEL FEDERICO',NULL,1),
        (30716338793,9127551,14,NULL,'37874970','DE TOBILLAS NICOLAS OMAR ',NULL,1),  
        (30716338793,9127551,16,NULL,'41809804','	ARGAÑARAZ AGUILERA CARHUE',NULL,1)
;

insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
    values (30716338793,9127551,17,NULL,'37315643','MIRANDA MICAELA SOLEDAD',NULL,1),
        (30716338793,9127551,18,NULL,'39051941','OJEDA LEANDRO GASPAR ',NULL,1),
        (30716338793,9127551,19,NULL,'36535238','SUAREZ EMILSE YAEL',NULL,1),
        (30716338793,9127551,20,NULL,'43524926','	MIRANDA MILAGROS NOEL',NULL,1),
        (14387806,9105693,1,null,'25278948','GALLEGO MARTA ELIZABETH',null,1),
        (35108032,9745625,1,null,27077871,'Carlos Alberto Oronel','1975-12-30',1),
		(35108032,9745625,2,null,26480639,'Samuel bellamy ','1978-03-06',1),
		(35108032,9745625,3,null,28430909,'José Luis oviedo ','1980-12-19',1),
        (95901236,277714,2,NULL,95809466,'PACHECO MAGDALENO DANIEL', '2002-12-12',1),
        (95901236,277714,3,NULL, 42107479, 'RUIZ FRANCO AGUSTIN', '1999-04-27', 1),
        (95901236,277714,1,NULL, 44874569,'SANTILLAN ANIBAL EZEQUIEL', '2003-02-12', 1)
    ;   

insert into cartera_cliente.siniestros (numero_siniestro,id_poliza,id_cia,id_ramo,id_tipo_siniestro,
    id_estado_siniestro,fecha_siniestro,descripcion_siniestro)
    values  (null,10697841,1,4,10,5,'2022-01-06','traslado de grua'),
        (2002686220,9841586,1,4,15,2,'2022-01-16',NULL),
        (2002688603,9841586,1,4,1,1,'2022-01-03',NULL),
        (14515,126236,4,7,16,1,'2022-01-18','TELEVISOR, PARCIAL')
;

SAVEPOINT ins_21trio;

COMMIT;