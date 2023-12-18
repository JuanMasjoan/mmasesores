START TRANSACTION ; 

UPDATE `after_class`.`cliente` SET `telefono` = '08000'  
WHERE (`id_cliente` = '741') ;
COMMIT ;


select * from cliente ;
START TRANSACTION ;
SAVEPOINT SAVEINICIAL ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '743', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '744', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '745', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '746', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
SAVEPOINT LOTE_1_4;
INSERT INTO `after_class`.`cliente`  
VALUES ( '747', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '748', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '749', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
INSERT INTO `after_class`.`cliente`  
VALUES ( '750', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunja' ) ;
SAVEPOINT RESGUARDO2;
INSERT INTO `after_class`.`cliente`  
VALUES ( '751', 'Larry Page', 'Cll 05#52-95', '08000', 'Tunj
SELECT * FROM `after_class`.`cliente`   ; 

COMMIT  ## AL ULTIMO SE PONE O 100% SEGURO DEL CAMBIO.. NO TENES VUELTA ATRAS


ROLLBACK TO LOTE_1_4 ;
ROLLBACK TO SAVEINCIAL  ;
ROLLBACK ;

COMMIT ;
ROLLBACK;
SAVEPOINT NOMBRE; 
