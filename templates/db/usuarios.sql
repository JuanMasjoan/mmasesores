nueva


use sys ;
select * from sys_config;
use mysql ;
show tables;

select * from  user 

select * from  user ;


create user 'usario'@'dominiodondeseencuentraconectadomysqlenlamaquina';
create user 'usario'@'hosting';
create user 'usuario'@'dbbase';
create user 'usuario'@'12.98.43.45';
create user 'usuario'@'localhost';

--crear usuario con contraseñá
create user 'usuario'@'12.98.43.47' identified by 'password';
 
 -- cambiar contraseñá

 create user 'usuario'@'12.98.43.47' identified by 'password';

alter user  'usuario'@'12.98.43.47' identified by '123password';

select * from  user ;

update user set password = password('nuevacontraseña') 
where user = 'usuario' and  host = '12.98.43.47' ; 

-- renombrar usuario

 rename user 'usuario'@'dbbase' to 'usuarios'@'dbbases';

-- eliminar usuario
 drop user 'usuarios'@'dbbases';
 
 -- validamos usuario

  select * from  user where host  = 'hosting';


UPDATE  USER  SET authentication_string  =   'NUEVACONTRASENA'
where   host = 'hosting';

-- dar todos los permisos

GRANT ALL ON *.* TO 'USUARIO'@'DOMINIO';

-- PERMISOS SOBRE UNA TABLA ESPECIFICA

GRANT ON BASE.TABLA TO 'USUARIO'@'DOMINIO';

-- DISTINTOS PERMISOS UPDATE / DELETE / SELECT / INSERT

GRANT SELECT ON *.* TO 'USUARIO'@'DOMINIO';

-- PERMISOS POR COLUMNA POR COLUMNA
GRANT SELECT (COLUMNA) ON BASE.TABLA TO 'USUARIO'@'DOMINIO';

-- PERMISOS POR COLUMNA POR COLUMNA0
REVOKE DELETE , INSERT, UPDATE ON *.* FROM 'mancha2'@'localhost',