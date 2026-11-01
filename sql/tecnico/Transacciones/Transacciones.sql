/*
============================================================
PROYECTO: VERDE ENCANTO
MATERIA: BASE DE DATOS I
ETAPA V: IMPLEMENTACION DE TEMAS TECNICOS

TEMA: MANEJO DE TRANSACCIONES Y TRANSACCIONES ANIDADAS
============================================================

OBJETIVO:
Demostrar el uso de transacciones en SQL Server para
mantener la consistencia de los datos ante operaciones
exitosas y errores.

PRUEBAS REALIZADAS:

1. Ensayo con ROLLBACK voluntario.
2. Transaccion exitosa con COMMIT.
   - Verificacion de los datos confirmados.
3. Error intencional con ROLLBACK.
   - Verificacion de los datos revertidos.
4. Transacciones anidadas con COMMIT interno
   y ROLLBACK externo.

INSTRUCCIONES DE EJECUCION:

- Utilizar la base de datos VERDE_ENCANTO.
- Ejecutar las pruebas por bloques, en el orden indicado.
- Las pruebas 1 y 2 utilizan la venta 9 y el comprobante 9.
- La prueba 2 debe ejecutarse una sola vez sobre una base
  que todavia no contenga esos registros.
- La verificacion posterior a la prueba 2 permite
  comprobar los datos confirmados.
- La prueba fallida utiliza la venta 10 y el comprobante 10.
- La prueba de transacciones anidadas revierte sus cambios.
- No ejecutar nuevamente los INSERT de la venta 9 si
  esa venta ya existe en la base de datos.

RESULTADOS OBTENIDOS:

- Venta 9 registrada por $7500.
- Stock del producto 1 actualizado de 25 a 22.
- Error intencional: registros 10 revertidos.
- Transacciones anidadas: stock temporal de 19,
  restaurado a 22 mediante ROLLBACK.
- Sin transacciones abiertas al finalizar las pruebas.

NOTA:
Los resultados corresponden a las pruebas realizadas
sobre los datos utilizados durante el desarrollo.
============================================================
*/

USE VERDE_ENCANTO;
GO

-- ============================================
-- ESTADO INICIAL: ANTES DE LAS PRUEBAS
-- ============================================
-- Se verifica el stock del producto 1 y que
-- la venta 9 y el comprobante 9 no existan.
-- Ejecutar antes de registrar la venta 9.

SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;

SELECT id_venta, total
FROM Venta
WHERE id_venta = 9;

SELECT id_comprobante, numero
FROM Comprobante
WHERE id_comprobante = 9;

SELECT id_producto, id_venta, cantidad
FROM Producto_Venta
WHERE id_venta = 9;

-- ============================================
-- PRUEBA 1: ENSAYO CON ROLLBACK VOLUNTARIO
-- ============================================
-- Se simula el registro de una venta completa.
-- Los cambios se revierten voluntariamente
-- para comprobar que no quedan datos guardados.

SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- Crear comprobante
    INSERT INTO Comprobante
        (id_comprobante, numero, fecha, estado_)
    VALUES
        (9, 1009, '2026-04-06', 'Pagado');

    -- Registrar venta
    INSERT INTO Venta
        (id_venta, fecha_, total, id_metodo,
         id_comprobante, id_cliente, id_vendedor)
    VALUES
        (9, '2026-04-06', 7500.00, 1, 9, 1, 1);

    -- Registrar detalle
    INSERT INTO Producto_Venta
        (precio_unitario, cantidad, sub_total,
         id_producto, id_venta)
    VALUES
        (2500.00, 3, 7500.00, 1, 9);

    -- Actualizar stock
    UPDATE Producto
    SET stock_actual = stock_actual - 3
    WHERE id_producto = 1
      AND estado = 'ACTIVO'
      AND stock_actual >= 3;

    IF @@ROWCOUNT <> 1
        THROW 50001, 'Stock insuficiente o producto inactivo.', 1;

    -- Mostrar resultados antes de revertir
    SELECT id_venta, total
    FROM Venta
    WHERE id_venta = 9;

    SELECT id_producto, nombre, stock_actual
    FROM Producto
    WHERE id_producto = 1;

    -- Ensayo: no guardar cambios todavía
    ROLLBACK TRANSACTION;

    PRINT 'Ensayo exitoso: cambios revertidos voluntariamente.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error: ' + ERROR_MESSAGE();
    THROW;
END CATCH;

-- ============================================
-- PRUEBA 2: TRANSACCION EXITOSA CON COMMIT
-- ============================================
-- Se registra un comprobante, una venta y su detalle.
-- Se actualiza el stock del producto.
-- COMMIT confirma todos los cambios.

SET XACT_ABORT ON;
GO

