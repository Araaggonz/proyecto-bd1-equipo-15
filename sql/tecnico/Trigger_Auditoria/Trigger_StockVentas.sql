
---TRIGGER PARA INSERTAR  UNA VENTA

CREATE TRIGGER TR_producto_venta_insert
 ON Producto_Venta
 AFTER INSERT
 AS
 BEGIN
    SET NOCOUNT ON;

    -- Verificar que todos los productos tengan stock suficiente
     IF EXISTS (
        SELECT 1
         FROM Producto p
            INNER JOIN (
               SELECT
                  id_producto,
                  SUM(cantidad) AS cantidad_vendida
               FROM inserted
               GROUP BY id_producto
         ) i
           ON p.id_producto = i.id_producto
           WHERE p.stock_actual < i.cantidad_vendida
         )
        BEGIN
           ROLLBACK TRANSACTION;

           THROW 50001,
                'Stock insuficiente. No se puede registrar la venta.',
               1;
        END;

    --- Descontar del stock las cantidades vendidas
        UPDATE p
        SET p.stock_actual = p.stock_actual - i.cantidad_vendida
        FROM Producto p
          INNER JOIN (
              SELECT
                id_producto,
                SUM(cantidad) AS cantidad_vendida
             FROM inserted
             GROUP BY id_producto
        ) i
           ON p.id_producto = i.id_producto;
      END;

--- verificar que le trigger se creo correctamente
SELECT
    name,
    is_disabled
FROM sys.triggers
WHERE name = 'TR_producto_venta_insert';



---PRUEBA DE REGISTRO DE VENTA
BEGIN TRANSACTION;

-- Crear un comprobante de prueba
INSERT INTO Comprobante (id_comprobante, numero, fecha, estado_)
VALUES (9, 1009, '2026-10-26', 'Pendiente');

-- Registrar una venta de prueba
INSERT INTO Venta (
    id_venta, fecha_, total, id_metodo,
    id_comprobante, id_cliente, id_vendedor
)
VALUES (9, '2026-10-26', 2000.00, 1, 9, 1, 1);

--  Insertar el detalle: 2 Potus a $1000 cada uno
INSERT INTO Producto_Venta (
    precio_unitario, cantidad, sub_total,
    id_producto, id_venta
)
VALUES (1000.00, 2, 2000.00, 1, 9);


-- Comprobar el stock durante la prueba
SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;

-- Deshacer todos los cambios de la prueba
ROLLBACK TRANSACTION;

-- Comprobar el stock final
SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;




---PRUEBA AL REALIZAR UNA VENTA CON STOCK INSUFICIENTE
BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Producto_Venta (
        precio_unitario,
        cantidad,
        sub_total,
        id_producto,
        id_venta
    )
    VALUES (1000.00, 46, 46000.00, 1, 8);

    COMMIT TRANSACTION;

    PRINT 'La venta se registro correctamente.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'La venta fue rechazada:';
    PRINT ERROR_MESSAGE();
END CATCH;


SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;



---REALIZAR VENTAS CON MODIFICACIONES Y ELIMINACION

CREATE OR ALTER TRIGGER TR_producto_venta_insert
ON Producto_Venta
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

    -- Verificar que ningún producto quede con stock negativo.
    IF EXISTS (
        SELECT 1
        FROM Producto AS p
        INNER JOIN @Cambios AS c
            ON p.id_producto = c.id_producto
        WHERE p.stock_actual + c.cambio_stock < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;

        THROW 50002,
              'Stock insuficiente. No se puede realizar la operacion.',
              1;
    END;

    -- Aplicar los cambios al stock.
    UPDATE p
    SET p.stock_actual = p.stock_actual + c.cambio_stock
    FROM Producto AS p
    INNER JOIN @Cambios AS c
        ON p.id_producto = c.id_producto;
END;



---PRUEBA DE MODIFICACION
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Producto_Venta
    SET cantidad = cantidad + 1,
        sub_total = (cantidad + 1) * precio_unitario
    WHERE id_producto = 10
      AND id_venta = 8;

    SELECT nombre, stock_actual
    FROM Producto
    WHERE id_producto = 10;

    ROLLBACK TRANSACTION;

    PRINT 'Prueba revertida correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT ERROR_MESSAGE() AS mensaje_error;
END CATCH;

SELECT nombre, stock_actual
FROM Producto
WHERE id_producto = 10;



---PRUEBA DE ELIMINACION
BEGIN TRY
    BEGIN TRANSACTION;

    -- Eliminar temporalmente el detalle de la venta 8
    DELETE FROM Producto_Venta
    WHERE id_producto = 10
      AND id_venta = 8;

    -- Comprobar el stock durante la prueba
    SELECT nombre, stock_actual
    FROM Producto
    WHERE id_producto = 10;

    -- Revertir la prueba
    ROLLBACK TRANSACTION;

    PRINT 'Prueba revertida correctamente.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT ERROR_MESSAGE() AS mensaje_error;
END CATCH;

-- Comprobar el stock definitivo
SELECT nombre, stock_actual
FROM Producto
WHERE id_producto = 10;





