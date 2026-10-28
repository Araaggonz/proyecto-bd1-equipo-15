
---TRIGGER DE STOCK CUANDO SE REALIZA UNA COMPRA 

CREATE OR ALTER TRIGGER TR_producto_compra_stock
ON Producto_Compra
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
            cantidad AS cambio_stock
        FROM inserted

        UNION ALL

        SELECT
            id_producto,
            -cantidad AS cambio_stock
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

        THROW 50003,
              'Stock insuficiente para realizar la operacion.',
              1;
    END;

    UPDATE p
    SET p.stock_actual = p.stock_actual + c.cambio_stock
    FROM Producto AS p
    INNER JOIN @Cambios AS c
        ON p.id_producto = c.id_producto;
END;


SELECT name
FROM sys.triggers
WHERE name = 'TR_producto_compra_stock';



--- PRUEBA DE INGRESO DE STOCK
BEGIN TRY
    BEGIN TRANSACTION;

    -- Registrar temporalmente 3 unidades compradas
    INSERT INTO Producto_Compra
        (precio_unitario, cantidad, subtotal_, id_producto, id_compra)
    VALUES
        (1500.00, 3, 4500.00, 10, 1);

    -- Comprobar el stock después de la compra
    SELECT
        id_producto,
        nombre,
        stock_actual
    FROM Producto
    WHERE id_producto = 10;

    -- Revertir todos los cambios de la prueba
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
WHERE id_producto = 10;



---PRUEBA CUANDO SE MODIFICA LA CANTIDAD COMPRADA

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Producto_Compra
    SET cantidad = cantidad + 1,
        subtotal_ = (cantidad + 1) * precio_unitario
    WHERE id_producto = 1
      AND id_compra = 1;

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



---PRUEBA CUANDO SE ELIMINA UNA COMPRA REALIZADA 
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE FROM Producto_Compra
    WHERE id_producto = 1
      AND id_compra = 1;

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