-- ============================================================
-- Script de creación de base de datos: bdfacturas_mariadb_local
-- Compatible con MySQL 8+ y MariaDB 10.5+
-- Incluye: tablas, restricciones, datos de ejemplo y triggers
-- ============================================================

-- Crear la base de datos (ejecutar aparte si es necesario):
-- CREATE DATABASE bdfacturas_mariadb_local CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- USE bdfacturas_mariadb_local;

-- ============================================================
-- TABLAS INDEPENDIENTES (sin foreign keys)
-- ============================================================

CREATE TABLE empresa (
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pk_empresa PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE persona (
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE producto (
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    stock INT NOT NULL,
    valorunitario DECIMAL(18,2) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE rol (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_rol PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ruta (
    ruta VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    CONSTRAINT pk_ruta PRIMARY KEY (ruta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE usuario (
    email VARCHAR(100) NOT NULL,
    contrasena VARCHAR(200) NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLAS DEPENDIENTES (con foreign keys)
-- ============================================================

CREATE TABLE cliente (
    id INT NOT NULL AUTO_INCREMENT,
    credito DECIMAL(18,2) NOT NULL DEFAULT 0,
    fkcodpersona VARCHAR(10) NOT NULL,
    fkcodempresa VARCHAR(10),
    CONSTRAINT pk_cliente PRIMARY KEY (id),
    CONSTRAINT fk_cliente_persona FOREIGN KEY (fkcodpersona) REFERENCES persona(codigo),
    CONSTRAINT fk_cliente_empresa FOREIGN KEY (fkcodempresa) REFERENCES empresa(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE vendedor (
    id INT NOT NULL AUTO_INCREMENT,
    carnet INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    fkcodpersona VARCHAR(10) NOT NULL,
    CONSTRAINT pk_vendedor PRIMARY KEY (id),
    CONSTRAINT fk_vendedor_persona FOREIGN KEY (fkcodpersona) REFERENCES persona(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE factura (
    numero INT NOT NULL AUTO_INCREMENT,
    fecha DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    total DECIMAL(18,2) NOT NULL DEFAULT 0,
    fkidcliente INT NOT NULL,
    fkidvendedor INT NOT NULL,
    CONSTRAINT pk_factura PRIMARY KEY (numero),
    CONSTRAINT fk_factura_cliente FOREIGN KEY (fkidcliente) REFERENCES cliente(id),
    CONSTRAINT fk_factura_vendedor FOREIGN KEY (fkidvendedor) REFERENCES vendedor(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE productosporfactura (
    fknumfactura INT NOT NULL,
    fkcodproducto VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_productosporfactura PRIMARY KEY (fknumfactura, fkcodproducto),
    CONSTRAINT fk_prodfact_factura FOREIGN KEY (fknumfactura) REFERENCES factura(numero) ON DELETE CASCADE,
    CONSTRAINT fk_prodfact_producto FOREIGN KEY (fkcodproducto) REFERENCES producto(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE rol_usuario (
    fkemail VARCHAR(100) NOT NULL,
    fkidrol INT NOT NULL,
    CONSTRAINT pk_rol_usuario PRIMARY KEY (fkemail, fkidrol),
    CONSTRAINT fk_rolusuario_usuario FOREIGN KEY (fkemail) REFERENCES usuario(email),
    CONSTRAINT fk_rolusuario_rol FOREIGN KEY (fkidrol) REFERENCES rol(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE rutarol (
    ruta VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    CONSTRAINT pk_rutarol PRIMARY KEY (ruta, rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- DATOS
-- ============================================================

-- Empresas
INSERT INTO empresa (codigo, nombre) VALUES
('E001', 'Comercial Los Andes S.A.'),
('E002', 'Distribuciones El Centro S.A.'),
('E999', 'Empresa Test');

-- Personas
INSERT INTO persona (codigo, nombre, email, telefono) VALUES
('P001', 'Ana Torres', 'ana.torres@correo.com', '3011111111'),
('P002', 'Carlos Pérez', 'carlos.perez@correo.com', '3022222222'),
('P003', 'María Gómez', 'maria.gomez@correo.com', '3033333333'),
('P004', 'Juan Díaz', 'juan.diaz@correo.com', '3044444444'),
('P005', 'Laura Rojas', 'laura.rojas@correo.com', '3055555555'),
('P006', 'Pedro Castillo', 'pedro.castillo@correo.com', '3066666666');

-- Productos
INSERT INTO producto (codigo, nombre, stock, valorunitario) VALUES
('PR001', 'Laptop Lenovo IdeaPad', 17, 2500000),
('PR002', 'Monitor Samsung 24"', 27, 800000),
('PR003', 'Teclado Logitech K380', 42, 150000),
('PR004', 'Mouse HP', 55, 90000),
('PR005', 'Impresora Epson EcoTank1', 14, 1100000),
('PR006', 'Auriculares Sony WH-CH510', 23, 240000),
('PR007', 'Tablet Samsung Tab A9', 15, 950000),
('PR008', 'Disco Duro Seagate 1TB', 32, 280000);

-- Roles
INSERT INTO rol (id, nombre) VALUES
(1, 'Administrador'),
(2, 'Vendedor'),
(3, 'Cajero'),
(4, 'Contador'),
(5, 'Cliente');

-- Rutas
INSERT INTO ruta (ruta, descripcion) VALUES
('/home', 'Página principal - Dashboard'),
('/usuarios', 'Gestión de usuarios'),
('/facturas', 'Gestión de facturas'),
('/clientes', 'Gestión de clientes'),
('/vendedores', 'Gestión de vendedores'),
('/personas', 'Gestión de personas'),
('/empresas', 'Gestión de empresas'),
('/productos', 'Gestión de productos'),
('/roles', 'Gestión de roles'),
('/permisos', 'Gestión de permisos (asignación rol-ruta)'),
('/permisos/crear', 'Crear permiso (POST)'),
('/permisos/eliminar', 'Eliminar permiso (POST)'),
('/rutas', 'Gestión de rutas del sistema'),
('/rutas/crear', 'Crear ruta (POST)'),
('/rutas/eliminar', 'Eliminar ruta (POST)');

-- Usuarios
INSERT INTO usuario (email, contrasena) VALUES
('admin@correo.com', '$2a$12$3UgI.Eof.FhzsYUWESI9n.qFaqkV2JPhvW3L/1GTKowNJnGaD8F.G'),
('vendedor1@correo.com', '$2a$12$Dgog4VaHqMzhliPVJy1BcOMd6.izEGNeRDtZ.O7SPmBLc6UVthVTG'),
('jefe@correo.com', 'jefe123'),
('cliente1@correo.com', 'cli123'),
('test_encript@correo.com', '$2a$11$Ci0J2yBltDgQHfjadgkl0OtbcF5pUf97vTq/4Xr0KEU/86l8ybjBe'),
('nuevo@correo.com', '$2a$11$cmtGBxllwc7MCzpnKVSWuumiOgCaG6PaKWcN1z9N0bjjnkobbFDzO');

-- Clientes
INSERT INTO cliente (id, credito, fkcodpersona, fkcodempresa) VALUES
(1, 520000, 'P001', 'E001'),
(2, 250000, 'P003', 'E002'),
(3, 400000, 'P005', 'E001'),
(5, 700000, 'P006', 'E001');

-- Vendedores
INSERT INTO vendedor (id, carnet, direccion, fkcodpersona) VALUES
(1, 1001, 'Calle 10 #5-33', 'P002'),
(2, 1002, 'Carrera 15 #7-20', 'P004'),
(3, 1003, 'Avenida 30 #18-09', 'P006');

-- Facturas
INSERT INTO factura (numero, fecha, total, fkidcliente, fkidvendedor) VALUES
(1, '2025-12-03 12:57:19.275920', 5000000, 1, 1),
(2, '2025-12-03 12:57:19.275920', 1250000, 2, 2),
(3, '2025-12-03 12:57:19.275920', 2030000, 3, 3),
(4, '2025-12-03 13:04:59.028613', 950000, 1, 1),
(5, '2025-12-03 13:05:17.874385', 2740000, 2, 2),
(6, '2025-12-03 13:05:35.028460', 4850000, 3, 3);

-- Productos por factura
INSERT INTO productosporfactura (fknumfactura, fkcodproducto, cantidad, subtotal) VALUES
(1, 'PR001', 2, 5000000),
(2, 'PR002', 1, 800000),
(2, 'PR003', 3, 450000),
(3, 'PR004', 5, 450000),
(3, 'PR005', 1, 1100000),
(3, 'PR006', 2, 480000),
(4, 'PR007', 1, 950000),
(5, 'PR007', 2, 1900000),
(5, 'PR008', 3, 840000),
(6, 'PR001', 1, 2500000),
(6, 'PR002', 2, 1600000),
(6, 'PR003', 5, 750000);

-- Roles por usuario
INSERT INTO rol_usuario (fkemail, fkidrol) VALUES
('admin@correo.com', 1),
('vendedor1@correo.com', 2),
('vendedor1@correo.com', 3),
('jefe@correo.com', 1),
('jefe@correo.com', 3),
('jefe@correo.com', 4),
('cliente1@correo.com', 5),
('test_encript@correo.com', 1),
('nuevo@correo.com', 1),
('nuevo@correo.com', 2),
('nuevo@correo.com', 3);

-- Rutas por rol
INSERT INTO rutarol (ruta, rol) VALUES
('/home', 'Administrador'),
('/usuarios', 'Administrador'),
('/facturas', 'Administrador'),
('/clientes', 'Administrador'),
('/vendedores', 'Administrador'),
('/personas', 'Administrador'),
('/empresas', 'Administrador'),
('/productos', 'Administrador'),
('/roles', 'Administrador'),
('/permisos', 'Administrador'),
('/permisos/crear', 'Administrador'),
('/permisos/eliminar', 'Administrador'),
('/rutas', 'Administrador'),
('/rutas/crear', 'Administrador'),
('/rutas/eliminar', 'Administrador'),
('/home', 'Vendedor'),
('/facturas', 'Vendedor'),
('/clientes', 'Vendedor'),
('/home', 'Cajero'),
('/facturas', 'Cajero'),
('/home', 'Contador'),
('/clientes', 'Contador'),
('/productos', 'Contador'),
('/home', 'Cliente'),
('/productos', 'Cliente');

-- ============================================================
-- TRIGGER: Actualizar totales de factura y stock de producto
-- En MySQL/MariaDB se necesitan 3 triggers separados (uno por
-- operación: INSERT, UPDATE, DELETE) ya que no soporta
-- BEFORE INSERT OR UPDATE OR DELETE en un solo trigger.
-- ============================================================

DELIMITER $$

-- Trigger BEFORE INSERT
CREATE TRIGGER trg_prodfact_before_insert
    BEFORE INSERT ON productosporfactura
    FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    DECLARE v_valorunitario DECIMAL(18,2);

    -- Obtener stock y valor unitario del producto
    SELECT stock, valorunitario INTO v_stock, v_valorunitario
    FROM producto WHERE codigo = NEW.fkcodproducto;

    -- Validar stock suficiente
    IF v_stock < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para el producto solicitado';
    END IF;

    -- Calcular subtotal
    SET NEW.subtotal = NEW.cantidad * v_valorunitario;

    -- Descontar stock
    UPDATE producto SET stock = stock - NEW.cantidad WHERE codigo = NEW.fkcodproducto;

    -- Actualizar total de la factura
    UPDATE factura SET total = (
        SELECT COALESCE(SUM(subtotal), 0) FROM productosporfactura WHERE fknumfactura = NEW.fknumfactura
    ) + NEW.subtotal WHERE numero = NEW.fknumfactura;
END$$

-- Trigger BEFORE UPDATE
CREATE TRIGGER trg_prodfact_before_update
    BEFORE UPDATE ON productosporfactura
    FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    DECLARE v_valorunitario DECIMAL(18,2);

    -- Obtener stock actual y valor unitario
    SELECT stock, valorunitario INTO v_stock, v_valorunitario
    FROM producto WHERE codigo = NEW.fkcodproducto;

    -- Validar stock suficiente (considerando devolución del anterior)
    IF (v_stock + OLD.cantidad) < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para el producto solicitado';
    END IF;

    -- Calcular nuevo subtotal
    SET NEW.subtotal = NEW.cantidad * v_valorunitario;

    -- Ajustar stock (devolver anterior, descontar nuevo)
    UPDATE producto SET stock = stock + OLD.cantidad - NEW.cantidad WHERE codigo = NEW.fkcodproducto;

    -- Recalcular total de la factura
    UPDATE factura SET total = (
        SELECT COALESCE(SUM(subtotal), 0) FROM productosporfactura
        WHERE fknumfactura = NEW.fknumfactura AND fkcodproducto != NEW.fkcodproducto
    ) + NEW.subtotal WHERE numero = NEW.fknumfactura;
END$$

-- Trigger AFTER DELETE
CREATE TRIGGER trg_prodfact_after_delete
    AFTER DELETE ON productosporfactura
    FOR EACH ROW
BEGIN
    -- Restaurar stock del producto eliminado
    UPDATE producto SET stock = stock + OLD.cantidad WHERE codigo = OLD.fkcodproducto;

    -- Recalcular total de la factura
    UPDATE factura SET total = (
        SELECT COALESCE(SUM(subtotal), 0) FROM productosporfactura
        WHERE fknumfactura = OLD.fknumfactura
    ) WHERE numero = OLD.fknumfactura;
END$$

DELIMITER ;

-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS - FACTURAS Y PRODUCTOS POR FACTURA
-- Compatible con MySQL 8+ y MariaDB 10.5+
-- ============================================================

DELIMITER $$

-- ------------------------------------------------------------
-- 1. SP INSERTAR FACTURA Y PRODUCTOSPORFACTURA
-- Recibe: id cliente, id vendedor, y un JSON array de productos
-- Retorna: JSON con la factura creada y sus productos
-- Nota: El trigger se encarga de calcular subtotal, descontar
--       stock y actualizar total factura.
-- ------------------------------------------------------------
CREATE PROCEDURE sp_insertar_factura_y_productosporfactura(
    IN p_fkidcliente INT,
    IN p_fkidvendedor INT,
    IN p_productos JSON,
    IN p_minimo_detalle INT
)
BEGIN
    DECLARE v_numero INT;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_total_items INT;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_cantidad INT;
    DECLARE v_minimo INT;

    SET v_minimo = IF(p_minimo_detalle IS NULL OR p_minimo_detalle = 0, 1, p_minimo_detalle);
    SET v_total_items = JSON_LENGTH(p_productos);

    IF p_productos IS NULL OR v_total_items < v_minimo THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La factura requiere minimo el numero de producto(s) indicado.';
    END IF;

    -- Crear la factura con total 0 (el trigger actualiza el total)
    INSERT INTO factura (fkidcliente, fkidvendedor, total)
    VALUES (p_fkidcliente, p_fkidvendedor, 0);

    SET v_numero = LAST_INSERT_ID();

    -- Recorrer cada producto del JSON e insertar detalle
    WHILE v_i < v_total_items DO
        SET v_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].codigo')));
        SET v_cantidad = JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].cantidad'));

        INSERT INTO productosporfactura (fknumfactura, fkcodproducto, cantidad, subtotal)
        VALUES (v_numero, v_codigo, v_cantidad, 0);

        SET v_i = v_i + 1;
    END WHILE;

    -- Retornar resultado
    SELECT JSON_OBJECT(
        'factura', (
            SELECT JSON_OBJECT(
                'numero', f.numero, 'fecha', f.fecha, 'total', f.total,
                'fkidcliente', f.fkidcliente, 'fkidvendedor', f.fkidvendedor
            ) FROM factura f WHERE f.numero = v_numero
        ),
        'productos', (
            SELECT JSON_ARRAYAGG(JSON_OBJECT(
                'codigo_producto', pf.fkcodproducto, 'nombre_producto', pr.nombre,
                'cantidad', pf.cantidad, 'valorunitario', pr.valorunitario, 'subtotal', pf.subtotal
            ))
            FROM productosporfactura pf
            JOIN producto pr ON pr.codigo = pf.fkcodproducto
            WHERE pf.fknumfactura = v_numero
        )
    ) AS p_resultado;
END$$

-- ------------------------------------------------------------
-- 2. SP CONSULTAR FACTURA Y PRODUCTOSPORFACTURA
-- ------------------------------------------------------------
CREATE PROCEDURE sp_consultar_factura_y_productosporfactura(
    IN p_numero INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM factura WHERE numero = p_numero) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Factura no existe';
    END IF;

    SELECT JSON_OBJECT(
        'factura', JSON_OBJECT(
            'numero', f.numero, 'fecha', f.fecha, 'total', f.total,
            'fkidcliente', f.fkidcliente, 'nombre_cliente', pc.nombre,
            'fkidvendedor', f.fkidvendedor, 'nombre_vendedor', pv.nombre
        ),
        'productos', (
            SELECT JSON_ARRAYAGG(JSON_OBJECT(
                'codigo_producto', pr.codigo, 'nombre_producto', pr.nombre,
                'cantidad', pf.cantidad, 'valorunitario', pr.valorunitario, 'subtotal', pf.subtotal
            ))
            FROM productosporfactura pf
            JOIN producto pr ON pr.codigo = pf.fkcodproducto
            WHERE pf.fknumfactura = f.numero
        )
    ) AS p_resultado
    FROM factura f
    JOIN cliente c ON c.id = f.fkidcliente
    JOIN persona pc ON pc.codigo = c.fkcodpersona
    JOIN vendedor v ON v.id = f.fkidvendedor
    JOIN persona pv ON pv.codigo = v.fkcodpersona
    WHERE f.numero = p_numero;
END$$

-- ------------------------------------------------------------
-- 3. SP LISTAR FACTURAS Y PRODUCTOSPORFACTURA
-- ------------------------------------------------------------
CREATE PROCEDURE sp_listar_facturas_y_productosporfactura()
BEGIN
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'numero', f.numero, 'fecha', f.fecha, 'total', f.total,
            'fkidcliente', f.fkidcliente, 'nombre_cliente', pc.nombre,
            'fkidvendedor', f.fkidvendedor, 'nombre_vendedor', pv.nombre,
            'productos', (
                SELECT JSON_ARRAYAGG(JSON_OBJECT(
                    'codigo_producto', pr.codigo, 'nombre_producto', pr.nombre,
                    'cantidad', pf.cantidad, 'valorunitario', pr.valorunitario, 'subtotal', pf.subtotal
                ))
                FROM productosporfactura pf
                JOIN producto pr ON pr.codigo = pf.fkcodproducto
                WHERE pf.fknumfactura = f.numero
            )
        )
    ) AS p_resultado
    FROM factura f
    JOIN cliente c ON c.id = f.fkidcliente
    JOIN persona pc ON pc.codigo = c.fkcodpersona
    JOIN vendedor v ON v.id = f.fkidvendedor
    JOIN persona pv ON pv.codigo = v.fkcodpersona;
END$$

-- ------------------------------------------------------------
-- 4. SP ACTUALIZAR FACTURA Y PRODUCTOSPORFACTURA
-- ------------------------------------------------------------
CREATE PROCEDURE sp_actualizar_factura_y_productosporfactura(
    IN p_numero INT,
    IN p_fkidcliente INT,
    IN p_fkidvendedor INT,
    IN p_productos JSON,
    IN p_minimo_detalle INT
)
BEGIN
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_total_items INT;
    DECLARE v_codigo VARCHAR(10);
    DECLARE v_cantidad INT;
    DECLARE v_minimo INT;

    IF NOT EXISTS (SELECT 1 FROM factura WHERE numero = p_numero) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Factura no existe';
    END IF;

    SET v_minimo = IF(p_minimo_detalle IS NULL OR p_minimo_detalle = 0, 1, p_minimo_detalle);
    SET v_total_items = JSON_LENGTH(p_productos);

    IF p_productos IS NULL OR v_total_items < v_minimo THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La factura requiere minimo el numero de producto(s) indicado.';
    END IF;

    -- Eliminar detalle anterior (el trigger restaura stock y recalcula total)
    DELETE FROM productosporfactura WHERE fknumfactura = p_numero;

    -- Insertar nuevos productos (el trigger calcula subtotal, descuenta stock, actualiza total)
    WHILE v_i < v_total_items DO
        SET v_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].codigo')));
        SET v_cantidad = JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].cantidad'));

        INSERT INTO productosporfactura (fknumfactura, fkcodproducto, cantidad, subtotal)
        VALUES (p_numero, v_codigo, v_cantidad, 0);

        SET v_i = v_i + 1;
    END WHILE;

    -- Actualizar cliente y vendedor de la factura
    UPDATE factura
    SET fkidcliente = p_fkidcliente,
        fkidvendedor = p_fkidvendedor
    WHERE numero = p_numero;

    -- Retornar resultado
    SELECT JSON_OBJECT(
        'factura', (
            SELECT JSON_OBJECT(
                'numero', f.numero, 'fecha', f.fecha, 'total', f.total,
                'fkidcliente', f.fkidcliente, 'fkidvendedor', f.fkidvendedor
            ) FROM factura f WHERE f.numero = p_numero
        ),
        'productos', (
            SELECT JSON_ARRAYAGG(JSON_OBJECT(
                'codigo_producto', pf.fkcodproducto, 'nombre_producto', pr.nombre,
                'cantidad', pf.cantidad, 'valorunitario', pr.valorunitario, 'subtotal', pf.subtotal
            ))
            FROM productosporfactura pf
            JOIN producto pr ON pr.codigo = pf.fkcodproducto
            WHERE pf.fknumfactura = p_numero
        )
    ) AS p_resultado;
END$$

-- ------------------------------------------------------------
-- 5. SP BORRAR FACTURA Y PRODUCTOSPORFACTURA
-- ON DELETE CASCADE elimina productosporfactura automáticamente.
-- El trigger restaura stock al borrar cada producto de la factura.
-- ------------------------------------------------------------
CREATE PROCEDURE sp_borrar_factura_y_productosporfactura(
    IN p_numero INT
)
BEGIN
    DECLARE v_total DECIMAL(18,2);
    DECLARE v_cantidad_productos INT;

    IF NOT EXISTS (SELECT 1 FROM factura WHERE numero = p_numero) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Factura no existe';
    END IF;

    -- Guardar info antes de borrar para el JSON de respuesta
    SELECT COUNT(*) INTO v_cantidad_productos
    FROM productosporfactura WHERE fknumfactura = p_numero;

    SELECT total INTO v_total FROM factura WHERE numero = p_numero;

    -- Borrar factura (ON DELETE CASCADE borra productosporfactura,
    -- y el trigger restaura stock por cada producto eliminado)
    DELETE FROM factura WHERE numero = p_numero;

    -- Retornar resultado
    SELECT JSON_OBJECT(
        'mensaje', 'Factura eliminada exitosamente',
        'numero_eliminado', p_numero,
        'total_eliminado', v_total,
        'productos_eliminados', v_cantidad_productos
    ) AS p_resultado;
END$$

DELIMITER ;
