DELIMITER $$
CREATE TRIGGER TRG_PRODUCTOS
BEFORE UPDATE  ON PRODUCTOS
FOR EACH ROW 
BEGIN

IF NEW.COSTO <> OLD.COSTO
 THEN 
   SET NEW.PRECIO = NEW.COSTO*2;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER TRG_PRODUCTOS
BEFORE UPDATE  ON PRODUCTOS
FOR EACH ROW 
BEGIN

IF NEW.COSTO <> OLD.COSTO
 THEN 
   SET NEW.PRECIO = NEW.COSTO*2;
END IF;

END$$
DELIMITER ;

CREATE TABLE AUDITORIA (
ID_AUDITORIA
CAMPO_ANTERIOR ,
CAMPO_NUEVO ,
USER_QUE_MODIFICO ,
FECHA 
);

UPDATE PRODUCTOS SET COSTO = 5 WHERE ID = 2;

SELECT * FROM  PRODUCTOS   WHERE ID = 2; -- COSTO = 2 PRECIO = 6
SELECT * FROM  PRODUCTOS   WHERE ID = 2; -- COSTO = 5 PRECIO = 1



ejemplo de liomitantes en datos
CREATE TABLE ALUMNOS (
ID INT  UNSIGNED AUTO_INCREMENT PRIMARY KEY,
NOMBRE VARCHAR(50) NOT NULL ,
APELLIDO VARCHAR(50) NOT NULL,
NOTA FLOAT
);
DELIMITER $$
DROP TRIGGER IF EXISTS TRG_ALUMNOS$$
CREATE TRIGGER TRG_ALUMNOS
BEFORE INSERT  ON ALUMNOS
FOR EACH ROW 
BEGIN

IF NEW.NOTA  < 0 
 THEN 
  SET NEW.NOTA  = 0;
  ELSEIF  NEW.NOTA  > 10  THEN 
   SET NEW.NOTA  = 10;

 END IF ;  


END$$
DELIMITER ;

INSERT INTO ALUMNOS VALUES ( 4,'LUIS','LOPEZ', 8.7);
INSERT INTO ALUMNOS VALUES ( 5,'SUSANA','SANCHEZ', 11);
INSERT INTO ALUMNOS VALUES ( 6,'PEDRO','PEREZ', 10 );
INSERT INTO ALUMNOS VALUES ( 1,'PEPE','LOPEZ', -1,'');
INSERT INTO ALUMNOS VALUES ( 2,'MARIA','SANCHEZ', -1,'');
INSERT INTO ALUMNOS VALUES ( 3,'JUAN','PEREZ', -1,'');

INSERT INTO ALUMNOS VALUES ( 4,'LUIS','LOPEZ', 8.7,'');
INSERT INTO ALUMNOS VALUES ( 5,'SUSANA','SANCHEZ', 11,'');
INSERT INTO ALUMNOS VALUES ( 6,'PEDRO','PEREZ', 10,'' );


DELIMITER $$
DROP TRIGGER IF EXISTS TRG_ALUMNOS$$
CREATE TRIGGER TRG_ALUMNOS
BEFORE INSERT  ON ALUMNOS
FOR EACH ROW 
BEGIN

IF NEW.NOTA  < 0 
 THEN 
  SET NEW.NOTA  = 0;
  SET NEW.DESCRIPCION='LA NOTA ES CERO';
  ELSEIF  NEW.NOTA  > 10  THEN 
   SET NEW.NOTA  = 10;
   SET NEW.DESCRIPCION='LA NOTA ES MAYOR A 10';
 END IF ;  


END$$
DELIMITER ;

desc cartera_cliente.clientes;

CREATE TABLE PRODUCTOS (
ID INT NOT NULL AUTO_INCREMENT,
NOMBRE VARCHAR(255) NOT NULL, 
COSTO FLOAT NOT NULL DEFAULT 0.0 ,
PRECIO FLOAT NOT NULL DEFAULT 0.0,
PRIMARY KEY(ID)