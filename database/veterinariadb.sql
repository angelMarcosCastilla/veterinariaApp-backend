DROP DATABASE IF EXISTS veterinariadb;

CREATE DATABASE veterinariadb;
USE veterinariadb;

CREATE TABLE ANIMALES(
  idanimal        INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombreanimal    VARCHAR(45) NOT NULL
)ENGINE = INNODB; 

CREATE TABLE RAZAS(
  idraza          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombreraza      VARCHAR(45) NOT NULL,
  idanimal        INT NOT NULL,
  CONSTRAINT fk_idanimal FOREIGN KEY (idanimal) REFERENCES ANIMALES(idanimal)
)ENGINE = INNODB;

CREATE TABLE CLIENTES(
  idcliente       INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombres         VARCHAR(45) NOT NULL,
  apellidos       VARCHAR(45) NOT NULL,
  dni             CHAR(8) NOT NULL,
  claveacceso     VARCHAR(90) NULL,
  telefono        VARCHAR(9) NULL,
  direccion       VARCHAR(45) NULL,
  genero          CHAR(1) NULL,
  nombreusuario   VARCHAR(45) NULL,
  estado          BIT DEFAULT 1
)ENGINE = INNODB;

CREATE TABLE MASCOTAS(
  idmascota       INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  idcliente       INT NOT NULL,
  idraza          INT NOT NULL,
  nombre          VARCHAR(45) NOT NULL,
  fotografia      VARCHAR(90) NOT NULL,
  color           VARCHAR(45) NOT NULL,
  genero          CHAR(1) NOT NULL,
  
  CONSTRAINT fk_idcliente FOREIGN KEY (idcliente) REFERENCES CLIENTES(idcliente),
  CONSTRAINT fk_idraza FOREIGN KEY (idraza) REFERENCES RAZAS(idraza),
  CONSTRAINT ck_genero CHECK (genero IN ('M','H'))
)ENGINE = INNODB;

-- BUSCAR CLIENTE
DELIMITER $$
CREATE PROCEDURE SPU_BUSCAR_CLIENTE(IN _dni CHAR(8))
BEGIN
  SELECT idcliente, CONCAT(nombres, " ", "apellidos") as label  FROM CLIENTES WHERE dni = _dni;
END $$

DELIMITER $$
CREATE PROCEDURE SPU_LISTAR_CLIENTE()
BEGIN
  SELECT idcliente as id, CONCAT(nombres, " ", apellidos) as label  FROM CLIENTES;
END $$

-- REGISTRAR CLIENTES
DELIMITER $$
CREATE PROCEDURE SPU_REGISTRAR_CLIENTE(
  IN _nombres VARCHAR(45),
  IN _apellidos VARCHAR(45), 
  IN _dni CHAR(8),
  IN _telefono VARCHAR(45),
  IN _direccion VARCHAR(45),
  IN _genero CHAR(1)
  )
BEGIN
  INSERT INTO CLIENTES(nombres, apellidos, dni, direccion, telefono, genero) VALUES (_nombres, _apellidos, _dni, _direccion, _telefono, _genero);
END $$

-- DETALLE MASCOTA POR CLIENTE
DELIMITER $$
CREATE PROCEDURE SPU_DETALLE_MASCOTA_CLIENTE(IN _dni CHAR(8))
BEGIN
  SELECT 
  MASCOTAS.idmascota,
  MASCOTAS.nombre,
  MASCOTAS.fotografia,
  MASCOTAS.color,
  MASCOTAS.genero,
  CLIENTES.nombres,
  CLIENTES.apellidos,
  RAZAS.nombreraza,
  ANIMALES.nombreanimal
  FROM MASCOTAS
  INNER JOIN CLIENTES ON CLIENTES.idcliente = MASCOTAS.idcliente
  INNER JOIN RAZAS ON RAZAS.idraza = MASCOTAS.idraza
  INNER JOIN ANIMALES ON ANIMALES.idanimal = RAZAS.idanimal
  WHERE CLIENTES.dni = _dni ;