BEGIN TRY
    -- Evitar ejecutar dos veces la misma prueba
    IF EXISTS (SELECT 1 FROM Venta WHERE id_venta = 9)
       OR EXISTS (SELECT 1 FROM Comprobante
                  WHERE id_comprobante = 9 OR numero = 1009)
       OR EXISTS (SELECT 1 FROM Producto_Venta WHERE id_venta = 9)
        THROW 50002, 'La venta o el comprobante de prueba ya existe.', 1;

    BEGIN TRANSACTION;

    -- 1. Crear comprobante
    INSERT INTO Comprobante
        (id_comprobante, numero, fecha, estado_)
    VALUES
        (9, 1009, '2026-04-06', 'Pagado');

    -- 2. Registrar venta
    INSERT INTO Venta
        (id_venta, fecha_, total, id_metodo,
         id_comprobante, id_cliente, id_vendedor)
    VALUES
        (9, '2026-04-06', 7500.00, 1, 9, 1, 1);

    -- 3. Registrar detalle de venta
    INSERT INTO Producto_Venta
        (precio_unitario, cantidad, sub_total,
         id_producto, id_venta)
    VALUES
        (2500.00, 3, 7500.00, 1, 9);

    -- 4. Descontar stock
    UPDATE Producto
    SET stock_actual = stock_actual - 3
    WHERE id_producto = 1
      AND estado = 'ACTIVO'
      AND stock_actual >= 3;

    IF @@ROWCOUNT <> 1
        THROW 50001, 'Stock insuficiente o producto inactivo.', 1;

    COMMIT TRANSACTION;

    PRINT 'EXITO: venta registrada y transaccion confirmada.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERROR: ' + ERROR_MESSAGE();
    THROW;
END CATCH;

-- ============================================
-- PRUEBA EXITOSA: VERIFICACION DESPUES DEL COMMIT
-- ============================================
-- 1. Comprobante registrado
SELECT id_comprobante, numero, fecha, estado_
FROM Comprobante
WHERE id_comprobante = 9;

-- 2. Venta registrada
SELECT id_venta, fecha_, total, id_cliente, id_vendedor
FROM Venta
WHERE id_venta = 9;

-- 3. Detalle de la venta
SELECT id_producto, id_venta, cantidad,
       precio_unitario, sub_total
FROM Producto_Venta
WHERE id_venta = 9;

-- 4. Stock actualizado
SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;

-- 5. Comprobar que no quedan transacciones abiertas
SELECT @@TRANCOUNT AS transacciones_abiertas;


-- ============================================
-- PRUEBA 3: ERROR INTENCIONAL Y ROLLBACK
-- ============================================

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar comprobante
    INSERT INTO Comprobante
        (id_comprobante, numero, fecha, estado_)
    VALUES
        (10, 1010, '2026-04-07', 'Pagado');

    -- 2. Insertar venta
    INSERT INTO Venta
        (id_venta, fecha_, total, id_metodo,
         id_comprobante, id_cliente, id_vendedor)
    VALUES
        (10, '2026-04-07', 5000.00, 1, 10, 1, 1);

    -- 3. Actualizar el stock del producto 1
    UPDATE Producto
    SET stock_actual = stock_actual - 2
    WHERE id_producto = 1
      AND estado = 'ACTIVO'
      AND stock_actual >= 2;

    IF @@ROWCOUNT <> 1
        THROW 50003, 'Stock insuficiente o producto inactivo.', 1;

    -- 4. Provocar un error intencional
    -- El error ocurre despues de dos INSERT y un UPDATE.
    -- ROLLBACK debe revertir las tres operaciones.
    THROW 50001, 'ERROR INTENCIONAL: prueba de ROLLBACK.', 1;

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ROLLBACK ejecutado: cambios revertidos.';
    PRINT ERROR_MESSAGE();

END CATCH;


-- ============================================
-- PRUEBA 3: VERIFICACION DESPUES DEL ROLLBACK
-- ============================================

-- Comprobar que el comprobante 10 no existe
SELECT id_comprobante, numero
FROM Comprobante
WHERE id_comprobante = 10;

-- Comprobar que la venta 10 no existe
SELECT id_venta, total
FROM Venta
WHERE id_venta = 10;

-- Comprobar que tampoco existe detalle de la venta 10
SELECT id_producto, id_venta, cantidad
FROM Producto_Venta
WHERE id_venta = 10;

-- Comprobar que el stock no fue modificado
SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;

-- Comprobar que no quedaron transacciones abiertas
SELECT @@TRANCOUNT AS transacciones_abiertas;


-- ============================================
-- PRUEBA 4: TRANSACCIONES ANIDADAS
-- COMMIT INTERNO Y ROLLBACK EXTERNO
-- ============================================
-- Se utiliza el producto 1 (Potus).
-- El COMMIT interno no confirma definitivamente
-- los cambios mientras exista una transaccion externa.
-- El ROLLBACK externo revierte todos los cambios.

SELECT @@TRANCOUNT AS transacciones_abiertas;

SELECT id_producto, nombre, stock_actual
FROM Producto
WHERE id_producto = 1;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Transaccion externa: modificar stock
    UPDATE Producto
    SET stock_actual = stock_actual - 2
    WHERE id_producto = 1;

    PRINT 'Transaccion externa iniciada.';

    -- Transaccion interna
    BEGIN TRANSACTION;

    UPDATE Producto
    SET stock_actual = stock_actual - 1
    WHERE id_producto = 1;

    PRINT 'Transaccion interna iniciada.';

    -- Confirmar la transaccion interna
    COMMIT TRANSACTION;

    PRINT 'COMMIT interno ejecutado.';

    -- Comprobar el estado antes del ROLLBACK
    SELECT stock_actual AS stock_antes_rollback
    FROM Producto
    WHERE id_producto = 1;

    SELECT @@TRANCOUNT AS transacciones_activas;

    -- Revertir la transaccion externa
    ROLLBACK TRANSACTION;

    PRINT 'ROLLBACK externo ejecutado.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT ERROR_MESSAGE();
END CATCH;

-- Verificacion final
SELECT stock_actual AS stock_final
FROM Producto
WHERE id_producto = 1;

SELECT @@TRANCOUNT AS transacciones_abiertas;