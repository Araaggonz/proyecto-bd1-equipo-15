
 ---TRIGGER PARA DESCONTAR EL STOCK CUANDO SE REGISTRA UNA MERMA EN UN PRODUCTO
CREATE OR ALTER TRIGGER TR_merma_stock
ON Merma
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Cambios TABLE (
        id_producto INT PRIMARY KEY,
        cambio_stock INT
    );

    INSERT INTO @Cambios (id_producto, cambio_stock)
    SELECT
        id_producto,
        SUM(cambio_stock)
    FROM (
        SELECT
            id_producto,
            -cantidad AS cambio_stock
        FROM inserted

        UNION ALL

        SELECT
            id_producto,
            cantidad AS cambio_stock
        FROM deleted
    ) AS movimientos
    GROUP BY id_producto
    HAVING SUM(cambio_stock) <> 0;

    IF EXISTS (
        SELECT 1
        FROM Producto AS p
        INNER JOIN @Cambios AS c
            ON p.id_producto = c.id_producto
        WHERE p.stock_actual + c.cambio_stock < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;

        THROW 50004,
              'Stock insuficiente para registrar la merma.',
              1;
    END;

    UPDATE p
    SET p.stock_actual = p.stock_actual + c.cambio_stock
    FROM Producto AS p
    INNER JOIN @Cambios AS c
        ON p.id_producto = c.id_producto;
END;



---PRUEBA DE INSERCION DE REGISTRO DE MERMA
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Merma
        (id_merma, motivo, fecha, cantidad, id_producto)
    VALUES
        (9, 'Prueba del trigger', GETDATE(), 3, 1);

    SELECT
        id_producto,
        nombre,
        stock_actual
    FROM Producto
    WHERE id_producto = 1;

    ROLLBACK TRANSACTION;

    PRINT 'Prueba finalizada. Los cambios fueron revertidos.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT ERROR_MESSAGE() AS mensaje_error;
END CATCH;

SELECT
    id_producto,
    nombre,
    stock_actual
FROM Producto
WHERE id_producto = 1;



---PRUEBA DE MODIFICACION DE UNA MERMA
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Merma
    SET cantidad = cantidad + 1
    WHERE id_merma = 1;

    -- Comprobar el stock durante la prueba
    SELECT
        id_producto,
        nombre,
        stock_actual
    FROM Producto
    WHERE id_producto = 1;

    -- Revertir los cambios
    ROLLBACK TRANSACTION;

    PRINT 'Prueba finalizada. Los cambios fueron revertidos.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT ERROR_MESSAGE() AS mensaje_error;
END CATCH;

-- Comprobar que el stock volvió a su valor original
SELECT
    id_producto,
    nombre,
    stock_actual
FROM Producto
WHERE id_producto = 1;



---PRUEBA ELIMINACION DE UNA MERMA
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE FROM Merma
    WHERE id_merma = 1;

    -- Comprobar el stock durante la prueba
    SELECT
        id_producto,
        nombre,
        stock_actual
    FROM Producto
    WHERE id_producto = 1;

    -- Revertir los cambios
    ROLLBACK TRANSACTION;

    PRINT 'Prueba finalizada. Los cambios fueron revertidos.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT ERROR_MESSAGE() AS mensaje_error;
END CATCH;

-- Comprobar que el stock volvió a su valor original
SELECT
    id_producto,
    nombre,
    stock_actual
FROM Producto
WHERE id_producto = 1;




----------------------------------------

--- CREACION DE TABLA AUXILIAR DE LA TABLA PRODUCTO

CREATE TABLE Auditoria_Producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    nombre VARCHAR(50) NULL,
    descripcion VARCHAR(80) NULL,
    stock_actual INT NULL,
    stock_minimo INT NULL,
    estado VARCHAR(80) NULL,
    id_categoria INT NULL,
    operacion VARCHAR(10) NOT NULL,
    fecha_hora DATETIME2 NOT NULL,
    usuario_bd SYSNAME NOT NULL
);


---TRIGGER DE AUDITORIA

CREATE OR ALTER TRIGGER TR_auditoria_producto
ON Producto
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Operacion VARCHAR(10);

    IF EXISTS (SELECT 1 FROM inserted)
        SET @Operacion = 'UPDATE';
    ELSE
        SET @Operacion = 'DELETE';

    INSERT INTO Auditoria_Producto (
        id_producto,
        nombre,
        descripcion,
        stock_actual,
        stock_minimo,
        estado,
        id_categoria,
        operacion,
        fecha_hora,
        usuario_bd
    )
    SELECT
        id_producto,
        nombre,
        descripcion,
        stock_actual,
        stock_minimo,
        estado,
        id_categoria,
        @Operacion,
        SYSDATETIME(),
        USER_NAME()
    FROM deleted;
END;



---PRUEBA DE MODIFICACION DE UN PRODUCTO  (auditoría)
BEGIN TRANSACTION;

-- Modificar temporalmente la descripción del producto
UPDATE Producto
SET descripcion = 'Prueba de auditoria'
WHERE id_producto = 1;

-- Consultar el registro guardado por el trigger
SELECT *
FROM Auditoria_Producto
WHERE id_producto = 1
ORDER BY id_auditoria DESC;

-- Deshacer la prueba
ROLLBACK TRANSACTION;



---PRUEBA DE ELIMINACION DE UN PRODUCTO (auditoría)
BEGIN TRANSACTION;

-- 1. Crear un producto temporal
INSERT INTO Producto (
    id_producto,
    nombre,
    descripcion,
    stock_actual,
    stock_minimo,
    estado,
    id_categoria
)
VALUES (
    999,
    'Producto de prueba',
    'Producto temporal para probar auditoria',
    10,
    2,
    'ACTIVO',
    8
);

-- 2. Eliminar el producto temporal
DELETE FROM Producto
WHERE id_producto = 999;

-- 3. Consultar los registros de auditoría
SELECT *
FROM Auditoria_Producto
WHERE id_producto = 999
ORDER BY id_auditoria DESC;

-- 4. Deshacer toda la prueba
ROLLBACK TRANSACTION;




---TRIGGER QUE IMPIDE ELIMINAR UN REGISTRO DE UNA TABLA (TABLA: CATEGORIA)
CREATE OR ALTER TRIGGER TR_bloquear_delete_categoria
ON Categoria
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    THROW 50005, 'No se permite eliminar registros de la tabla Categoria.', 1;
END;


---prueba de intento de eliminacion de un registro 

DELETE FROM Categoria
WHERE id_categoria = 8;


---verificar que la categoria siga existiendo
SELECT *
FROM Categoria
WHERE id_categoria = 8;