END $$

DELIMITER $$
CREATE PROCEDURE SPU_DETALLE_MASCOTA(IN _idmascota int)
BEGIN
  SELECT 
  MASCOTAS.idmascota,
  MASCOTAS.nombre,
  MASCOTAS.fotografia,
  MASCOTAS.color,
  MASCOTAS.genero,
  CLIENTES.nombres,
  CLIENTES.apellidos,
  RAZAS.nombreraza,
  ANIMALES.nombreanimal
  FROM MASCOTAS
  INNER JOIN CLIENTES ON CLIENTES.idcliente = MASCOTAS.idcliente
  INNER JOIN RAZAS ON RAZAS.idraza = MASCOTAS.idraza
  INNER JOIN ANIMALES ON ANIMALES.idanimal = RAZAS.idanimal
  WHERE mascotas.idmascota = _idmascota ;
END $$

-- REGISTRAR MASCOTA
DELIMITER $$
CREATE PROCEDURE SPU_REGISTRAR_MASCOTA(
  IN _idcliente INT,
  IN _idraza INT, 
  IN _nombre VARCHAR(45), 
  IN _fotografia VARCHAR(90), 
  IN _color VARCHAR(45), 
  IN _genero CHAR(1))
BEGIN
  INSERT INTO MASCOTAS(idcliente, idraza, nombre, fotografia, color, genero)
  VALUES (_idcliente, _idraza, _nombre, _fotografia, _color, _genero);
END $$

-- lOGIN

DELIMITER $$
CREATE PROCEDURE SPU_LOGIN(IN _username VARCHAR(45))
BEGIN
  SELECT * FROM CLIENTES WHERE nombreusuario = _username;
END $$


-- listar razas 
DELIMITER $$
CREATE PROCEDURE SPU_LISTAR_RAZA(IN _idanimal INT)
BEGIN
  SELECT idraza as id, nombreraza as label  FROM RAZAS WHERE idanimal = _idanimal ;
END $$

DELIMITER $$
CREATE PROCEDURE SPU_LISTAR_ANIMALES()
BEGIN
  SELECT idanimal as id, nombreanimal as label , idanimal FROM ANIMALES;
END $$

DELIMITER $$
CREATE PROCEDURE SPU_ELIMINAR_MASCOTA(IN _idmascota INT)
BEGIN
  DELETE FROM MASCOTAS WHERE idmascota = _idmascota;
END $$

INSERT INTO CLIENTES(nombres, apellidos, dni, claveacceso, nombreusuario ) VALUES
('Angel Marcos', 'Perez', '73963911', '1234', "angel"),
('Maria', 'Munayco', '87654321',null, null),
('Juan', 'Perez', '12345678', null, null),
('Arturo', 'Saravia', '87054321', null, null);

INSERT INTO ANIMALES(nombreanimal) VALUES
('Perro'),
('Gato'),
('Conejo'),
('Pez');

INSERT INTO RAZAS(nombreraza, idanimal) VALUES
('Labrador', 1),
('Pastor Aleman', 1),
('Bulldog', 1),
('Persa', 2),
('Siames', 2),
('Cabeza de Leon', 3),
('Cabeza de Lechuga', 3),
('Dorado', 4),
('Beta', 4);

CALL SPU_REGISTRAR_MASCOTA(2, 1, "Luna", "Labrador1.jpg", "Marron", "M");
CALL SPU_REGISTRAR_MASCOTA(2, 2, "Rambo", "pastorAleman1.jpg", "Mostsa y Negro", "H");
CALL SPU_REGISTRAR_MASCOTA(1, 3, "Balto", "Bulgog.jpg", "Crema", "M");
CALL SPU_REGISTRAR_MASCOTA(1, 5, "Blanca", "siames1.jpg", "Mostasa marrón", "H");